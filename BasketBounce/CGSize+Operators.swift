//
//  CGSize+Operators.swift
//  BasketBounce
//
//  Created by Johannes Roth on 19.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import CoreGraphics

internal func * (a: CGSize, b: CGSize) -> CGSize {
    return CGSize(width: a.width * b.width, height: a.height * b.height)
}

internal func * (a: CGSize, b: CGFloat) -> CGSize {
    return CGSize(width: a.width * b, height: a.height * b)
}

internal func * (a: CGFloat, b: CGSize) -> CGSize {
    return CGSize(width: a * b.width, height: a * b.height)
}
