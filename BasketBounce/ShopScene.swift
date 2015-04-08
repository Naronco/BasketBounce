//
//  ShopScene.swift
//  BasketBounce
//
//  Created by Johannes Roth on 21.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

class ShopScene: SKScene {
    unowned let gameScene: GameScene
    
    var selectionNodes = [String: SKSpriteNode]()
    
    let returnButton = ButtonNode(texture: ButtonTexture)
    let backgroundImageNode = SKSpriteNode()
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        
        super.init(size: gameScene.size)
        
        backgroundImageNode.size = size
        backgroundImageNode.zPosition = -15
        
        addChild(backgroundImageNode)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        returnButton.position = CGPoint(x: 0, y: -size.height * 0.5 + TileSize.height * 1.5)
        returnButton.delegate = self
        
        returnButton.logo = PlayTexture
        
        addChild(returnButton)
        
        var sectionHeight: CGFloat = 0
        
        for (index, category) in enumerate(DefaultShopItems.categories) {
            let shopItems = DefaultShopItems[category]!
            
            sectionHeight += 3.0 * TileSize.height
            
            if !shopItems.isEmpty {
                let selectionNode = createSelectionNode()
                selectionNode.position = CGPoint(x: -size.width * 0.5 + TileSize.width * 3.0, y: size.height * 0.5 - TileSize.height * 2.5 - sectionHeight)
                addChild(selectionNode)
                
                selectionNodes[category] = selectionNode
            }
            
            if let shopItem = DefaultShopItems[Statistics.selectedIDInShopCategory(category)] {
                setSelectedShopItem(shopItem, inCategory: category)
            }
            
            let categoryLabel = LabelNode(font: SmallFont)
            
            categoryLabel.position = CGPoint(x: -size.width * 0.5 + TileSize.width, y: size.height * 0.5 - sectionHeight)
            
            categoryLabel.horizontalTextAlignment = .Left
            categoryLabel.verticalTextAlignment = .Bottom
            categoryLabel.text = category
            
            addChild(categoryLabel)
            
            for (index, shopItem) in enumerate(shopItems) {
                let shopItemNode = ShopItemNode(shopScene: self)
                
                let offset = TileSize.width * 5.0 * CGFloat(index % 3)
                let innerOffsetY = -TileSize.height * 5 * (CGFloat(index / 3) + 0.5)
                shopItemNode.position = CGPoint(x: -size.width * 0.5 + TileSize.width * 3.0 + offset, y: size.height * 0.5 + innerOffsetY - sectionHeight)
                
                addChild(shopItemNode)
                
                shopItem.node = shopItemNode
                shopItem.shopItemNodeDidLoad(shopItemNode)
            }
            
            sectionHeight += ceil(CGFloat(shopItems.count) / 3) * TileSize.height * 5
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        backgroundImageNode.texture = SKTexture(image: gameScene.screenshot)
    }
    
    func createSelectionNode() -> SKSpriteNode {
        var selectionNode = SKSpriteNode()
        
        selectionNode.texture = SKTexture(imageNamed: "Selection", filteringMode: .Nearest)
        selectionNode.size = CGSize(width: 34, height: 34) * PixelSize
        
        selectionNode.zPosition = -1
        
        return selectionNode
    }
    
    func setSelectedShopItem(shopItem: ShopItem, inCategory category: String) {
        if let shopItems = DefaultShopItems[category] {
            if let shopItemIndex = shopItems.find(shopItem, ===) {
                let x = CGFloat(shopItemIndex % 3) * TileSize.height * 5.0
                let y = CGFloat(shopItemIndex / 3) * TileSize.height * 5.0
                
                if let position = shopItem.node?.position {
                    selectionNodes[category]?.position = position
                }
                
                Statistics.setSelectedID(shopItem.id, inShopCategory: category)
            }
        }
    }
}

extension ShopScene: ButtonNodeDelegate {
    func buttonNodePressed(buttonNode: ButtonNode) {
        let transition = SKTransition.pushWithDirection(.Right, duration: 0.5)
        view?.presentScene(GameSceneInstance, transition: transition)
    }
}
