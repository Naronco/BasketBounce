//
//  TennisballNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 21.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

let TennisballTexture = SKTexture(imageNamed: "Tennisball", filteringMode: .Nearest)

class TennisballNode: BallNode {
    init() {
        super.init(texture: TennisballTexture, mainColor: UIColor.yellowColor(), restitution: 0.9, pushPower: 1.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
