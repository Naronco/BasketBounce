//
//  BallNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 21.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

let BallPiecesTexture = SKTexture(imageNamed: "BallPieces", filteringMode: .Nearest)
let BallPieceSize = InGamePixelSize * 8.0
let BallPiecePhysicsBodySize = BallPieceSize * 0.5

protocol BallNodeDelegate {
    func ballNodeDidExplode(ballNode: BallNode)
}

class BallNode: SKSpriteNode {
    let mainColor: UIColor
    var pushPower: CGFloat
    
    var delegate: BallNodeDelegate?
    
    init(texture: SKTexture, mainColor: UIColor, restitution: CGFloat, pushPower: CGFloat) {
        self.mainColor = mainColor
        self.pushPower = pushPower
        
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size() * InGamePixelSize)
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.radius)
        physicsBody!.restitution = restitution
        
        physicsBody!.categoryBitMask = CategoryBitMask.Basketball.rawValue
        physicsBody!.contactTestBitMask = 0xFFFFFFFF
        physicsBody!.collisionBitMask = 0xFFFFFFFF & (~CategoryBitMask.Coin.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func explode() {
        if let parent = parent {
            for x in 0..<4 {
                for y in 0..<4 {
                    let pushDirection = CGVector(dx: CGFloat(x) - 1.5, dy: CGFloat(y) - 1.5).normalized
                    let push = pushDirection * 1600.0 * CGFloat.randomFrom(0.5, to: 1.0) * size.radius * 0.025
                    
                    let ballPieceTexture = SKTexture(rect: CGRect(x: CGFloat(x) * 0.25, y: CGFloat(y) * 0.25, width: 0.25, height: 0.25), inTexture: BallPiecesTexture)
                    let ballPiece = SKSpriteNode(texture: ballPieceTexture, color: UIColor.whiteColor(), size: BallPieceSize)
                    
                    ballPiece.name = "BallPiece"
                    ballPiece.color = mainColor
                    ballPiece.colorBlendFactor = 1.0
                    
                    ballPiece.physicsBody = SKPhysicsBody(rectangleOfSize: BallPiecePhysicsBodySize)
                    
                    ballPiece.physicsBody!.categoryBitMask = CategoryBitMask.BasketballPiece.rawValue
                    ballPiece.physicsBody!.collisionBitMask = 0xFFFFFFFF & (~CategoryBitMask.BasketballPiece.rawValue)
                    
                    ballPiece.physicsBody!.velocity = push
                    
                    ballPiece.runAction(SKAction.moveTo(position, duration: 0.0))
                    
                    parent.addChild(ballPiece)
                }
            }
            
            removeFromParent()
            
            delegate?.ballNodeDidExplode(self)
        }
    }
}
