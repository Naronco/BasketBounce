//
//  ColorPalette.swift
//  BasketBounce
//
//  Created by Johannes Roth on 05.04.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation
import UIKit

class ColorPalette {
    enum ColorType: Int {
        case Red = 0, Green, Blue, Yellow, Orange, Brown, Gray
    }
    
    struct Shade {
        let colorType: ColorType
        let shade: Int
        let color: UIColor
        
        weak var palette: ColorPalette?
        
        var darker: Shade {
            if shade == 0 { return self }
            return palette?.color(colorType, withShade: shade - 1) ?? self
        }
        
        var brighter: Shade {
            if let palette = palette { if shade == palette.shadesPerColor - 1 { return self } }
            return palette?.color(colorType, withShade: shade + 1) ?? self
        }
    }
    
    let shadesPerColor: Int
    private(set) var colors: [UIColor]
    
    convenience init?(imageNamed imageName: String, shadesPerColor: Int) {
        if let image = UIImage(named: imageName) {
            self.init(image: image, shadesPerColor: shadesPerColor)
        } else {
            self.init()
            return nil
        }
    }
    
    init() {
        shadesPerColor = 0
        colors = [UIColor]()
    }
    
    init(image: UIImage, shadesPerColor: Int) {
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        
        self.shadesPerColor = shadesPerColor
        self.colors = [UIColor](count: width * height, repeatedValue: UIColor.whiteColor())
        
        let data = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
        let pixelData = CFDataGetBytePtr(data)
        
        for var x = 0; x < width; ++x {
            for var y = 0; y < height; ++y {
                let index = (x + y * width) << 2
                let r = CGFloat(pixelData[index + 0]) / 255
                let g = CGFloat(pixelData[index + 1]) / 255
                let b = CGFloat(pixelData[index + 2]) / 255
                colors[x + y * width] = UIColor(red: r, green: g, blue: b, alpha: 1)
            }
        }
    }
    
    func color(colorType: ColorType, withShade shade: Int) -> Shade {
        assert(shade < shadesPerColor, "\(__FUNCTION__): Parameter shade (\(shade)) has to be lower than shadesPerColor (\(shadesPerColor))")
        let x = colorType.rawValue / (shadesPerColor << 1) + shade
        let y = colorType.rawValue % (shadesPerColor << 1)
        return Shade(colorType: colorType, shade: shade, color: colors[x + y * (shadesPerColor << 1)], palette: self)
    }
}

extension ColorPalette.Shade: Printable {
    var description: String {
        return "&\(color.hexadecimalStringSansAlpha)"
    }
}
