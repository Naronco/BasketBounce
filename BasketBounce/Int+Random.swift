//
//  Int+Random.swift
//  BasketBounce
//
//  Created by Johannes Roth on 19.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation

protocol RandomValueGenerator {
    static var random: Self { get }
}

extension UInt32: RandomValueGenerator {
    static var random: UInt32 {
        return arc4random()
    }
}

extension Int32: RandomValueGenerator {
    static var random: Int32 {
        return Int32(arc4random_uniform(UInt32(Int32.max)))
    }
}

extension UInt64: RandomValueGenerator {
    static var random: UInt64 {
        return (UInt64(arc4random()) << 32) | UInt64(arc4random())
    }
}

extension Int64: RandomValueGenerator {
    static var random: Int64 {
        return (Int64(Int32.random) << 32) | Int64(Int32.random)
    }
}

extension UInt: RandomValueGenerator {
    static var random: UInt {
        switch __WORDSIZE {
        case 32: return UInt(UInt32.random)
        case 64: return UInt(UInt64.random)
        default: return 0
        }
    }
}

extension Int: RandomValueGenerator {
    static var random: Int {
        switch __WORDSIZE {
        case 32: return Int(Int32.random)
        case 64: return Int(Int64.random)
        default: return 0
        }
    }
    
    static func random(maxValue: Int) -> Int {
        return Int.random % maxValue
    }
    
    static func randomFrom(fromValue: Int, to toValue: Int) -> Int {
        return (Int.random % (toValue - fromValue)) + fromValue
    }
}
