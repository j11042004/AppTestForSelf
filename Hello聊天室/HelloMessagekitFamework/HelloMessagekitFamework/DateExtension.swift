//
//  DateExtension.swift
//  MQTTChat
//
//  Created by Uran on 2018/6/14.
//  Copyright © 2018年 Uran. All rights reserved.
//

import Foundation

extension Date{
    /// 將 Date 轉成 String
    var string : String {
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss xxxx"
            dateFormatter.dateFormat = "MM/dd,E,h:mm a"
            dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
            let dateString = dateFormatter.string(from: self)
            return dateString
        }
        set{
            
        }
    }
    // 將 String 轉成 Date
    static func date(With dateStr : String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss xxxx"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        let stringDate = dateFormatter.date(from: dateStr)
        return stringDate
    }
}
