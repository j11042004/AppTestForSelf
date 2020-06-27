//
//  AppDelegate.swift
//  HelloLoin
//
//  Created by Uran on 2019/11/25.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import LineSDK
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

let gidSignCliendId = "561077207651-frok48viru8vhgitodtnil8i5tbt2d3b.apps.googleusercontent.com"
let lineChannelId = "1653573902"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Link line set channel id
        if let _ = Int(lineChannelId){
            LoginManager.shared.setup(channelID: lineChannelId, universalLinkURL: nil)
        }
        GIDSignIn.sharedInstance()?.clientID = gidSignCliendId
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        return true
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if LoginManager.shared.application(application, open: userActivity.webpageURL) {
            NSLog("userActivity success")
        }
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let fbOpenUrl = ApplicationDelegate.shared.application(app, open: url, options: options)
        let lineOpenUrl = LoginManager.shared.application(app, open: url, options: options)
        let gidOpenUrl = GIDSignIn.sharedInstance()?.handle(url) == true
        return fbOpenUrl || lineOpenUrl || gidOpenUrl
    }
    
}

// MARK: - Time Circle
extension AppDelegate {
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
