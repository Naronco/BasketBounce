//
//  ButtonNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

public let PixelSize = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ?
CGSize(width: UIScreen.mainScreen().bounds.size.width / 192.0, aspectRatio: 1) :
CGSize(width: UIScreen.mainScreen().bounds.size.width / 128.0, aspectRatio: 1)

public let TileSize = PixelSize * 8.0

public let ButtonDefaultSize = TileSize * CGSize(width: 10, height: 3)

public protocol ButtonNodeDelegate {
    func buttonNodePressed(buttonNode: ButtonNode)
}

public class ButtonNode: SKSpriteNode {
    public var delegate: ButtonNodeDelegate?
    
    public let logoNode: SKSpriteNode?
    public let labelNode: LabelNode?
    
    public var enabled = true
    
    public var logo: SKTexture? {
        didSet {
            logoNode?.texture = logo
            if let logo = logo {
                logoNode?.size = CGSize(width: PixelSize.width * logo.size().width, height: PixelSize.height * logo.size().height)
            }
        }
    }
    
    public init(texture: SKTexture) {
        self.logoNode = SKSpriteNode()
        self.labelNode = nil
        
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size() * PixelSize)
        
        userInteractionEnabled = true
        colorBlendFactor = 1.0
        zPosition = 1
        
        addChild(logoNode!)
    }
    
    public init(texture: SKTexture, font: Font) {
        self.logoNode = nil
        self.labelNode = LabelNode(font: font)
        
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size() * PixelSize)
        
        userInteractionEnabled = true
        colorBlendFactor = 1.0
        zPosition = 1
        
        addChild(labelNode!)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !enabled {
            return
        }
        
        removeAllActions()
        runAction(SKAction.scaleTo(0.9, duration: 0.1))
    }
    
    public override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        // TODO
    }
    
    public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !enabled {
            return
        }
        
        removeAllActions()
        runAction(SKAction.scaleTo(1.0, duration: 0.1))
        
        delegate?.buttonNodePressed(self)
    }
}
