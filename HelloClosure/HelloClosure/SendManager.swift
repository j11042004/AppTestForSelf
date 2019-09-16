//
//  SendManager.swift
//  HelloClosure
//
//  Created by Uran on 2018/2/7.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class SendManager: NSObject {
    private static var instance : SendManager? = nil
    static func sharedInstance()->SendManager{
        if instance == nil{
            instance =  SendManager()
        }
        return instance!
    }
    typealias Completion = (_ str:String? , _ color:UIColor?)->Void
    private var str : String?
    private var color : UIColor?
    func sendValue(complete:Completion){
        complete(str,color)
        
    }
    func getCompletion(str:String , color:UIColor){
        NSLog("get Str : \(str) color : \(color)")
        self.str = str
        self.color = color
    }
    
    
}
