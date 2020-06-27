//
//  String+ConvertFullwidthHalfwidth.swift
//  HelloSwiftPackageManager
//
//  Created by Uran on 2020/3/26.
//  Copyright © 2020 Uran. All rights reserved.
//

import Foundation

extension String{
    /// 將 全形轉半形
    func convertToHalfwidth() -> String{
        let resultStr = NSMutableString(string: self)
        CFStringTransform(resultStr, nil, kCFStringTransformFullwidthHalfwidth, false)
        return resultStr as String
    }
    /// 將 半形轉全形
    func convertToFullwidth() -> String{
        let resultStr = NSMutableString(string: self)
        CFStringTransform(resultStr, nil, kCFStringTransformFullwidthHalfwidth, true)
        return resultStr as String
    }

}
