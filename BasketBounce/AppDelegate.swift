//
//  AppDelegate.swift
//  BasketBounce
//
//  Created by Johannes Roth on 16.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import UIKit
import SpriteKit

let DefaultColorPalette = ColorPalette(imageNamed: "ColorPalette", shadesPerColor: 16)!

let DefaultShopItems = ShopItems()

let __IPHONEOS_VERSION = UIDevice.currentDevice().systemVersion.compare("8.0.0", options: .NumericSearch) == .OrderedAscending ? 7 : 8

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        CoinImage3D.startLoading()
        BirdBodyImage3D.startLoading()
        BirdWingImage3D.startLoading()
        
//        RegisterShopItem(BallShopItem(icon: BasketballTexture, instantiateBallNode: { BasketballNode() }), withID: 0)
//        RegisterShopItem(BallShopItem(icon: TennisballTexture, instantiateBallNode: { TennisballNode() }), withID: 1)
//        RegisterShopItem(BallShopItem(icon: BaseballTexture, instantiateBallNode: { BaseballNode() }), withID: 2)
//        
//        RegisterShopItem(ThemeShopItem(icon: SKTexture(imageNamed: "ThemeThumbnail", filteringMode: .Nearest)), withID: 128)

        DefaultShopItems.startLoading()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
