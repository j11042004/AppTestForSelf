//
//  Message.swift
//  HelloMessagekitFamework
//
//  Created by Uran on 2018/6/22.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import MessageKit
class Message: MessageType {
    var sender: Sender
    
    var messageId: String = ""
    
    var sentDate: Date
    
    var data: MessageData
    
    required init(sender : Sender ,
                  date : Date ,
                  messageID : String ,
                  data : MessageData) {
        self.sender = sender
        self.sentDate = date
        self.messageId = messageID
        self.data = data
    }
    
}
