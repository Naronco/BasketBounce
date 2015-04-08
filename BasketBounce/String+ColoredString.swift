//
//  String+ColoredString.swift
//  BasketBounce
//
//  Created by Johannes Roth on 04.04.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation
import UIKit

extension String {
    mutating func extractColorValuesWithIndicator(colorIndicator: Character) -> [Int: UIColor] {
        var colorValues = [Int: UIColor]()
        var stringSansColorValues = ""
        
        let length = lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        stringSansColorValues.reserveCapacity(length)
        
        for var index = startIndex; index < endIndex; ++index {
            let character = self[index]
            
            if character == colorIndicator {
                let oldIndex = index
                index = advance(index, 1)
                
                let colorStringEndIndex = advance(index, 6, endIndex)
                let colorString = substringWithRange(Range(start: index, end: colorStringEndIndex))
                
                if let intValue = Int(string: colorString, radix: 16) {
                    colorValues[stringSansColorValues.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)] = UIColor(hexadecimalValue: 0xFF000000 | UInt32(intValue))
                }
                
                index = colorStringEndIndex.predecessor()
                
                continue
            }
            
            stringSansColorValues.append(character)
        }
        
        self = stringSansColorValues
        
        return colorValues
    }
}
