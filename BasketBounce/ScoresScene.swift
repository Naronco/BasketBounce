//
//  ScoresScene.swift
//  BasketBounce
//
//  Created by Johannes Roth on 07.04.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation
import SpriteKit

class ScoresScene: SKScene {
    unowned let gameScene: GameScene
    
    let returnButton = ButtonNode(texture: ButtonTexture)
    
    let backgroundImage = SKSpriteNode()
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        
        super.init(size: gameScene.size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        backgroundImage.size = size
        backgroundImage.zPosition = -15
        
        addChild(backgroundImage)
        
        returnButton.position = CGPoint(x: 0, y: -size.height * 0.5 + TileSize.height * 1.5)
        returnButton.delegate = self
        
        returnButton.logo = PlayTexture
        
        addChild(returnButton)
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        backgroundImage.texture = SKTexture(image: gameScene.screenshot)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScoresScene: ButtonNodeDelegate {
    func buttonNodePressed(buttonNode: ButtonNode) {
        let transition = SKTransition.pushWithDirection(.Left, duration: 0.5)
        view?.presentScene(GameSceneInstance, transition: transition)
    }
}
