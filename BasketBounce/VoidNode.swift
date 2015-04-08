//
//  VoidNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 24.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

let VoidTexture = SKTexture(imageNamed: "Void", filteringMode: .Nearest)

class VoidNode: SKSpriteNode {
    override init() {
        super.init(texture: VoidTexture, color: UIColor.whiteColor(), size: CGSize(width: UIScreen.mainScreen().bounds.size.width, aspectRatio: 0.5))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
