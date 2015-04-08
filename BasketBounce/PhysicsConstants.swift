//
//  PhysicsConstants.swift
//  BasketBounce
//
//  Created by Johannes Roth on 20.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation

enum ContactTestBitMask: UInt32 {
    case Basketball = 0b00000001
    case Nail = 0b00000010
    case Floor = 0b00000100
}

enum CategoryBitMask: UInt32 {
    case Basketball = 0b00000001
    case Nail = 0b00000010
    case Floor = 0b00000100
    case InvisibleWalls = 0b00001000
    case BasketballPiece = 0b00010000
    case Coin = 0b00100000
    case Bird = 0b01000000
}
