//
//  AppDelegate.swift
//  HelloInAppPurchase
//
//  Created by Uran on 2018/4/23.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let iapManager : IAPManager = IAPManager.sharedInstance
    // 要先設定 productIDs 才可以取得 商品資訊
    private let productIDs : [String] = ["ios.coin.100","ios.coin.200","ios.house.house","ios.car.car"]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 新增交易觀察者
        iapManager.addNewProductObserver()
        iapManager.productsID = self.productIDs
        iapManager.requestProductFromApple()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // 移除交易觀察者
        iapManager.removeProductObserver()
        
    }


}

