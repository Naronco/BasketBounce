//
//  Image3D.swift
//  BasketBounce
//
//  Created by Johannes Roth on 06.04.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class Image3D {
    struct Vertex {
        var position: (Float32, Float32, Float32)
        var textureCoordinate: (Float32, Float32)
        var color: (Float32, Float32, Float32, Float32)
    }
    
    typealias Index = UInt32
    
    enum Face: Int {
        case Front = 0, Back
    }
    
    var SCNGeometry: SceneKit.SCNGeometry!
    
    let width, height: Int
    let data: NSData
    let dataBytes: UnsafePointer<UInt8>
    private(set) var generated: [Bool]
    
    typealias FinishedLoadingAction = () -> Void
    private(set) var finishedLoadingActions = [FinishedLoadingAction]()
    private(set) var finishedLoading = false
    
    func didFinishLoading(action: FinishedLoadingAction) {
        if finishedLoading {
            action()
        } else {
            finishedLoadingActions.append(action)
        }
    }
    
    convenience init(image: UIImage) {
        self.init(width: Int(image.size.width), height: Int(image.size.height), data: CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage)) as NSData)
    }
    
    init(width: Int, height: Int, data: NSData) {
        self.width = width
        self.height = height
        self.data = data
        self.dataBytes = UnsafePointer<UInt8>(data.bytes)
        self.generated = [Bool](count: (width * height) << 1, repeatedValue: false)
    }
    
    func startLoading() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            var vertices: [Vertex]
            var indices: [Index]
            
            switch __WORDSIZE {
            case 64:
                (vertices, indices) = self.buildImage64()
            default:
                (vertices, indices) = self.buildImage32()
            }
            
            let vertexData = NSData(bytes: vertices, length: vertices.count * sizeof(Vertex))
            let indexData = NSData(bytes: indices, length: indices.count * sizeof(Index))
            
            let vertexSource = SCNGeometrySource(data: vertexData, semantic: SCNGeometrySourceSemanticVertex, vectorCount: vertices.count, floatComponents: true, componentsPerVector: 3, bytesPerComponent: sizeof(Float32), dataOffset: 0, dataStride: sizeof(Vertex))
            let textureCoordinateSource = SCNGeometrySource(data: vertexData, semantic: SCNGeometrySourceSemanticTexcoord, vectorCount: vertices.count, floatComponents: true, componentsPerVector: 2, bytesPerComponent: sizeof(Float32), dataOffset: sizeof(Float32) * 3, dataStride: sizeof(Vertex))
            let colorSource = SCNGeometrySource(data: vertexData, semantic: SCNGeometrySourceSemanticColor, vectorCount: vertices.count, floatComponents: true, componentsPerVector: 4, bytesPerComponent: sizeof(Float32), dataOffset: sizeof(Float32) * 5, dataStride: sizeof(Vertex))
            
            let indexSource = SCNGeometryElement(data: indexData, primitiveType: .Triangles, primitiveCount: indices.count / 3, bytesPerIndex: sizeof(UInt32))
            
            dispatch_async(dispatch_get_main_queue()) {
                self.SCNGeometry = SceneKit.SCNGeometry(sources: [vertexSource, textureCoordinateSource, colorSource], elements: [indexSource])
                self.finishedLoadingActions.map { $0() }
                self.finishedLoading = true
            }
        }
    }
    
    private func buildImage64() -> ([Vertex], [Index]) {
        var vertices = [Vertex]()
        var indices = [Index]()
        
        let inverseSize = 1.0 / Float(self.width)
        
        let darkValue = Float32(0.8)
        let darkColor = (darkValue, darkValue, darkValue, Float32(1))
        
        for var x = 0; x < self.width; ++x {
            for var y = 0; y < self.height; ++y {
                let color = self.pixelAtX(x, y: y)
                
                if color.a < 128 {
                    self.setGeneratedAtX(x, y: y, face: .Front)
                    self.setGeneratedAtX(x, y: y, face: .Back)
                    continue
                }
                
                let localX = (Float(x) * inverseSize) * 2.0 - 1.0
                let localY = (Float(y) * inverseSize) * 2.0 - 1.0
                
                let u = Float(x) * inverseSize
                let v = 1.0 - Float(y) * inverseSize
                
                ////////// FRONT
                
                var lengthX = 0
                while self.pixelAtX(x + lengthX, y: y).a > 127 && !self.isGeneratedAtX(x + lengthX, y: y, face: .Front) {
                    self.setGeneratedAtX(x + lengthX, y: y, face: .Front)
                    ++lengthX
                }
                
                var lengthY = 1
                if lengthX > 0 {
                    checkRow: while true {
                        for var xo = x; xo < x + lengthX; ++xo {
                            if self.pixelAtX(xo, y: y + lengthY).a < 128 || self.isGeneratedAtX(xo, y: y + lengthY, face: .Front) {
                                break checkRow
                            }
                        }
                        for var xo = x; xo < x + lengthX; ++xo {
                            self.setGeneratedAtX(xo, y: y + lengthY, face: .Front)
                        }
                        ++lengthY
                    }
                }
                
                if lengthX > 0 {
                    // FRONT
                    indices.append(UInt32(vertices.count) + 0)
                    indices.append(UInt32(vertices.count) + 1)
                    indices.append(UInt32(vertices.count) + 2)
                    indices.append(UInt32(vertices.count) + 0)
                    indices.append(UInt32(vertices.count) + 2)
                    indices.append(UInt32(vertices.count) + 3)
                    
                    let localLengthX = (Float(lengthX) - 0.5) * inverseSize * 2
                    let localLengthY = (Float(lengthY) - 0.5) * inverseSize * 2
                    let lengthU = Float(lengthX) * inverseSize
                    let lengthV = Float(lengthY) * inverseSize
                    
                    vertices.append(Vertex(position: (localX - inverseSize, localY - inverseSize, +inverseSize), textureCoordinate: (u, v), color: (1, 1, 1, 1)))
                    vertices.append(Vertex(position: (localX + localLengthX, localY - inverseSize, +inverseSize), textureCoordinate: (u + lengthU, v), color: (1, 1, 1, 1)))
                    vertices.append(Vertex(position: (localX + localLengthX, localY + localLengthY, +inverseSize), textureCoordinate: (u + lengthU, v - lengthV), color: (1, 1, 1, 1)))
                    vertices.append(Vertex(position: (localX - inverseSize, localY + localLengthY, +inverseSize), textureCoordinate: (u, v - lengthV), color: (1, 1, 1, 1)))
                }
                
                ////////// BACK
                
                lengthX = 0
                while self.pixelAtX(x + lengthX, y: y).a > 127 && !self.isGeneratedAtX(x + lengthX, y: y, face: .Back) {
                    self.setGeneratedAtX(x + lengthX, y: y, face: .Back)
                    ++lengthX
                }
                
                lengthY = 1
                if lengthX > 0 {
                    checkRow: while true {
                        for var xo = x; xo < x + lengthX; ++xo {
                            if self.pixelAtX(xo, y: y + lengthY).a < 128 || self.isGeneratedAtX(xo, y: y + lengthY, face: .Back) {
                                break checkRow
                            }
                        }
                        for var xo = x; xo < x + lengthX; ++xo {
                            self.setGeneratedAtX(xo, y: y + lengthY, face: .Back)
                        }
                        ++lengthY
                    }
                }
                
                if lengthX > 0 {
                    // BACK
                    indices.append(UInt32(vertices.count) + 0)
                    indices.append(UInt32(vertices.count) + 1)
                    indices.append(UInt32(vertices.count) + 2)
                    indices.append(UInt32(vertices.count) + 0)
                    indices.append(UInt32(vertices.count) + 2)
                    indices.append(UInt32(vertices.count) + 3)
                    
                    let localLengthX = (Float(lengthX) - 0.5) * inverseSize * 2
                    let localLengthY = (Float(lengthY) - 0.5) * inverseSize * 2
                    let lengthU = Float(lengthX) * inverseSize
                    let lengthV = Float(lengthY) * inverseSize
                    
                    vertices.append(Vertex(position: (localX + localLengthX, localY - inverseSize, -inverseSize), textureCoordinate: (u + lengthU, v), color: (1, 1, 1, 1)))
                    vertices.append(Vertex(position: (localX - inverseSize, localY - inverseSize, -inverseSize), textureCoordinate: (u, v), color: (1, 1, 1, 1)))
                    vertices.append(Vertex(position: (localX - inverseSize, localY + localLengthY, -inverseSize), textureCoordinate: (u, v - lengthV), color: (1, 1, 1, 1)))
                    vertices.append(Vertex(position: (localX + localLengthX, localY + localLengthY, -inverseSize), textureCoordinate: (u + lengthU, v - lengthV), color: (1, 1, 1, 1)))
                }
                
                // RIGHT
                if self.pixelAtX(x + 1, y: y).a < 128/*x == width - 1 || pixels[(((x + 1) + (height - 1 - y) * width) << 2) + 3] < 128*/ {
                    indices.append(UInt32(vertices.count) + 0)
                    indices.append(UInt32(vertices.count) + 1)
                    indices.append(UInt32(vertices.count) + 2)
                    indices.append(UInt32(vertices.count) + 0)
                    indices.append(UInt32(vertices.count) + 2)
                    indices.append(UInt32(vertices.count) + 3)
                    
                    vertices.append(Vertex(position: (localX + inverseSize, localY - inverseSize, +inverseSize), textureCoordinate: (u, v), color: darkColor))
                    vertices.append(Vertex(position: (localX + inverseSize, localY - inverseSize, -inverseSize), textureCoordinate: (u, v), color: darkColor))
                    vertices.append(Vertex(position: (localX + inverseSize, localY + inverseSize, -inverseSize), textureCoordinate: (u, v), color: darkColor))
                    vertices.append(Vertex(position: (localX + inverseSize, localY + inverseSize, +inverseSize), textureCoordinate: (u, v), color: darkColor))
                }
                
                // LEFT
                if self.pixelAtX(x - 1, y: y).a < 128/*x == 0 || pixels[(((x - 1) + (height - 1 - y) * width) << 2) + 3] < 128*/ {
                    indices.append(UInt32(vertices.count) + 0)
                    indices.append(UInt32(vertices.count) + 1)
                    indices.append(UInt32(vertices.count) + 2)
                    indices.append(UInt32(vertices.count) + 0)
                    indices.append(UInt32(vertices.count) + 2)
                    indices.append(UInt32(vertices.count) + 3)
                    
                    vertices.append(Vertex(position: (localX - inverseSize, localY + inverseSize, +inverseSize), textureCoordinate: (u, v), color: darkColor))
                    vertices.append(Vertex(position: (localX - inverseSize, localY + inverseSize, -inverseSize), textureCoordinate: (u, v), color: darkColor))
                    vertices.append(Vertex(position: (localX - inverseSize, localY - inverseSize, -inverseSize), textureCoordinate: (u, v), color: darkColor))
                    vertices.append(Vertex(position: (localX - inverseSize, localY - inverseSize, +inverseSize), textureCoordinate: (u, v), color: darkColor))
                }
                
                // TOP
                if self.pixelAtX(x, y: y + 1).a < 128/*y == 0 || pixels[((x + (height - 2 - y) * width) << 2) + 3] < 128*/ {
                    indices.append(UInt32(vertices.count) + 0)
                    indices.append(UInt32(vertices.count) + 1)
                    indices.append(UInt32(vertices.count) + 2)
                    indices.append(UInt32(vertices.count) + 0)
                    indices.append(UInt32(vertices.count) + 2)
                    indices.append(UInt32(vertices.count) + 3)
                    
                    vertices.append(Vertex(position: (localX + inverseSize, localY + inverseSize, -inverseSize), textureCoordinate: (u, v), color: darkColor))
                    vertices.append(Vertex(position: (localX - inverseSize, localY + inverseSize, -inverseSize), textureCoordinate: (u, v), color: darkColor))
                    vertices.append(Vertex(position: (localX - inverseSize, localY + inverseSize, +inverseSize), textureCoordinate: (u, v), color: darkColor))
                    vertices.append(Vertex(position: (localX + inverseSize, localY + inverseSize, +inverseSize), textureCoordinate: (u, v), color: darkColor))
                }
                
                // BOTTOM
                if self.pixelAtX(x, y: y - 1).a < 128/*y == height - 1 || pixels[((x + (height - y) * width) << 2) + 3] < 128*/ {
                    indices.append(UInt32(vertices.count) + 0)
                    indices.append(UInt32(vertices.count) + 1)
                    indices.append(UInt32(vertices.count) + 2)
                    indices.append(UInt32(vertices.count) + 0)
                    indices.append(UInt32(vertices.count) + 2)
                    indices.append(UInt32(vertices.count) + 3)
                    
                    vertices.append(Vertex(position: (localX - inverseSize, localY - inverseSize, -inverseSize), textureCoordinate: (u, v), color: darkColor))
                    vertices.append(Vertex(position: (localX + inverseSize, localY - inverseSize, -inverseSize), textureCoordinate: (u, v), color: darkColor))
                    vertices.append(Vertex(position: (localX + inverseSize, localY - inverseSize, +inverseSize), textureCoordinate: (u, v), color: darkColor))
                    vertices.append(Vertex(position: (localX - inverseSize, localY - inverseSize, +inverseSize), textureCoordinate: (u, v), color: darkColor))
                }
            }
        }
        
        return (vertices, indices)
    }
    
    private func buildImage32() -> ([Vertex], [Index]) {
        let indices: [Index] = [0, 1, 2, 0, 2, 3, 4, 5, 6, 4, 6, 7]
        let vertices: [Vertex] = [
            Vertex(position: (-1, -1, 0), textureCoordinate: (0, 1), color: (1, 1, 1, 1)),
            Vertex(position: (+1, -1, 0), textureCoordinate: (1, 1), color: (1, 1, 1, 1)),
            Vertex(position: (+1, +1, 0), textureCoordinate: (1, 0), color: (1, 1, 1, 1)),
            Vertex(position: (-1, +1, 0), textureCoordinate: (0, 0), color: (1, 1, 1, 1)),
            
            Vertex(position: (+1, -1, 0), textureCoordinate: (1, 1), color: (1, 1, 1, 1)),
            Vertex(position: (-1, -1, 0), textureCoordinate: (0, 1), color: (1, 1, 1, 1)),
            Vertex(position: (-1, +1, 0), textureCoordinate: (0, 0), color: (1, 1, 1, 1)),
            Vertex(position: (+1, +1, 0), textureCoordinate: (1, 0), color: (1, 1, 1, 1))
        ]
        return (vertices, indices)
    }
    
    func pixelAtX(x: Int, y: Int) -> (r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        if x < 0 || y < 0 || x >= width || y >= height { return (0, 0, 0, 0) }
        let index = (x + (height - 1 - y) * width) << 2
        return (dataBytes[index + 0], dataBytes[index + 1], dataBytes[index + 2], dataBytes[index + 3])
    }
    
    func isGeneratedAtX(x: Int, y: Int, face: Face) -> Bool {
        if x < 0 || y < 0 || x >= width || y >= height { return true }
        return generated[((x + y * width) << 1) + face.rawValue]
    }
    
    func setGeneratedAtX(x: Int, y: Int, face: Face) {
        generated[((x + y * width) << 1) + face.rawValue] = true
    }
}
