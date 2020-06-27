//
//  LocalNoteSender.swift
//  HelloLocalNotification
//
//  Created by Uran on 2019/11/25.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import UserNotifications
class LocalNoteSender: NSObject {
    static let shared = LocalNoteSender()
    let unNoteCenter = UNUserNotificationCenter.current()
    let imgUrl = Bundle.main.url(forResource: "sakura", withExtension: "jpg")

    /// 發送 iOS 10 之後推播
    public func sendiOS10Notification(){
        NSLog("發送新版本地推播")
        // 設定特定時間跳出推播，視情況放在 application或是哪
        //        var dateCompinents = DateComponents()
        //        dateCompinents.weekday = 4
        //        dateCompinents.hour = 11
        //        dateCompinents.minute = 20
        //        let calendertrigger = UNCalendarNotificationTrigger(dateMatching: dateCompinents, repeats: false)

        // 延遲特定秒數後發出通知
        self.unNoteCenter.sendDelayTimeNotification(title: "發送 iOS 10 之後推播", subtitle: "subTitle :發送 iOS 10 之後推播", body: "Body : 發送 iOS 10 之後推播", badge: 2, soundName: nil, imageUrl: imgUrl , delayTime: 2, repeats: false, notificationID: "ObjectNotification")
        
    }
    /// 發送 iOS 10 之後排程推播
    public func sendiOS10CalendarNotification(){
        NSLog("發送新版指定日期的本地推播")
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        let nowComponents = calendar.dateComponents([.weekday , .hour , .minute], from: date)
        //weekday 數字 1 是星期天，2 是星期一
        // 設定週期性的星期幾 發出本地推播
        let sendCompoients = DateComponents(calendar: calendar, hour: nowComponents.hour!, minute: nowComponents.minute!+1, weekday: nowComponents.weekday!)
        self.unNoteCenter.sendCalendarNotification(title: "發送排程推播", subtitle: "subtitle 排程推播", body: "推播時間：周\(sendCompoients.weekday!-1),\(sendCompoients.hour!)點\(sendCompoients.minute!)分", badge: 99, soundName: nil, imageUrl: imgUrl, date: sendCompoients, repeats: false, notificationID: "extensionCalendar")
    }
    /// 發送 iOS 9  之前排程推播
    public func sendiOS9Notification(){
        NSLog("發送舊版本地推播")
        //  舊版本本地推播
        let nowDate = Date()
        let calender = Calendar.current
        let componentsTag : Set<Calendar.Component> = [.year ,.month , .day ,.hour ,.minute , .second , .timeZone]
        var components = calender.dateComponents(componentsTag, from: nowDate)
        if let sec = components.second{
            components.second = sec+2
        }
        let convertDate = calender.date(from: components)
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = convertDate
        localNotification.timeZone = NSTimeZone.default
        localNotification.alertTitle = "iOS 9 之前本地推播 title"
        localNotification.alertBody = "iOS 9 之前本地推播 Body"
        
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
}
