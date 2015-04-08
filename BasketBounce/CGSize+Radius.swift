//
//  CGSize+Radius.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import CoreGraphics

extension CGSize {
    var radius: CGFloat {
        return width * 0.5
    }
    
    init(radius: CGFloat) {
        self.init(width: radius * 2, height: radius * 2)
    }
}
