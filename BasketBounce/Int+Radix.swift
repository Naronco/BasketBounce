//
//  Int+Radix.swift
//  BasketBounce
//
//  Created by Johannes Roth on 19.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation

public extension Int {
    public init?(string: String, radix: Int) {
        let digits = "0123456789abcdefghijklmnopqrstuvwxyz"
        var result = Int(0)
        for digit in string.lowercaseString {
            if let range = digits.rangeOfString(String(digit)) {
                let val = Int(distance(digits.startIndex, range.startIndex))
                if val >= radix {
                    return nil
                }
                result = result * radix + val
            } else {
                return nil
            }
        }
        self = result
    }
    
    public func radix(radix: Int) -> String {
        return String(self, radix: radix)
    }
}

extension UInt32 {
    func radix(radix: Int) -> String {
        return String(self, radix: radix)
    }
}
