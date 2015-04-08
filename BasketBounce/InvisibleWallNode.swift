//
//  InvisibleWallNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

let InvisibleWallSize = UIScreen.mainScreen().bounds.size

class InvisibleWallNode: SKNode {
    override init() {
        super.init()
        
        physicsBody = SKPhysicsBody(rectangleOfSize: InvisibleWallSize)
        physicsBody!.dynamic = false
        
        physicsBody!.categoryBitMask = CategoryBitMask.InvisibleWalls.rawValue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
