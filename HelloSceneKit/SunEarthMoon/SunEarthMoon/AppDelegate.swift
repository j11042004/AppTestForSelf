//
//  AppDelegate.swift
//  SunEarthMoon
//
//  Created by Uran on 2018/3/6.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NSLog("App 被建立拉")
        UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.alert,UNAuthorizationOptions.badge,UNAuthorizationOptions.sound ,UNAuthorizationOptions.carPlay]) { (success, error) in
            DispatchQueue.main.async {
                application.applicationIconBadgeNumber = 0
            }
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 20
        NSLog("App 癱瘓拉")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        NSLog("App 要進教堂拉")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        NSLog("App 復活拉")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NSLog("App 會動拉")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 1080
        // 實機測試
        NSLog("App 要投胎拉")
    }

}

