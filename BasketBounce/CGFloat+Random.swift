//
//  CGFloat+Random.swift
//  BasketBounce
//
//  Created by Johannes Roth on 21.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(Int.random) / CGFloat(Int.max)
    }
    
    static func randomFrom(fromValue: CGFloat, to toValue: CGFloat) -> CGFloat {
        return random * (toValue - fromValue) + fromValue
    }
}
