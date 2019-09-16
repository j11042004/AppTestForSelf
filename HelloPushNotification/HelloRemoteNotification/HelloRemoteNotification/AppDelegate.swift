//
//  AppDelegate.swift
//  HelloRemoteNotification
//
//  Created by Uran on 2018/4/10.
//  Copyright © 2018年 Uran. All rights reserved.
//
/**
 *　　　　　　　　┏┓　　　┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　　┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 ████━████   ┃+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ + + + +
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ +
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　　┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　　　┃┫┫　┃┫┫
 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 */
import UIKit
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let unNoteCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 在程式一啟動即詢問使用者是否接受圖文(alert)、聲音(sound)、數字(badge)三種類型的通知
        unNoteCenter.requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                print("允許")
            } else {
                print("不允許")
            }
        })
        unNoteCenter.delegate = self
        let notiSets = self.setCategories()
        unNoteCenter.setNotificationCategories(notiSets)
        
        // 註冊遠程通知
        application.registerForRemoteNotifications()
        
        
        return true
    }

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
        application.applicationIconBadgeNumber = 0
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    

}

extension AppDelegate:UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("register Fail : \(error.localizedDescription)")
    }
//  向 Apple 註冊 device token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 將Data轉成String，取得 Device Token
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceTokenString: \(deviceTokenString)")
        
//        let tokenNsData = deviceToken as NSData
//        let tokenStr = NSString.init(format: "%@", tokenNsData)
//        
//        NSLog("tokenStr : \(tokenStr)")
        //MARK: 一般在此上傳device token
    }
    // userNotification 收到 訊息
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("response ID:\(response.actionIdentifier)")
        if response.actionIdentifier == "inputAction" {
            if let responseText = response as? UNTextInputNotificationResponse{
                print("從 Notification 輸入的訊息：\(responseText.userText)")
            }
        }else{
            let receiveNotification = response.notification
            let receiveRequest = receiveNotification.request
            let content = receiveRequest.content
            let receiveTitle = content.title
            let receiveSubtitle = content.subtitle
            let receiveBody = content.body
            //MARK:- 將訊息存起或發送出去
            NSLog("receive Title : \(receiveTitle) , subTitle : \(receiveSubtitle) , body :\(receiveBody)")
        }
        
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("App 在前景收到通知")
        completionHandler([.badge,.sound,.alert])
    }
    /// Notification 一些功能設定
    func setCategories() -> Set<UNNotificationCategory>{
        var set = Set<UNNotificationCategory>()
        let defaultAction = UNNotificationAction(identifier: "defaultAction", title: "defaultAction", options: [])
        let foregroundAction = UNNotificationAction(identifier: "foregroundAction", title: "foregroundAction", options: [.foreground])
        let authAction = UNNotificationAction(identifier: "authAction", title: "authAction", options: [.destructive,.authenticationRequired])
        let inputAction = UNTextInputNotificationAction(identifier: "inputAction", title: "回覆", options: [])
        // 此處 Category Identifier 要與 UNNoteContentExtension 中的 info.plist 中的 Category 相同
        let category = UNNotificationCategory(identifier: "myNotificationCategory", actions: [defaultAction,foregroundAction,authAction,inputAction], intentIdentifiers: [], options: [])
        set.insert(category)
        
        return set
    }
}

