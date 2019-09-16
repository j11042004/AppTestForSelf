//
//  SwiftHello.swift
//  SwiftFramework
//
//  Created by Uran on 2018/3/7.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

open class SwiftHello: NSObject {
    public static let shared = SwiftHello()
    public func sayHello()->String{
        return "Swift Hello"
    }
}
