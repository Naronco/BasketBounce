//
//  SkyNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 26.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

let SkyTexture = SKTexture(imageNamed: "Sky", filteringMode: .Nearest)
let SkySize = CGSize(width: UIScreen.mainScreen().bounds.size.width, aspectRatio: SkyTexture.size().aspectRatio)

class SkyNode: SKSpriteNode {
    init() {
        super.init(texture: SkyTexture, color: UIColor.whiteColor(), size: SkySize)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
