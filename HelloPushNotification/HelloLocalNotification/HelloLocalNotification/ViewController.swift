//
//  ViewController.swift
//  HelloLocalNotification
//
//  Created by Uran on 2018/4/10.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import UserNotifications
class ViewController: UIViewController {
    let unNoteCenter = UNUserNotificationCenter.current()
    
    
    @IBOutlet weak var sendNoteBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendNoteBtn.layer.cornerRadius = 10
        self.sendNoteBtn.backgroundColor = UIColor.darkGray
        print(UNUserNotificationCenter.current())
    }

    @IBAction func sendNotification(_ sender: UIButton) {
        
        // 設定特定時間跳出推播，視情況放在 application或是哪
//        var dateCompinents = DateComponents()
//        dateCompinents.weekday = 4
//        dateCompinents.hour = 11
//        dateCompinents.minute = 20
//        let calendertrigger = UNCalendarNotificationTrigger(dateMatching: dateCompinents, repeats: false)
        let imgUrl = Bundle.main.url(forResource: "sakura", withExtension: "jpg")
        // 延遲特定秒數後發出通知
        self.unNoteCenter.sendDelayTimeNotification(title: "title : Object", subtitle: "subTitle : Object", body: "Body : Object", badge: 2, soundName: nil, imageUrl: imgUrl , delayTime: 5, repeats: false, notificationID: "ObjectNotification")
        // 設定週期性的星期幾 發出本地推播
        var dateComponents = DateComponents()
        dateComponents.weekday = 4
        dateComponents.hour = 14
        dateComponents.minute = 26
        self.unNoteCenter.sendCalendarNotification(title: "title : calender Object", subtitle: "subtitle : calender Object", body: "body : calender Object", badge: 99, soundName: nil, imageUrl: imgUrl, date: dateComponents, repeats: false, notificationID: "extensionCalendar")
        
        
        //  舊版本本地推播
        let nowDate = Date()
        let calender = Calendar.current
        let componentsTag : Set<Calendar.Component> = [.year ,.month , .day ,.hour ,.minute , .second , .timeZone]
        var components = calender.dateComponents(componentsTag, from: nowDate)
        NSLog("before Components : \(components)")
        if let sec = components.second{
            components.second = sec+5
        }
        NSLog("After Components\(components)")
        let convertDate = calender.date(from: components)
        
        
        NSLog("convertDate : \(convertDate)")
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = convertDate
        localNotification.timeZone = NSTimeZone.default
        localNotification.alertBody = "UILocalNotification Body"
        
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(localNotification)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

