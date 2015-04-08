//
//  SKAction+LabelNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 19.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

public extension SKAction {
    public static func countFrom(fromValue: Int, to toValue: Int, duration: NSTimeInterval) -> SKAction {
        var templateString: String?
        return SKAction.customActionWithDuration(duration, actionBlock: { node, passedTime in
            if let label = node as? LabelNode {
                if templateString == nil {
                    templateString = label.text
                }
                
                let value = fromValue + Int(passedTime / CGFloat(duration) * CGFloat(toValue - fromValue))
                label.text = templateString!.stringByReplacingOccurrencesOfString("%ac", withString: "\(value)")
            }
        })
    }
}
