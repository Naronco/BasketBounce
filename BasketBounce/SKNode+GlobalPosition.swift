//
//  SKNode+GlobalPosition.swift
//  BasketBounce
//
//  Created by Johannes Roth on 27.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

extension SKNode {
    var globalPosition: CGPoint {
        var globalPosition = position
        
        var nextParent = parent
        while nextParent != nil {
            globalPosition.x += nextParent!.position.x
            globalPosition.y += nextParent!.position.y
            
            nextParent = nextParent!.parent
        }
        
        return globalPosition
    }
    
    func positionInNode(otherNode: SKNode) -> CGPoint {
        return globalPosition - otherNode.globalPosition
    }
}
