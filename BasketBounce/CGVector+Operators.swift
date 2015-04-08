//
//  CGVector+Operators.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import CoreGraphics

extension CGVector {
    var squaredLength: CGFloat {
        return dx * dx + dy * dy
    }
    
    var length: CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    
    var normalized: CGVector {
        return self / length
    }
    
    mutating func normalize() {
        self /= length
    }
}

func * (a: CGVector, b: CGFloat) -> CGVector {
    return CGVector(dx: a.dx * b, dy: a.dy * b)
}

func * (a: CGFloat, b: CGVector) -> CGVector {
    return CGVector(dx: a * b.dx, dy: a * b.dy)
}

func / (a: CGVector, b: CGFloat) -> CGVector {
    let ib = 1.0 / b
    return CGVector(dx: a.dx * ib, dy: a.dy * ib)
}

func /= (inout a: CGVector, b: CGFloat) {
    a = a / b
}
