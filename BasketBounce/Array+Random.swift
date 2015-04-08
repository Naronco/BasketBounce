//
//  Array+Random.swift
//  BasketBounce
//
//  Created by Johannes Roth on 21.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation

extension Array {
    var random: T {
        return self[Int.random(count)]
    }
}
