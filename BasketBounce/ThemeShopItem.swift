//
//  ThemeShopItem.swift
//  BasketBounce
//
//  Created by Johannes Roth on 06.04.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation
import SpriteKit

class ThemeShopItem: ShopItem {
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

extension ThemeShopItem: ShopItemNodeDelegate {
    func shopItemNode(shopItemNode: ShopItemNode, pressedInShopScene shopScene: ShopScene) {
        shopScene.setSelectedShopItem(self, inCategory: "Themes")
    }
}
