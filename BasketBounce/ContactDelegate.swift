//
//  ContactDelegate.swift
//  BasketBounce
//
//  Created by Johannes Roth on 20.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

@objc protocol ContactDelegate {
    func handleContactWithNode(node: SKNode)
}
