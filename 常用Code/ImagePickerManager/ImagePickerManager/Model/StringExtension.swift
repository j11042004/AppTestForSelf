//
//  StringExtension.swift
//  ImagePickerManager
//
//  Created by Uran on 2018/7/5.
//  Copyright © 2018年 Uran. All rights reserved.
//

import Foundation
extension String {
    static func nowQueue()->String?{
        let name = __dispatch_queue_get_label(nil)
        return String(cString: name, encoding: .utf8)
    }
}
