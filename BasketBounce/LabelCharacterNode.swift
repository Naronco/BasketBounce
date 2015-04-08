//
//  LabelCharacterNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 17.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

public class LabelCharacterNode: SKSpriteNode {
    public var font: Font
    
    public var character: Character {
        didSet {
            texture = font.characterTextures[character]
        }
    }
    
    public init(font: Font, character: Character) {
        self.font = font
        self.character = character
        
        super.init(texture: font.characterTextures[character], color: UIColor.whiteColor(), size: font.defaultCharacterSize)
        
        colorBlendFactor = 1.0
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
