//
//  Statistics.swift
//  BasketBounce
//
//  Created by Johannes Roth on 19.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation

class Statistics {
    class var highscore: Int {
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "HIGHSCORE")
        }
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("HIGHSCORE")
        }
    }
    
    class func setSelectedID(selectedID: Int, inShopCategory shopCategory: String) {
        NSUserDefaults.standardUserDefaults().setInteger(selectedID, forKey: shopCategory.uppercaseString + "_SELECTEDID")
    }
    
    class func selectedIDInShopCategory(shopCategory: String) -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(shopCategory.uppercaseString + "_SELECTEDID")
    }
}
