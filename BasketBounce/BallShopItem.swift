//
//  BallShopItem.swift
//  BasketBounce
//
//  Created by Johannes Roth on 21.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

class BallShopItem: ShopItem {
    var instantiateBallNode: (() -> BallNode)
    
    init(id: Int, icon: SKTexture, instantiateBallNode: (() -> BallNode)) {
        self.instantiateBallNode = instantiateBallNode
        
        super.init(id: id, icon: icon)
    }
    
    override func shopItemNodeDidLoad(shopItemNode: ShopItemNode) {
        super.shopItemNodeDidLoad(shopItemNode)
        
        shopItemNode.delegate = self
        
        let firstRotationAction = SKAction.rotateToAngle(-0.1, duration: 3.0)
        firstRotationAction.timingMode = .EaseInEaseOut
        
        let secondRotationAction = SKAction.rotateToAngle(0.1, duration: 3.0)
        secondRotationAction.timingMode = .EaseInEaseOut
        
        shopItemNode.runAction(SKAction.repeatActionForever(SKAction.sequence([firstRotationAction, secondRotationAction])))
    }
}

extension BallShopItem: ShopItemNodeDelegate {
    func shopItemNode(shopItemNode: ShopItemNode, pressedInShopScene shopScene: ShopScene) {
        shopScene.setSelectedShopItem(self, inCategory: "Balls")
    }
}
