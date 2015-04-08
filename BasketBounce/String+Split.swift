//
//  String+Split.swift
//  BasketBounce
//
//  Created by Johannes Roth on 18.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation

internal extension String {
    internal func split(character: Character) -> [String] {
        return Swift.split(self) { $0 == character }
    }
}
