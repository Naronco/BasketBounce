//
//  NailNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 19.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

let NailTexture = SKTexture(imageNamed: "Nail", filteringMode: .Nearest)
let NailSize = CGSize(height: UIScreen.mainScreen().bounds.size.width * 0.3 * 32.0 / 24.0, aspectRatio: 0.25)
let NailPhysicsBodySize = CGSize(height: UIScreen.mainScreen().bounds.size.width * 0.28, aspectRatio: 4.0 / 24.0)

class NailNode: SKSpriteNode {
    unowned let gameScene: GameScene
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        
        super.init(texture: NailTexture, color: UIColor.whiteColor(), size: NailSize)
        
        anchorPoint = CGPoint(x: 0.5, y: 7.0 / 32.0)
        
        physicsBody = SKPhysicsBody(rectangleOfSize: NailPhysicsBodySize, center: CGPoint(x: 0, y: NailPhysicsBodySize.height * 0.5))
        physicsBody!.dynamic = false
        
        physicsBody!.categoryBitMask = CategoryBitMask.Nail.rawValue
        physicsBody!.contactTestBitMask = ContactTestBitMask.Basketball.rawValue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NailNode: ContactDelegate {
    func handleContactWithNode(node: SKNode) {
        if let ballNode = node as? BallNode {
            ballNode.explode()
            gameScene.gameStateQueue.changeStateTo(.GameOver)
        }
    }
}
