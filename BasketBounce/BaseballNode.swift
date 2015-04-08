//
//  BaseballNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 22.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

let BaseballTexture = SKTexture(imageNamed: "Baseball", filteringMode: .Nearest)

class BaseballNode: BallNode {
    init() {
        super.init(texture: BaseballTexture, mainColor: UIColor.whiteColor(), restitution: 0.6, pushPower: 1.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
