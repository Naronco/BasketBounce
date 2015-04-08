//
//  CGSize+AspectRatio.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import CoreGraphics

extension CGSize {
    var aspectRatio: CGFloat {
        return width / height
    }
    
    init(width: CGFloat, aspectRatio: CGFloat) {
        self.init(width: width, height: width / aspectRatio)
    }
    
    init(height: CGFloat, aspectRatio: CGFloat) {
        self.init(width: height * aspectRatio, height: height)
    }
}
