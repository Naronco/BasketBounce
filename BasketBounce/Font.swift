//
//  Font.swift
//  BasketBounce
//
//  Created by Johannes Roth on 17.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

internal let FontCharactersPerRow = 16
internal let FontCharactersPerColumn = 16
internal let FontUnitSpaceCharacterSize = CGSize(width: 1.0 / CGFloat(FontCharactersPerRow), height: 1.0 / CGFloat(FontCharactersPerColumn))

public class Font {
    public var characterTextures = [Character: SKTexture]()
    public var characterSizes = [Character: CGSize]()
    
    public var defaultCharacterSize: CGSize
    
    public init?(fontNamed fontName: String) {
        if let fontImage = UIImage(named: fontName) {
            let characterSize = CGSize(width: fontImage.size.width / CGFloat(FontCharactersPerRow), height: fontImage.size.height / CGFloat(FontCharactersPerColumn))
            
            let fontTexture = SKTexture(image: fontImage)
            fontTexture.filteringMode = .Nearest
            
            for x in 0..<FontCharactersPerRow {
                for y in 0..<FontCharactersPerColumn {
                    let unicodeValue = UnicodeScalar(x + y * FontCharactersPerRow)
                    let character = Character(unicodeValue)
                    
                    let characterRectInTexture = CGRect(x: CGFloat(x) * FontUnitSpaceCharacterSize.width, y: 1.0 - CGFloat(y + 1) * FontUnitSpaceCharacterSize.height, width: FontUnitSpaceCharacterSize.width, height: FontUnitSpaceCharacterSize.height)
                    
                    characterTextures[character] = SKTexture(rect: characterRectInTexture, inTexture: fontTexture)
                }
            }
            
            defaultCharacterSize = CGSize(width: FontUnitSpaceCharacterSize.width * fontTexture.size().width * PixelSize.width, height: FontUnitSpaceCharacterSize.height * fontTexture.size().height * PixelSize.height)
            
            let data = CGDataProviderCopyData(CGImageGetDataProvider(fontImage.CGImage))
            let pixelData = CFDataGetBytePtr(data)
            
            for y in 0..<FontCharactersPerColumn {
                let yPixel = y * Int(characterSize.height)
                
                for x in 0..<FontCharactersPerRow {
                    let unicodeValue = UnicodeScalar(x + y * FontCharactersPerRow)
                    let character = Character(unicodeValue)
                    
                    if character == " " {
                        characterSizes[character] = CGSize(width: characterSize.width * 0.5 * PixelSize.width, height: characterSize.height * PixelSize.height)
                        continue
                    }
                    
                    let xPixel = x * Int(characterSize.width)
                    
                    var measuredCharacterWidth: Int = 0
                    
                    currentCharacterLoop: for cx in stride(from: xPixel + Int(characterSize.width) - 1, to: xPixel, by: -1) {
                        for cy in yPixel..<yPixel + Int(characterSize.height) {
                            let alpha = pixelData[(Int(fontImage.size.width) * cy + cx) << 2]
                            if alpha >= 128 {
                                measuredCharacterWidth = cx - xPixel
                                break currentCharacterLoop
                            }
                        }
                    }
                    
                    let characterWidth = CGFloat(measuredCharacterWidth + 2)
                    
                    characterSizes[character] = CGSize(width: characterWidth * PixelSize.width, height: characterSize.height * PixelSize.height)
                }
            }
        } else {
            defaultCharacterSize = CGSize(width: 0, height: 0)
            
            return nil
        }
    }
    
    public func sizeOfLine(line: String) -> CGSize {
        let lineLength = line.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        
        var size = CGSize()
        var skip = false
        
        for (index, character) in enumerate(line) {
            if skip {
                skip = false
                continue
            }
            
            if character == "&" {
                if index != lineLength - 1 {
                    let nextCharacter = line[advance(line.startIndex, index + 1)]
                    skip = Int(string: String(nextCharacter), radix: 16) != nil
                    continue
                }
            }
            
            if let characterSize = characterSizes[character] {
                size.width += characterSize.width
                
                if characterSize.height > size.height {
                    size.height = characterSize.height
                }
            }
        }
        
        return size
    }
    
    public func sizeOfText(text: String) -> CGSize {
        var size = CGSize()
        
        let lines = text.split("\n")
        for line in lines {
            let lineSize = sizeOfLine(line)
            
            if lineSize.width > size.width {
                size.width = lineSize.width
            }
            
            size.height += lineSize.height
        }
        
        return size
    }
}
