//
//  LabelNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 17.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

public enum HorizontalTextAlignment {
    case Left, Right, Center
}

public enum VerticalTextAlignment {
    case Top, Bottom, Center
}

public class LabelNode: SKNode {
    public var font: Font
    
    private var horizontalAlignmentOffsets = [CGFloat]()
    private var verticalAlignmentOffset = CGFloat()
    
    public var horizontalTextAlignment: HorizontalTextAlignment = .Center {
        didSet {
            updateHorizontalAlignmentOffset()
        }
    }
    
    public var verticalTextAlignment: VerticalTextAlignment = .Center {
        didSet {
            updateVerticalAlignmentOffset()
        }
    }
    
    public var textUpdatingEnabled = true
    
    public var text: String = "" {
        didSet {
            if !textUpdatingEnabled {
                return
            }
            
            removeAllChildren()
            
            textUpdatingEnabled = false
            let colorValues = text.extractColorValuesWithIndicator("&")
            textUpdatingEnabled = true
            
            let textLength = text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            
            while textLength > children.count {
                let characterNode = LabelCharacterNode(font: font, character: " ")
                addChild(characterNode)
            }
            
            updateHorizontalAlignmentOffset()
            updateVerticalAlignmentOffset()
            
            var horizontalAlignmentOffsetIndex = 0
            var offset = CGPoint(x: horizontalAlignmentOffsets[horizontalAlignmentOffsetIndex], y: verticalAlignmentOffset)
            var color = UIColor.whiteColor()
//            var colorValue: Int?
//            var recentlyChangedColor = false
            
            for (index, character) in enumerate(text) {
                switch character {
                case "\n":
                    offset.x = horizontalAlignmentOffsets[++horizontalAlignmentOffsetIndex]
                    offset.y -= font.defaultCharacterSize.height
                    continue
//                case "&":
//                    if index != textLength - 1 {
//                        let nextCharacter = text[advance(text.startIndex, index + 1)]
//                        colorValue = Int(string: String(nextCharacter), radix: 16)
//                        recentlyChangedColor = true
//                        continue
//                    }
                default:
                    break
                }
                
//                if let colorValue = colorValue {
//                    color = UIColor(fourBitColor: colorValue)
//                }
                
//                if recentlyChangedColor {
//                    recentlyChangedColor = false
//                    continue
//                }
                
                if let newColor = colorValues[index] {
                    color = newColor
                }
                
                let characterNode = children[index] as LabelCharacterNode
                
                characterNode.character = character
                characterNode.position = offset
                
                characterNode.colorBlendFactor = 1.0
                characterNode.color = color
                
                offset.x += font.characterSizes[character]!.width
            }
        }
    }
    
    public init(font: Font) {
        self.font = font
        
        super.init()
        
        horizontalTextAlignment = .Center
        verticalTextAlignment = .Center
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateHorizontalAlignmentOffset() {
        let lines = text.split("\n")
        horizontalAlignmentOffsets = [CGFloat](count: lines.count + 1, repeatedValue: 0)
        
        for (index, line) in enumerate(lines) {
            switch horizontalTextAlignment {
            case .Left:
                horizontalAlignmentOffsets[index] = font.defaultCharacterSize.width * 0.5
            case .Right:
                horizontalAlignmentOffsets[index] = font.defaultCharacterSize.width * 0.5 - font.sizeOfLine(line).width
            case .Center:
                horizontalAlignmentOffsets[index] = (font.defaultCharacterSize.width - font.sizeOfLine(line).width) * 0.5
            }
        }
    }
    
    private func updateVerticalAlignmentOffset() {
        switch verticalTextAlignment {
        case .Top:
            verticalAlignmentOffset = -font.defaultCharacterSize.height * 0.5
        case .Bottom:
            verticalAlignmentOffset = -font.defaultCharacterSize.height * 0.5 + font.sizeOfText(text).height
        case .Center:
            verticalAlignmentOffset = (-font.defaultCharacterSize.height + font.sizeOfText(text).height) * 0.5
        }
    }
}
