//
//  GameScene.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit

let ButtonTexture = SKTexture(imageNamed: "Button", filteringMode: .Nearest)
let SmallButtonTexture = SKTexture(imageNamed: "SmallButton", filteringMode: .Nearest)

let SwitchTextures = [false: SKTexture(imageNamed: "SwitchOff", filteringMode: .Nearest), true: SKTexture(imageNamed: "SwitchOn", filteringMode: .Nearest)]

let SmallFont = Font(fontNamed: "SmallFont")!
let RegularFont = Font(fontNamed: "RegularFont")!
let BigFont = Font(fontNamed: "BigFont")!

let InGamePixelSize = CGSize(width: UIScreen.mainScreen().bounds.size.width / 80.0, aspectRatio: 1)

let BackgroundTexture = SKTexture(imageNamed: "Background", filteringMode: .Nearest)

let SkySpaceTransitionTexture = SKTexture(imageNamed: "SkySpaceTransition", filteringMode: .Nearest)
let SpaceTexture = SKTexture(imageNamed: "Space", filteringMode: .Nearest)
let SpaceMoonTexture = SKTexture(imageNamed: "SpaceMoon", filteringMode: .Nearest)

let PlayTexture = SKTexture(imageNamed: "Play", filteringMode: .Nearest)

enum GameState {
    case MainMenu
    case InGame
    case GameOver
}

class GameScene: SKScene {
    let gameStateQueue = StateQueue(state: GameState.MainMenu, changeDuration: 0.6)
    let globalNode = SKNode()
    
    var ballNode: BallNode? = (DefaultShopItems[Statistics.selectedIDInShopCategory("Balls")] as! BallShopItem).instantiateBallNode()
    
    let floorNode = FloorNode()
    let voidNode = VoidNode()
    let leftWallNode = InvisibleWallNode()
    let rightWallNode = InvisibleWallNode()
    let cameraNode = SKNode()
    
    let nearParallaxBackgroundNode = ParallaxBackgroundNode(distance: 4.0)
    let farParallaxBackgroundNode = ParallaxBackgroundNode(distance: 16.0)
    
    var levelGenerator: LevelGenerator!
    
    let guiLayerNode = SKNode()
    let titleLabel = LabelNode(font: BigFont)
    let gameOverLabel = LabelNode(font: BigFont)
    let playButton = ButtonNode(texture: ButtonTexture)
    let scoreButton = ButtonNode(texture: SmallButtonTexture)
    let shopButton = ButtonNode(texture: SmallButtonTexture)
    
    let inGameScoreCounterLabel = LabelNode(font: RegularFont)
    
    let scoreLabel = LabelNode(font: RegularFont)
    let instructionLabel = LabelNode(font: SmallFont)
    
    var gameState: GameState = .MainMenu {
        didSet {
            switch gameState {
            case .InGame:
                guiLayerNode.runAction(SKAction.fadeAlphaTo(0, duration: 0.5), completion: { self.guiLayerNode.position.y = self.size.height })
                
                scoreButton.enabled = false
                shopButton.enabled = false
                
                //                scoreLabel.removeAllActions()
                
                //                let scoreLabelMoveAction = SKAction.moveToY((size.height - RegularFont.defaultCharacterSize.height) * 0.5, duration: 0.5)
                //                scoreLabelMoveAction.timingMode = .EaseInEaseOut
                
                //                scoreLabel.runAction(scoreLabelMoveAction)
                //                scoreLabel.runAction(SKAction.scaleTo(1, duration: 0.5))
                
                oldHighscore = Statistics.highscore
                score = 0
                
                //                scoreLabel.text = "Score: &e%ac"
                //                scoreLabel.runAction(SKAction.countFrom(score, to: 0, duration: 0.5))
                
                inGameScoreCounterLabel.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
                
            case .MainMenu:
                let titleLabelMoveAction = SKAction.moveByX(size.width, y: 0, duration: 0.5)
                titleLabelMoveAction.timingMode = .EaseInEaseOut
                
                gameOverLabel.runAction(titleLabelMoveAction)
                
                titleLabel.position.x = -size.width
                titleLabel.runAction(titleLabelMoveAction)
                
                scoreLabel.removeActionForKey("Bumping")
                scoreLabel.runAction(SKAction.moveToY(-size.height * 0.5 + PixelSize.height * 54, duration: 0.5))
                scoreLabel.text = "Highscore: \(DefaultColorPalette.color(.Yellow, withShade: 8))\(Statistics.highscore)"
                scoreLabel.xScale = 1
                scoreLabel.yScale = 1
                
                playButton.enabled = false
                
                playButton.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                scoreButton.runAction(SKAction.fadeAlphaTo(1, duration: 0.5), completion: { self.scoreButton.enabled = true })
                shopButton.runAction(SKAction.fadeAlphaTo(1, duration: 0.5), completion: { self.shopButton.enabled = true })
                
                instructionLabel.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
                
                cameraNode.enumerateChildNodesWithName("BallPiece", usingBlock: { node, stop in
                    node.removeFromParent()
                })
                
                if ballNode == nil {
                    levelGenerator.reset()
                    
                    reloadBallNode()
                    
                    voidNode.position.y = ballNode!.position.y - 0.5 * (size.height + voidNode.size.height)
                }
                
            case .GameOver:
                titleLabel.position.x = size.width
                
                let gameOverLabelMoveAction = SKAction.moveToX(0, duration: 0.5)
                gameOverLabelMoveAction.timingMode = .EaseOut
                
                gameOverLabel.position.x = -size.width
                gameOverLabel.runAction(gameOverLabelMoveAction)
                
                gameOverLabel.text = "&fb790cG&FFFFFFAME &fb790cO&FFFFFFVER"
                
                guiLayerNode.position.y = 0
                guiLayerNode.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
                
                instructionLabel.alpha = 0
                
                scoreButton.alpha = 0
                scoreButton.enabled = false
                
                shopButton.alpha = 0
                shopButton.enabled = false
                
                playButton.runAction(SKAction.fadeAlphaTo(1, duration: 0.5), completion: { self.playButton.enabled = true })
                
                scoreLabel.position = CGPoint(x: 0, y: 0)
                scoreLabel.text = "Score: \(DefaultColorPalette.color(.Yellow, withShade: 8))\(score)\n&FFFFFFHighscore: \(DefaultColorPalette.color(.Yellow, withShade: 8))\(Statistics.highscore)"
                
                if score > oldHighscore {
                    let scaleBigAction = SKAction.scaleTo(1.3, duration: 0.4)
                    scaleBigAction.timingMode = .EaseInEaseOut
                    
                    let scaleSmallAction = SKAction.scaleTo(1, duration: 0.4)
                    scaleSmallAction.timingMode = .EaseInEaseOut
                    
                    let bumpAction = SKAction.repeatActionForever(SKAction.sequence([scaleBigAction, scaleSmallAction]))
                    scoreLabel.runAction(bumpAction, withKey: "Bumping")
                }
                
                inGameScoreCounterLabel.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
            }
        }
    }
    
    var oldHighscore = Statistics.highscore
    var score: Int {
        didSet {
            if score > Statistics.highscore {
                Statistics.highscore = score
            }
            
            inGameScoreCounterLabel.text = "\(DefaultColorPalette.color(.Yellow, withShade: 8))\(score)"
        }
    }
    
    var screenshot: UIImage!
    
    override init(size: CGSize) {
        self.score = 0
        
        super.init(size: size)
        
        gameStateQueue.changedStateAction = { newState in self.gameState = newState }
    
        backgroundColor = DefaultColorPalette.color(.Blue, withShade: 11).color
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -UIScreen.mainScreen().bounds.size.width * 0.4 * 0.05)
        
        globalNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        addChild(globalNode)
        
        globalNode.addChild(cameraNode)
        
        ballNode!.position.y = ballNode!.size.radius
        ballNode!.delegate = self
        
        cameraNode.addChild(ballNode!)
        
        cameraNode.position.y = -ballNode!.position.y
        
        cameraNode.addChild(floorNode)
        
        leftWallNode.position.x = -InvisibleWallSize.width
        globalNode.addChild(leftWallNode)
        
        rightWallNode.position.x = InvisibleWallSize.width
        globalNode.addChild(rightWallNode)
        
        nearParallaxBackgroundNode.cameraNode = cameraNode
        
        globalNode.addChild(nearParallaxBackgroundNode)
        
        let backgroundFloorNode = SKSpriteNode(texture: BackgroundTexture, size: CGSize(width: size.width, aspectRatio: 0.5))
        backgroundFloorNode.position = CGPoint(x: 0, y: -InGamePixelSize.height * 64.0)
        nearParallaxBackgroundNode.addChild(backgroundFloorNode)
        
        farParallaxBackgroundNode.cameraNode = cameraNode
        
        globalNode.addChild(farParallaxBackgroundNode)
        
        let skyElements = [
            BackgroundElement(texture: SkyTexture),
            BackgroundElement(texture: SkyTexture),
            BackgroundElement(texture: SkyTexture),
            BackgroundElement(texture: SkySpaceTransitionTexture),
            BackgroundElement(texture: SpaceTexture),
            BackgroundElement(texture: SpaceTexture),
            BackgroundElement(texture: SpaceMoonTexture),
            BackgroundElement(texture: SpaceTexture, repeating: true)
        ]
        farParallaxBackgroundNode.repeatWithElements(skyElements, startPosition: CGPoint(x: 0, y: SkyTexture.size().height * 3.0))
        
        voidNode.position = CGPoint(x: 0, y: -cameraNode.position.y - size.height * 0.5 - voidNode.size.height * 0.5)
        voidNode.zPosition = 0.5
        
        cameraNode.addChild(voidNode)
        
        levelGenerator = LevelGenerator(gameScene: self)

        guiLayerNode.zPosition = 10
        
        globalNode.addChild(guiLayerNode)
        
        playButton.position = CGPoint(x: 0, y: -size.height * 0.5 + PixelSize.height * 64)
        playButton.alpha = 0
        
        playButton.logo = PlayTexture
        playButton.delegate = self
        playButton.enabled = false
        
        guiLayerNode.addChild(playButton)
        
        scoreButton.position = CGPoint(x: -PixelSize.width * 20, y: -size.height * 0.5 + PixelSize.height * 32)
        
        scoreButton.logo = SKTexture(imageNamed: "Score", filteringMode: .Nearest)
        scoreButton.delegate = self
        
        guiLayerNode.addChild(scoreButton)
        
        shopButton.position = CGPoint(x: PixelSize.width * 20, y: -size.height * 0.5 + PixelSize.height * 32)
        
        shopButton.logo = SKTexture(imageNamed: "Shop", filteringMode: .Nearest)
        shopButton.delegate = self
        
        guiLayerNode.addChild(shopButton)
        
        let orangeColor = DefaultColorPalette.color(.Orange, withShade: 9)
        
        titleLabel.position = CGPoint(x: 0, y: size.height * 0.25)
        titleLabel.text = "\(orangeColor)B&FFFFFFASKET \n \(orangeColor)B&FFFFFFOUNCE"
        
        guiLayerNode.addChild(titleLabel)
        
        let firstRotationAction = SKAction.rotateToAngle(-0.05, duration: 4.0)
        firstRotationAction.timingMode = .EaseInEaseOut
        
        let secondRotationAction = SKAction.rotateToAngle(0.05, duration: 4.0)
        secondRotationAction.timingMode = .EaseInEaseOut
        
        let titleLabelAction = SKAction.repeatActionForever(SKAction.sequence([firstRotationAction, secondRotationAction]))
        titleLabel.runAction(titleLabelAction)
        
        gameOverLabel.position = CGPoint(x: -size.width, y: size.height * 0.25)
        gameOverLabel.text = "GAME OVER"
        
        guiLayerNode.addChild(gameOverLabel)
        
        gameOverLabel.runAction(titleLabelAction)
        
        scoreLabel.position = CGPoint(x: 0, y: -size.height * 0.5 + PixelSize.height * 54)
        scoreLabel.zPosition = 1
        
        scoreLabel.text = "Highscore: \(DefaultColorPalette.color(.Yellow, withShade: 8))\(Statistics.highscore)"
        
        guiLayerNode.addChild(scoreLabel)
        
        let copyrightLabel = LabelNode(font: SmallFont)
        
        copyrightLabel.position = CGPoint(x: 0, y: -size.height * 0.5)
        
        copyrightLabel.horizontalTextAlignment = .Center
        copyrightLabel.verticalTextAlignment = .Bottom
        copyrightLabel.text = "(c) Naronco 2015"
        
        guiLayerNode.addChild(copyrightLabel)
        
        instructionLabel.position = CGPoint(x: 0, y: -PixelSize.height * 32)
        instructionLabel.zPosition = 1
        
        instructionLabel.text = "Tap to play!"
        
        guiLayerNode.addChild(instructionLabel)
        
        let moveUpAction = SKAction.moveByX(0, y: PixelSize.height * 8.0, duration: 0.5)
        moveUpAction.timingMode = .EaseInEaseOut
        
        let moveDownAction = SKAction.moveByX(0, y: -PixelSize.height * 8.0, duration: 0.5)
        moveDownAction.timingMode = .EaseInEaseOut
        
        instructionLabel.runAction(SKAction.repeatActionForever(SKAction.sequence([moveUpAction, moveDownAction])))
        
        inGameScoreCounterLabel.position = CGPoint(x: -size.width * 0.5 + PixelSize.width * 4.0, y: size.height * 0.5 - PixelSize.height * 4.0)
        inGameScoreCounterLabel.zPosition = 1
        inGameScoreCounterLabel.alpha = 0
        
        inGameScoreCounterLabel.horizontalTextAlignment = .Left
        inGameScoreCounterLabel.verticalTextAlignment = .Top
        inGameScoreCounterLabel.text = "\(DefaultColorPalette.color(.Yellow, withShade: 8))0"
        
        globalNode.addChild(inGameScoreCounterLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        reloadBallNode()
    }
    
    override func update(currentTime: NSTimeInterval) {
    }
    
    override func didSimulatePhysics() {
        if let ballNode = ballNode {
            cameraNode.position.y = -ballNode.position.y
            
            let y = ballNode.position.y - size.height * 0.5 - voidNode.size.height * 0.5
            if y > voidNode.position.y {
                voidNode.position.y = y
            }
            
            if ballNode.position.y + ballNode.size.radius < voidNode.position.y + voidNode.size.height * 0.5 {
                ballNode.explode()
                gameStateQueue.changeStateTo(.GameOver)
            }
            
            nearParallaxBackgroundNode.update()
            farParallaxBackgroundNode.update()
        }
        
        levelGenerator.update()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = convertPointFromView(touch.locationInView(view))
        
        let nodes = nodesAtPoint(location) as! [SKNode]
        
        for node in nodes {
            if let ballNode = node as? BallNode {
                if gameState != .InGame {
                    gameStateQueue.changeStateTo(.InGame)
                }
                
                let ballNodePosition = location - ballNode.globalPosition
                
                let horizontalPushPower = -ballNodePosition.x / ballNode.size.radius * 200.0
                let pushPower = levelGenerator.distanceBetweenSections * 0.75
                ballNode.physicsBody?.velocity = CGVector(dx: horizontalPushPower*pushPower*0.0025, dy: 1*pushPower) * ballNode.pushPower
                ballNode.physicsBody?.angularVelocity = -horizontalPushPower * 0.000005*pushPower
                
                break
            }
        }
    }
    
    func reloadBallNode() {
        ballNode?.removeFromParent()
        
        ballNode = (DefaultShopItems[Statistics.selectedIDInShopCategory("Balls")] as! BallShopItem).instantiateBallNode()
        
        ballNode!.position.y = ballNode!.size.radius
        ballNode!.delegate = self
        
        cameraNode.addChild(ballNode!)
    }
    
    func takeScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.125)
        view?.drawViewHierarchyInRect(view!.bounds, afterScreenUpdates: true)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let transform = CGAffineTransformIdentity
        let clampFilter = CIFilter(name: "CIAffineClamp")
        clampFilter.setValue(CIImage(CGImage: viewImage.CGImage), forKey: kCIInputImageKey)
        clampFilter.setValue(NSValue(CGAffineTransform: transform), forKey: kCIInputTransformKey)
        
        let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")
        gaussianBlurFilter.setDefaults()
        gaussianBlurFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
        gaussianBlurFilter.setValue(5, forKey: kCIInputRadiusKey)
        
        let outputImage = gaussianBlurFilter.outputImage
        let context = CIContext(options: nil)
        let finalCGImage = context.createCGImage(outputImage, fromRect: CIImage(CGImage: viewImage.CGImage).extent())
        
        return UIImage(CGImage: finalCGImage)!
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBeginContact(contact: SKPhysicsContact) {
        if let contactDelegate = contact.bodyA.node as? ContactDelegate {
            if contact.bodyB.node != nil {
                contactDelegate.handleContactWithNode(contact.bodyB.node!)
            }
        }
        
        if let contactDelegate = contact.bodyB.node as? ContactDelegate {
            if contact.bodyA.node != nil {
                contactDelegate.handleContactWithNode(contact.bodyA.node!)
            }
        }
    }
}

extension GameScene: ButtonNodeDelegate {
    func buttonNodePressed(buttonNode: ButtonNode) {
        switch buttonNode {
        case playButton:
            gameStateQueue.changeStateTo(.MainMenu)
        case scoreButton:
            screenshot = takeScreenshot()
            view?.presentScene(ScoresSceneInstance, transition: SKTransition.pushWithDirection(.Right, duration: 0.5))
        case shopButton:
            screenshot = takeScreenshot()
            view?.presentScene(ShopSceneInstance, transition: SKTransition.pushWithDirection(.Left, duration: 0.5))
        default:
            break
        }
    }
}

extension GameScene: BallNodeDelegate {
    func ballNodeDidExplode(ballNode: BallNode) {
        self.ballNode = nil
    }
}
