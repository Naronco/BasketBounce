//
//  SwitchNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 19.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

public enum SwitchState {
    case On(SKTexture)
    case Off(SKTexture)
}

public protocol SwitchNodeDelegate {
    func switchNode(switchNode: SwitchNode, switchedFrom oldState: Bool, to newState: Bool)
}

public class SwitchNode: SKSpriteNode {
    public var delegate: SwitchNodeDelegate?
    public var textures: [Bool: SKTexture]
    public var state: Bool {
        didSet {
            texture = textures[state]
        }
    }
    
    public init(textures: [Bool: SKTexture], state: Bool) {
        self.textures = textures
        self.state = state
        
        super.init(texture: textures[state], color: UIColor.whiteColor(), size: textures[state]!.size() * PixelSize)
        
        userInteractionEnabled = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        removeAllActions()
        runAction(SKAction.colorizeWithColor(UIColor(white: 0.8, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.1))
    }
    
    public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        removeAllActions()
        runAction(SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.1))
        
        state = !state
        delegate?.switchNode(self, switchedFrom: !state, to: state)
    }
}
