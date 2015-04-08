//
//  ItemCollectEffectNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 21.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

let ItemCollectEffectTextures = Array(0...2).map { SKTexture(imageNamed: "StarParticle\($0)", filteringMode: .Nearest) }

class ItemCollectEffectNode: SKNode {
    var colors: [UIColor]
    
    init(colors: [UIColor]) {
        self.colors = colors
        
        super.init()
        
        for _ in 0..<5 {
            let randomTexture = ItemCollectEffectTextures.random
            let randomColor = colors.random
            
            let particleNode = SKSpriteNode(texture: randomTexture, color: randomColor, size: randomTexture.size() * InGamePixelSize)
            
            particleNode.colorBlendFactor = 1.0
            
            let randomVector = CGVector(dx: CGFloat.randomFrom(-1.0, to: 1.0), dy: CGFloat.randomFrom(-1.0, to: 1.0)) * InGamePixelSize.width * 16.0
            let randomDuration = NSTimeInterval(CGFloat.randomFrom(0.25, to: 0.75))
            
            let distributeAction = SKAction.moveBy(randomVector, duration: randomDuration)
            distributeAction.timingMode = .EaseInEaseOut
            
            let vanishAction = SKAction.fadeAlphaTo(0, duration: randomDuration * 0.5)
            vanishAction.timingMode = .EaseOut
            
            particleNode.runAction(SKAction.sequence([SKAction.waitForDuration(randomDuration * 0.5), vanishAction]))
            particleNode.runAction(distributeAction, completion: particleNode.removeFromParent)
            
            addChild(particleNode)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
