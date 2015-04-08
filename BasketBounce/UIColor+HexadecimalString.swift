//
//  UIColor+HexadecimalString.swift
//  BasketBounce
//
//  Created by Johannes Roth on 04.04.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    var hexadecimalString: String {
        return hexadecimalValue.radix(16)
    }
    
    var hexadecimalStringSansAlpha: String {
        let str = hexadecimalString
        return str.substringFromIndex(advance(str.startIndex, 2))
    }
    
    convenience init?(var colorString: String) {
        if colorString[colorString.startIndex] == "&" {
            colorString = colorString.substringFromIndex(advance(colorString.startIndex, 1))
        }
        
        let redString = colorString.substringWithRange(Range<String.Index>(start: advance(colorString.startIndex, 0), end: advance(colorString.startIndex, 2)))
        let greenString = colorString.substringWithRange(Range<String.Index>(start: advance(colorString.startIndex, 2), end: advance(colorString.startIndex, 4)))
        let blueString = colorString.substringWithRange(Range<String.Index>(start: advance(colorString.startIndex, 4), end: advance(colorString.startIndex, 6)))
        
        if let red = Int(string: redString, radix: 16) {
            // TODO: BETTER!!!!
            if let green = Int(string: greenString, radix: 16) {
                if let blue = Int(string: blueString, radix: 16) {
                    self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
                    return
                }
            }
            self.init()
            return nil
        } else {
            self.init()
            return nil
        }
    }
}
