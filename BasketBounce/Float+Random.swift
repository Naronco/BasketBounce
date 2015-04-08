//
//  Float+Random.swift
//  BasketBounce
//
//  Created by Johannes Roth on 26.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation

extension Float {
    static var random: Float {
        return Float(Int.random) / Float(Int.max)
    }
    
    static func randomFrom(fromValue: Float, to toValue: Float) -> Float {
        return random * (toValue - fromValue) + fromValue
    }
}
