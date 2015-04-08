//
//  Coin3DNode.swift
//  BasketBounce
//
//  Created by Johannes Roth on 25.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import SpriteKit
import SceneKit

let CoinTexture = SKTexture(imageNamed: "Coin", filteringMode: .Nearest)
let CoinImage3D = Image3D(image: UIImage(named: "Coin")!)

let CoinSize = CoinTexture.size() * InGamePixelSize

class Coin3DNode: SK3DNode {
    unowned let gameScene: GameScene
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        
        super.init(viewportSize: CoinSize)
        
        scnScene = SCNScene()
        
        pointOfView = SCNNode()
        pointOfView.position = SCNVector3(x: 0, y: 0, z: 10)
        
        pointOfView.camera = SCNCamera()
        pointOfView.camera!.usesOrthographicProjection = true
        pointOfView.camera!.orthographicScale = 1
        
        scnScene.rootNode.addChildNode(pointOfView)
        
        let s1 = valueForKey("_scnRenderer") as SCNRenderer?
        println("\(s1)")
        
        let coin3DNodeMaterial = SCNMaterial()
        coin3DNodeMaterial.diffuse.contents = CoinTexture
        
        let coin3DNode = SCNNode()
        CoinImage3D.didFinishLoading {
            coin3DNode.geometry = CoinImage3D.SCNGeometry
            coin3DNode.geometry!.materials = [coin3DNodeMaterial]
        }
        
        coin3DNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: Float.randomFrom(0, to: Float(M_PI) * 2))
        coin3DNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByAngle(CGFloat(M_PI) * 2, aroundAxis: SCNVector3(x: 0, y: 1, z: 0), duration: 3.0)))
        
        scnScene.rootNode.addChildNode(coin3DNode)
        
        physicsBody = SKPhysicsBody(circleOfRadius: CoinSize.radius)
        physicsBody!.dynamic = false
        
        physicsBody!.categoryBitMask = CategoryBitMask.Coin.rawValue
        physicsBody!.collisionBitMask = 0
        physicsBody!.contactTestBitMask = CategoryBitMask.Basketball.rawValue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Coin3DNode: ContactDelegate {
    func handleContactWithNode(node: SKNode) {
        if node is BallNode {
            gameScene.score++
            
            if let parent = parent {
                let itemCollectEffectNode = ItemCollectEffectNode(colors: [UIColor.whiteColor()])
                
                itemCollectEffectNode.position = position
                itemCollectEffectNode.zPosition = 1
                
                parent.addChild(itemCollectEffectNode)
                
                removeFromParent()
            }
        }
    }
}
