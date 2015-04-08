//
//  BasketballNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

let BasketballTexture = SKTexture(imageNamed: "Basketball", filteringMode: .Nearest)

class BasketballNode: BallNode {
    init() {
        super.init(texture: BasketballTexture, mainColor: UIColor.orangeColor(), restitution: 0.8, pushPower: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
