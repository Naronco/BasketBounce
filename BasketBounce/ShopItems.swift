//
//  ShopItems.swift
//  BasketBounce
//
//  Created by Johannes Roth on 06.04.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation
import SpriteKit

class ShopItems {
    private(set) var allItems = [String: [ShopItem]]()
    
    var categories: [String] {
        return Array(allItems.keys)
    }
    
    subscript(category: String) -> [ShopItem]? {
        return allItems[category]
    }
    
    subscript(id: Int) -> ShopItem? {
        for category in allItems.values {
            for item in category {
                if item.id == id {
                    return item
                }
            }
        }
        return nil
    }
    
    func startLoading() {
        println(NSStringFromClass(BasketballNode.self))
        
        let jsonFilePath = NSBundle.mainBundle().pathForResource("ShopItems", ofType: "json")!
        let jsonFileContents = String(contentsOfFile: jsonFilePath, encoding: NSUTF8StringEncoding, error: nil)!
        let jsonFileData = jsonFileContents.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let categories = NSJSONSerialization.JSONObjectWithData(jsonFileData, options: NSJSONReadingOptions.allZeros, error: nil) as [String: [[String: AnyObject]]]
        
        for (category, items) in categories {
            allItems[category] = []
            
            for item in items {
                let id = item["id"] as Int
                let iconName = item["iconName"] as String
                let type = item["type"] as String
                
                let icon = SKTexture(imageNamed: iconName, filteringMode: .Nearest)
                
                switch type {
                case "Ball":
                    let information = item["information"] as [String: AnyObject]
                    let textureName = information["textureName"] as String
                    let restitution = information["restitution"] as CGFloat
                    let pushPower = information["pushPower"] as CGFloat
                    
                    let texture = SKTexture(imageNamed: textureName, filteringMode: .Nearest)
                    
                    // TODO: Color
                    let shopItem = BallShopItem(id: id, icon: icon) { BallNode(texture: texture, mainColor: UIColor.whiteColor()/*!!!*/, restitution: restitution, pushPower: pushPower) }
                    allItems[category]!.append(shopItem)
                    
                case "Theme":
                    let shopItem = ThemeShopItem(id: id, icon: icon)
                    allItems[category]!.append(shopItem)
                    
                default:
                    break
                }
            }
        }
    }
}
