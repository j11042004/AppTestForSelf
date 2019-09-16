//
//  NotificationService.swift
//  UNNoteServiceExtension
//
//  Created by Uran on 2018/4/10.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UserNotifications
import UIKit
class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            guard let url = URL(string: "https://www.npm.gov.tw/exh96/orientation/ch_b41_1.html") else{
                print("這是假圖啊～～～～")
                return
            }
            let configure = URLSessionConfiguration.default
            let session = URLSession(configuration: configure)
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if let error = error{
                    print("假圖錯誤：\(error.localizedDescription)")
                    return
                }
                guard let data = data else{
                    print("data 錯誤")
                    return
                }
                guard var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else {
                    print("path is nil")
                    return
                }
                path = "\(path)/download/image.jpg"
                let pathUrl = URL(fileURLWithPath: path)
                guard let img = UIImage(data: data) else{
                    print("img is nil")
                    return
                }
                
                do {
                    // 將 image 寫到目表檔案中
                    try UIImageJPEGRepresentation(img, 1)?.write(to: pathUrl, options: Data.WritingOptions.atomicWrite)
                    let attachment = try UNNotificationAttachment(identifier: "serviceExtension", url: pathUrl, options: nil)
                    self.bestAttemptContent?.attachments = [attachment]
                    // 回覆 新的通知內容
                    contentHandler(bestAttemptContent)
                    print("write success")
                }catch {
                    print("寫入或轉換錯誤：\(error.localizedDescription)")
                }
            }
            dataTask.resume()
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
