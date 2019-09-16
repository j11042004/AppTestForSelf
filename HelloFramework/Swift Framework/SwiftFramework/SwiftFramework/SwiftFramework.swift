//
//  SwiftFramework.swift
//  SwiftFramework
//
//  Created by Uran on 2018/3/7.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
// Class 前要 加入 open 或是 Public，否則無法被使用 Framework 的使用者使用
// 同理，要被外部使用的變數或方法，也要加入open 或是 Public
open class SwiftFramework: NSObject {
    public static let shared = SwiftFramework()
    public func hello(){
        let alert = UIAlertController(title: "Hello", message: "Hello Swift Framework", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
