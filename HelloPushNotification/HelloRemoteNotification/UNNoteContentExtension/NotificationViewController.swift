//
//  NotificationViewController.swift
//  UNNoteContentExtension
//
//  Created by Uran on 2018/4/10.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
/*
 範例用 apns
     {
     "aps" : {
            "alert" : {
                "title" : "Hello world",
                "body" : "Your message here."
            },
            "sound" : "default",
            "badge" : 9,
//     指定Content Extension，否則只會跑出 default 的樣式
            "category":"myNotificationCategory"
        }
     }
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    func didReceive(_ notification: UNNotification) {
        let body = notification.request.content.body
        let title = notification.request.content.title
        
        self.bodyLabel.text = notification.request.content.body
        self.bodyLabel.sizeToFit()
        self.bodyLabel.numberOfLines = 0
        self.label?.text = notification.request.content.title
        self.label?.sizeToFit()
        self.label?.numberOfLines = 0
        
        let img = UIImage(named: "sakura.jpg")
        self.imgView.contentMode = UIViewContentMode.scaleAspectFit
        self.imgView.image = img
    }
    
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        completion(UNNotificationContentExtensionResponseOption.dismissAndForwardAction)
        
    }
}
