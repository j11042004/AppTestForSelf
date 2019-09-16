//
//  HelloSwift.swift
//  HelloSideMenu
//
//  Created by Uran on 2018/6/5.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

@objc public class HelloSwift: NSObject {
    static let shardInstance : HelloSwift = HelloSwift()
    public func sayHello() -> String?{
        NSLog("Hello Swift")
        
        return "Hello Swift"
    }
}
