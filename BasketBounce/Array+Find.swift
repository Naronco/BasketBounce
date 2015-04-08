//
//  Array+Find.swift
//  BasketBounce
//
//  Created by Johannes Roth on 22.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation

extension Array {
    func find(value: T, _ compare: (T, T) -> Bool) -> Int? {
        for (index, element) in enumerate(self) {
            if compare(value, element) {
                return index
            }
        }
        return nil
    }
}
