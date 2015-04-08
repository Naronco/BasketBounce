//
//  LevelGenerator.swift
//  BasketBounce
//
//  Created by Johannes Roth on 21.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit
import SceneKit

class LevelGenerator {
    unowned let gameScene: GameScene
    
    var lowerNode = SKNode()
    var upperNode = SKNode()
    
    let distanceBetweenSections: CGFloat
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        self.distanceBetweenSections = gameScene.size.width * 0.4 * 7.0
        
        lowerNode.position = CGPoint(x: 0, y: distanceBetweenSections * 0.75)
        generateObjectsInNode(lowerNode)
        gameScene.cameraNode.addChild(lowerNode)
        
        upperNode.position = CGPoint(x: 0, y: lowerNode.position.y + distanceBetweenSections)
        generateObjectsInNode(upperNode)
        gameScene.cameraNode.addChild(upperNode)
    }
    
    func reset() {
        lowerNode.position = CGPoint(x: 0, y: distanceBetweenSections * 0.75)
        lowerNode.removeAllChildren()
        generateObjectsInNode(lowerNode)
        
        upperNode.position = CGPoint(x: 0, y: lowerNode.position.y + distanceBetweenSections)
        upperNode.removeAllChildren()
        generateObjectsInNode(upperNode)
    }
    
    func update() {
        if let ballNode = gameScene.ballNode {
            let cutoff = ballNode.position.y - gameScene.size.height * 0.5
            
            if lowerNode.position.y + distanceBetweenSections * 0.5 < cutoff {
                let tempUpperNode = upperNode
                upperNode = lowerNode
                lowerNode = tempUpperNode
                
                upperNode.position.y += distanceBetweenSections * 2.0
                
                upperNode.removeAllChildren()
                generateObjectsInNode(upperNode)
            }
        }
    }
    
    private func generateObjectsInNode(node: SKNode) {
        let minY = -distanceBetweenSections * 0.5 + NailSize.height
        let maxY = distanceBetweenSections * 0.5 - NailSize.height
        
        let leftNailHeight = CGFloat.randomFrom(minY, to: maxY)
        let leftNailRotation = CGFloat.randomFrom(-CGFloat(M_PI) * 0.1, to: -CGFloat(M_PI) * 0.9)
        
        let leftNailNode = NailNode(gameScene: gameScene)
        leftNailNode.position = CGPoint(x: -gameScene.size.width * 0.5, y: leftNailHeight)
        leftNailNode.zRotation = leftNailRotation
        node.addChild(leftNailNode)
        
        let rightNailHeight = CGFloat.randomFrom(minY, to: maxY)
        let rightNailRotation = CGFloat.randomFrom(CGFloat(M_PI) * 0.1, to: CGFloat(M_PI) * 0.9)
        
        let rightNailNode = NailNode(gameScene: gameScene)
        rightNailNode.position = CGPoint(x: gameScene.size.width * 0.5, y: rightNailHeight)
        rightNailNode.zRotation = rightNailRotation
        node.addChild(rightNailNode)
        
        let coinNode = Coin3DNode(gameScene: gameScene)
        coinNode.position = CGPoint(x: 0, y: (leftNailHeight + rightNailHeight) * 0.5)
        node.addChild(coinNode)
       
        if Int.random(8) == 0 {
            let birdNode = Bird3DNode(gameScene: gameScene)
            birdNode.position = CGPoint(x: 0, y: (leftNailHeight + rightNailHeight) * 0.5)
            node.addChild(birdNode)
            
            birdNode.bodyNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: 0)
            birdNode.bodyNode.position = SCNVector3(x: 2, y: 0, z: 0)
            birdNode.bodyNode.runAction(SCNAction.repeatActionForever(SCNAction.sequence([
                SCNActionEaseInEaseOut(SCNAction.moveTo(SCNVector3(x: -2, y: 0, z: 0), duration: 3)),
                SCNActionEaseInEaseOut(SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: Float(M_PI)), duration: 1)),
                SCNActionEaseInEaseOut(SCNAction.moveTo(SCNVector3(x: 2, y: 0, z: 0), duration: 3)),
                SCNActionEaseInEaseOut(SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: 0), duration: 1))
                ])))
        }
    }
}
