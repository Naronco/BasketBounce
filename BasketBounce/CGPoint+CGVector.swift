//
//  CGPoint+CGVector.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }
}
