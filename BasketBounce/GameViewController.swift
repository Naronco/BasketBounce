//
//  GameViewController.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import UIKit
import SpriteKit

let GameSceneInstance = GameScene(size: UIScreen.mainScreen().bounds.size)
let ShopSceneInstance = ShopScene(gameScene: GameSceneInstance)
let ScoresSceneInstance = ScoresScene(gameScene: GameSceneInstance)

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        
        GameSceneInstance.scaleMode = .AspectFill
        ShopSceneInstance.scaleMode = .AspectFill
        ScoresSceneInstance.scaleMode = .AspectFill
        
        skView.presentScene(GameSceneInstance)
        
        switch __WORDSIZE {
        case 32:
            println("32bit")
        case 64:
            println("64bit")
        default:
            break
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("didReceiveMemoryWarning")
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
