//
//  SKTexture+FilterLoading.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

public extension SKTexture {
    public convenience init(imageNamed imageName: String, filteringMode: SKTextureFilteringMode) {
        self.init(imageNamed: imageName)
        self.filteringMode = filteringMode
    }
}
