//
//  BasketBounceTests.swift
//  BasketBounceTests
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import UIKit
import XCTest

class BasketBounceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testStringColoredStringExtension() {
        var string = "&FF00FFHallo, &00FFFFWelt!"
        let colorValues = string.extractColorValuesWithIndicator("&")
        
        XCTAssertEqual(string, "Hallo, Welt!", "string != \"Hallo, Welt!\"")
        
        XCTAssert(colorValues.count == 2, "ColorValue count != 2")
        if colorValues.count != 2 {
            return
        }
        
        XCTAssert(colorValues[0] != nil, "ColorValues[0] == nil")
        if colorValues[0] == nil {
            return
        }
        
        XCTAssert(colorValues[7] != nil, "ColorValues[7] == nil")
        if colorValues[7] == nil {
            return
        }
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        colorValues[0]!.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssert(r == 1 && g == 0 && b == 1 && a == 1, "ColorValues[0] != (1, 0, 1, 1)")
        
        colorValues[7]!.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssert(r == 0 && g == 1 && b == 1 && a == 1, "ColorValues[7] != (0, 1, 1, 1)")
    }
    
    func testColorPaletteShadeDescription() {
        let colorShade = ColorPalette.Shade(colorType: .Red, shade: 0, color: UIColor.redColor(), palette: nil)
        let colorShadeDesc = "\(colorShade)"
        XCTAssertEqual(colorShadeDesc, "&ff0000", "!!!")
    }
    
    func testJSON() {
        let shopItems = ShopItems()
    }
    
}




























