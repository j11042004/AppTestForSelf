//
//  DelegateManager.swift
//  HelloDelegate
//
//  Created by Uran on 2018/2/7.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
protocol ManagerDelegate {
    func sendValue(str:String,color:UIColor)
}
class DelegateManager: NSObject {
    var delegate : ManagerDelegate?
    
    private static var instance : DelegateManager? = nil
    static func sharedInstance()->DelegateManager{
        if instance == nil {
            instance = DelegateManager()
        }
        return instance!
    }
    func callSend(){
        delegate?.sendValue(str: "Hello", color: UIColor.green)
//        NotificationCenter.default.post(name: NSNotification.Name("CallSend"), object: "Hello")
    }
}
