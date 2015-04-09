//
//  FloorNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

let FloorTexture = SKTexture(imageNamed: "Floor", filteringMode: .Nearest)
let FloorSize = CGSize(width: UIScreen.mainScreen().bounds.size.width, aspectRatio: FloorTexture.size().aspectRatio)

class FloorNode: SKSpriteNode {
    init() {
        super.init(texture: FloorTexture, color: UIColor.whiteColor(), size: FloorSize)
        
        position = CGPoint(x: 0, y: -FloorSize.height * 0.5)
        
        physicsBody = SKPhysicsBody(rectangleOfSize: FloorSize)
        physicsBody!.dynamic = false
        
        physicsBody!.categoryBitMask = CategoryBitMask.Floor.rawValue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
