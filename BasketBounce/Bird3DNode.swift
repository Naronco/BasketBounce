//
//  Bird3DNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 04.04.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

let BirdBodyTexture = SKTexture(imageNamed: "BirdBody", filteringMode: .Nearest)
let BirdWingTexture = SKTexture(imageNamed: "BirdWing", filteringMode: .Nearest)
let BirdBodyImage3D = Image3D(image: UIImage(named: "BirdBody")!)
let BirdWingImage3D = Image3D(image: UIImage(named: "BirdWing")!)

let BirdSize = CGSize(width: 32, aspectRatio: 1) * InGamePixelSize
let BirdViewportSize = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: BirdSize.height)

internal func SCNActionEaseInEaseOut(action: SCNAction) -> SCNAction {
    action.timingMode = .EaseInEaseOut
    return action
}

class Bird3DNode: SK3DNode {
    unowned let gameScene: GameScene
    
    let bodyNode = SCNNode()
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        
        super.init(viewportSize: BirdViewportSize)
        
        scnScene = SCNScene()
        
        pointOfView = SCNNode()
        pointOfView.position = SCNVector3(x: 0, y: 0, z: 10)
        
        pointOfView.camera = SCNCamera()
        pointOfView.camera!.usesOrthographicProjection = true
        pointOfView.camera!.orthographicScale = 1
        
        scnScene.rootNode.addChildNode(pointOfView)
        
        let s1 = valueForKey("_scnRenderer") as SCNRenderer?
        println("\(s1)")
        
        let bodyMaterial = SCNMaterial()
        bodyMaterial.diffuse.contents = BirdBodyTexture
        
        bodyNode.geometry = BirdBodyImage3D.SCNGeometry
        BirdBodyImage3D.didFinishLoading {
            self.bodyNode.geometry = BirdBodyImage3D.SCNGeometry
            self.bodyNode.geometry!.materials = [bodyMaterial]
        }
        
        bodyNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: Float(M_PI) * 0.5)
//        birdBodyNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByAngle(CGFloat(M_PI) * 2, aroundAxis: SCNVector3(x: 0, y: 1, z: 0), duration: 3.0)))
        
        scnScene.rootNode.addChildNode(bodyNode)
        
        let birdWingMaterial = SCNMaterial()
        birdWingMaterial.diffuse.contents = BirdWingTexture
        
        let leftWingNode = SCNNode()
        
        BirdWingImage3D.didFinishLoading {
            leftWingNode.geometry = BirdWingImage3D.SCNGeometry
            leftWingNode.geometry!.materials = [birdWingMaterial]
        }
        
        leftWingNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: -Float(M_PI) * 0.4)
        leftWingNode.runAction(SCNAction.repeatActionForever(SCNAction.sequence([
            SCNActionEaseInEaseOut(SCNAction.rotateByAngle(-CGFloat(M_PI) * 0.3, aroundAxis: SCNVector3(x: 1, y: 0, z: 0), duration: 0.2)),
            SCNActionEaseInEaseOut(SCNAction.rotateByAngle(+CGFloat(M_PI) * 0.3, aroundAxis: SCNVector3(x: 1, y: 0, z: 0), duration: 0.2))
        ])))
    
        bodyNode.addChildNode(leftWingNode)
        
        let rightWingNode = SCNNode()
        
        BirdWingImage3D.didFinishLoading {
            rightWingNode.geometry = BirdWingImage3D.SCNGeometry
            rightWingNode.geometry!.materials = [birdWingMaterial]
        }
        
        rightWingNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(M_PI) * 0.4)
        rightWingNode.runAction(SCNAction.repeatActionForever(SCNAction.sequence([
            SCNActionEaseInEaseOut(SCNAction.rotateByAngle(+CGFloat(M_PI) * 0.3, aroundAxis: SCNVector3(x: 1, y: 0, z: 0), duration: 0.2)),
            SCNActionEaseInEaseOut(SCNAction.rotateByAngle(-CGFloat(M_PI) * 0.3, aroundAxis: SCNVector3(x: 1, y: 0, z: 0), duration: 0.2))
            ])))
        
        bodyNode.addChildNode(rightWingNode)
        
//        physicsBody = SKPhysicsBody(circleOfRadius: BirdSize.radius * 0.5)
//        physicsBody!.dynamic = false
//        
//        physicsBody!.categoryBitMask = CategoryBitMask.Bird.rawValue
//        physicsBody!.collisionBitMask = CategoryBitMask.Basketball.rawValue
//        physicsBody!.contactTestBitMask = CategoryBitMask.Basketball.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Bird3DNode: ContactDelegate {
    func handleContactWithNode(node: SKNode) {
//        if node is BallNode {
//            gameScene.score++
//            
//            if let parent = parent {
//                let itemCollectEffectNode = ItemCollectEffectNode(colors: [UIColor.whiteColor()])
//                
//                itemCollectEffectNode.position = position
//                itemCollectEffectNode.zPosition = 1
//                
//                parent.addChild(itemCollectEffectNode)
//                
//                removeFromParent()
//            }
//        }
    }
}
