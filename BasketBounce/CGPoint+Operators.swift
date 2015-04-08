//
//  CGPoint+Operators.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import CoreGraphics

func + (a: CGPoint, b: CGPoint) -> CGPoint {
    return CGPoint(x: a.x + b.x, y: a.y + b.y)
}

func - (a: CGPoint, b: CGPoint) -> CGPoint {
    return CGPoint(x: a.x - b.x, y: a.y - b.y)
}
