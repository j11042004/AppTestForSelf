//
//  AppDelegate.swift
//  HelloLocalNotification
//
//  Created by Uran on 2018/4/10.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let unNoteCenter = UNUserNotificationCenter.current()
    
    let normalID = "NotiNormal"
    let forGroundID = "NotiForGroundID"
    let authRequireID = "NotiAuthenticationRequired"
    let notiInsertID = "NotiInsert"
    let notiCategoryID = "NotiCategory"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 詢問是否支援推送服務，圖文(alert)、聲音(sound)、Icon上的數字(badge)
        self.unNoteCenter.requestAuthorization(options: [.alert, .sound, .badge, .carPlay]) { (granted, error) in
            if let error = error {
                print("userNottification error : \(error.localizedDescription)")
            }
            if granted{
                print("允許使用 本地通知")
            }else{
                print("不允許使用本地通知")
            }
        }
        let notiSet = self.setCategories()
        
        // 設定 Notification 的 Categories，即 notification 下的button 與 textField
        self.unNoteCenter.setNotificationCategories(notiSet)
        self.unNoteCenter.delegate = self
        
        
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
// MARK: UNUserNotificationCenterDelegate 方法
extension AppDelegate : UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("無法收到遠端推播")
        print("get Error : \(error.localizedDescription)")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("App 在前景收到通知")
        // 若用 勿擾模式 就不會跳出 Alert
        completionHandler([.alert,.badge,.sound])
        
        // 取得正在等待被傳送的推波
        self.unNoteCenter.getPendingNotificationRequests { requestArray in
            print(requestArray.count)
        }
        // 取得已被傳送的推波
        self.unNoteCenter.getDeliveredNotifications { notifications in
            for noti in notifications{
                print(noti.request.identifier)
            }
        }
        
    }
    // 點擊通知後觸發的事件，一般未設置是開啟 app
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
        
/*
         let content : UNNotificationContent = response.notification.request.content
        // 這實作 開啟網頁
        if response.actionIdentifier == "com.apple.UNNotificationDefaultActionIdentifier" {
/*           // 要在傳送的推播那加入
             // 設定點擊通知後取得的資訊，或是傳送的網址
             content.userInfo = ["link" : "https://www.google.com.tw"]
*/
            let requestUrl = URL(string: content.userInfo["link"]! as! String)
            UIApplication.shared.open(requestUrl!, options: [:], completionHandler: nil)
        }
*/
        if let responseText = response as? UNTextInputNotificationResponse{
            print("Notification傳入的訊息：\(responseText.userText)")
        }
    }
    
    
    
    func setCategories() -> Set<UNNotificationCategory>{
        var set = Set<UNNotificationCategory>()
        
        let a1 = UNNotificationAction(identifier: normalID, title: "Normal", options: [])
        let a2 = UNNotificationAction(identifier: forGroundID, title: "將 App 叫到前景", options: [.foreground])
        let a3 = UNNotificationAction(identifier: authRequireID, title: "解鎖 iPhone，並提醒可能有破損性", options: [.destructive,.authenticationRequired])
        let a4 = UNTextInputNotificationAction(identifier: notiInsertID, title: "回覆", options: [])
        let category = UNNotificationCategory(identifier: self.notiCategoryID, actions: [a1,a2,a3,a4], intentIdentifiers: [], options: [])
        
        set.insert(category)
        
        return set
    }
}
