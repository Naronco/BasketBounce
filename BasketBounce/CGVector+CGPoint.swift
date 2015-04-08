//
//  CGVector+CGPoint.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import CoreGraphics

extension CGVector {
    init(point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }
}
