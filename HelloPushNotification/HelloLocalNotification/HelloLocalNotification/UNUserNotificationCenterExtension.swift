//
//  PushNotificationCenter.swift
//  HelloLocalNotification
//
//  Created by Uran on 2018/4/11.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import UserNotifications
extension UNUserNotificationCenter {
    
    /*
     通知發送的方式
     UNTimeIntervalNotificationTrigger => 每幾秒發送。
     UNCalendarNotificationTrigger => 指定日期發送。
     UNLocationNotificationTrigger => 當靠近某個位置時觸發。
     UNPushNotificationTrigger => 從後台發送。
     注意：重複發送的最短時間為 60 秒
     */
    
    
    /// 發送本地延遲推播
    ///
    /// - Parameters:
    ///   - title: 推播的標題
    ///   - subtitle: 推播的子標題
    ///   - body: 推播內容
    ///   - badge: 推播後 App Icon 上會顯示的數字
    ///   - soundName: 推波時的音效檔名，若為 nil 或是檔名錯誤會跳出預設聲音
    ///   - delayTime: 推播延遲出現的時間
    ///   - repeats: 是否會重複出現推播
    ///   - notificationID: 推播辨識的id
    func sendDelayTimeNotification(title : String? ,
                                   subtitle : String? ,
                                   body : String? ,
                                   badge: NSNumber? ,
                                   soundName:String? ,
                                   imageUrl : URL?,
                                   delayTime : TimeInterval ,
                                   repeats : Bool ,
                                   notificationID:String ){
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delayTime, repeats: repeats)
        
        self.sendNotification(title: title,
                              subtitle: subtitle,
                              body: body,
                              badge: badge,
                              soundName: soundName,
                              imageUrl : imageUrl,
                              trigger: trigger,
                              notificationID: notificationID)
        
    }
    
    
    
    /// 發送本地定時推播
    ///
    /// - Parameters:
    ///   - title: 推播的標題
    ///   - subtitle: 推播的子標題
    ///   - body: 推播內容
    ///   - badge: 推播後 App Icon 上會顯示的數字
    ///   - soundName: 推波時的音效檔名，若為 nil 或是檔名錯誤會跳出預設聲音
    ///   - delayTime: 推播延遲出現的時間
    ///   - repeats: 是否會重複出現推播
    ///   - notificationID: 推播辨識的id
    func sendCalendarNotification(title : String? ,
                                   subtitle : String? ,
                                   body : String? ,
                                   badge: NSNumber? ,
                                   soundName:String? ,
                                   imageUrl : URL?,
                                   date : DateComponents ,
                                   repeats : Bool ,
                                   notificationID:String ){
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)

        self.sendNotification(title: title,
                              subtitle: subtitle,
                              body: body,
                              badge: badge,
                              soundName: soundName,
                              imageUrl : imageUrl,
                              trigger: trigger,
                              notificationID: notificationID)
        
    }
    
    
    
    /// 發送本地延遲推播
    ///
    /// - Parameters:
    ///   - title: 推播的標題
    ///   - subtitle: 推播的子標題
    ///   - body: 推播內容
    ///   - badge: 推播後 App Icon 上會顯示的數字
    ///   - soundName: 推波時的音效檔名，若為 nil 或是檔名錯誤會跳出預設聲音
    ///   - imageUrl: 相片 url 若為 nil 就不顯示
    ///   - trigger: 推播要使用的 Trigger 類型
    ///   - notificationID: 推播辨識的id
    ///
    /// Trigger 類型：
    /// UNTimeIntervalNotificationTrigger => 每幾秒發送。
    /// UNCalendarNotificationTrigger => 指定日期發送。
    /// UNLocationNotificationTrigger => 當靠近某個位置時觸發。
    /// UNPushNotificationTrigger => 從後台發送。
    /// 注意：重複發送的最短時間為 60 秒
    private func sendNotification(title : String? , subtitle : String?, body : String? , badge: NSNumber? , soundName:String?, imageUrl : URL? , trigger : UNNotificationTrigger? , notificationID:String ){
        // 若未加入 Delegate 就只能在 app 背景執行時收到
        let content = UNMutableNotificationContent()
        if let title = title{
            content.title = title
        }
        if let subtitle = subtitle{
            content.subtitle = subtitle
        }
        if let body = body{
            content.body = body
        }
        // app Icone 上顯示有幾則 notification 沒讀取的數字
        content.badge = badge
        if let soundName = soundName {
            let sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundName))
            content.sound = sound
        }else{
            content.sound = UNNotificationSound.default
        }
        
        // 設置通知上的圖片
        if let imageURL = imageUrl{
            do{
                let attachment = try UNNotificationAttachment(identifier: "showImage", url: imageURL, options: nil)
                content.attachments = [attachment]
            }
            catch {
                print("attachment error : \(error.localizedDescription)")
            }
        }
        
        content.categoryIdentifier = "NotiCategory"
        
        // 識別通知
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        self.add(request) { error in
            if let error = error {
                print("建立通知錯誤：\(error.localizedDescription)")
            }else{
                print("建立通知成功")
            }
            
        }
    }
}
