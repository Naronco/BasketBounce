//
//  ShopItem.swift
//  BasketBounce
//
//  Created by Johannes Roth on 21.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

class ShopItem {
    let id: Int
    var icon: SKTexture
    
    weak var node: ShopItemNode?
    
    init(id: Int, icon: SKTexture) {
        self.id = id
        self.icon = icon
    }
    
    func shopItemNodeDidLoad(shopItemNode: ShopItemNode) {
        shopItemNode.icon = icon
    }
}
