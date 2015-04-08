//
//  ParallaxBackgroundNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 23.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

struct BackgroundElement {
    var texture: SKTexture
    var repeating: Bool
    
    init(texture: SKTexture, repeating: Bool = false) {
        self.texture = texture
        self.repeating = repeating
    }
}

class ParallaxBackgroundNode: SKNode {
    var distance: CGFloat
    weak var cameraNode: SKNode?
    
    var currentElementNode = SKSpriteNode()
    var nextElementNode = SKSpriteNode()
    
    var elements = [BackgroundElement]()
    var currentElementIndex = 0
    
    init(distance: CGFloat) {
        self.distance = distance
        
        super.init()
        
        zPosition = -distance
        
        addChild(currentElementNode)
        addChild(nextElementNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func repeatWithElements(newElements: [BackgroundElement], startPosition: CGPoint) {
        elements = newElements
        
        if !elements.isEmpty {
            currentElementIndex = 0
            
            let currentElement = elements[currentElementIndex]
            
            currentElementNode.texture = currentElement.texture
            currentElementNode.size = CGSize(width: UIScreen.mainScreen().bounds.size.width, aspectRatio: currentElement.texture.size().aspectRatio)
            
            currentElementNode.position = startPosition
            
            if !elements[currentElementIndex].repeating {
                ++currentElementIndex
            }
            
            if currentElementIndex < elements.count {
                let nextElement = elements[currentElementIndex]
                
                nextElementNode.texture = nextElement.texture
                nextElementNode.size = CGSize(width: UIScreen.mainScreen().bounds.size.width, aspectRatio: nextElement.texture.size().aspectRatio)
                
                nextElementNode.position = currentElementNode.position + CGPoint(x: 0, y: (currentElementNode.size.height + nextElementNode.size.height) * 0.5)
            }
        }
    }
    
    func update() {
        if let cameraNode = cameraNode {
            position = CGPoint(x: cameraNode.position.x / distance, y: cameraNode.position.y / distance)
            
            if !elements.isEmpty && currentElementNode.globalPosition.y + currentElementNode.size.height * 0.5 < 0 {
                currentElementNode.position.y += currentElementNode.size.height + nextElementNode.size.height
                swap(&self.currentElementNode, &self.nextElementNode)
                
                if !elements[currentElementIndex].repeating {
                    ++currentElementIndex
                }
                
                if currentElementIndex < elements.count {
                    let nextElement = elements[currentElementIndex]
                    
                    nextElementNode.texture = nextElement.texture
                    nextElementNode.size = CGSize(width: UIScreen.mainScreen().bounds.size.width, aspectRatio: nextElement.texture.size().aspectRatio)
                }
            }
        }
    }
}
