//
//  ShopItemNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 22.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

protocol ShopItemNodeDelegate {
    func shopItemNode(shopItemNode: ShopItemNode, pressedInShopScene shopScene: ShopScene)
}

class ShopItemNode: SKSpriteNode {
    unowned let shopScene: ShopScene
    
    var delegate: ShopItemNodeDelegate?
    
    var icon: SKTexture? {
        set {
            texture = newValue
            if let texture = texture {
                size = texture.size() * PixelSize * 0.8
            }
        }
        get {
            return texture
        }
    }
    
    init(shopScene: ShopScene) {
        self.shopScene = shopScene
        
        super.init(texture: nil, color: UIColor.whiteColor(), size: CGSize())
        
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        removeActionForKey("ScaleAction")
        runAction(SKAction.scaleTo(0.9, duration: 0.1), withKey: "ScaleAction")
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        removeActionForKey("ScaleAction")
        runAction(SKAction.scaleTo(1.0, duration: 0.1), withKey: "ScaleAction")
        
        delegate?.shopItemNode(self, pressedInShopScene: shopScene)
    }
}
