//
//  UIColor+HexadecimalValue.swift
//  BasketBounce
//
//  Created by Johannes Roth on 23.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import UIKit

extension UIColor {
    var hexadecimalValue: UInt32 {
        var floatR: CGFloat = 0
        var floatG: CGFloat = 0
        var floatB: CGFloat = 0
        var floatA: CGFloat = 0
        
        getRed(&floatR, green: &floatG, blue: &floatB, alpha: &floatA)
        
        let r = UInt32(floatR * 255)
        let g = UInt32(floatG * 255)
        let b = UInt32(floatB * 255)
        let a = UInt32(floatA * 255)
        
        return (a << 24) | (r << 16) | (g << 8) | b
    }
    
    convenience init(hexadecimalValue: UInt32) {
        let a = CGFloat((hexadecimalValue >> 24) & 0xFF) / 255.0
        let r = CGFloat((hexadecimalValue >> 16) & 0xFF) / 255.0
        let g = CGFloat((hexadecimalValue >> 8) & 0xFF) / 255.0
        let b = CGFloat((hexadecimalValue) & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
