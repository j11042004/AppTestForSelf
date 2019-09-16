//
//  StringEctension.swift
//  HelloHaishinKitSwift
//
//  Created by Uran on 2018/6/26.
//  Copyright © 2018年 Uran. All rights reserved.
//

import Foundation
import UIKit
extension Double{
    
    func string(_ digitAfterPointValue : Int) -> String{
        let value = String(format: "%.\(digitAfterPointValue)f", self)
        return value
    }
}
extension Float{
    
    func string(_ digitAfterPointValue : Int) -> String{
        let value = String(format: "%.\(digitAfterPointValue)f", self)
        return value
    }
}
extension CGFloat{
    
    func string(_ digitAfterPointValue : Int) -> String{
        let value = String(format: "%.\(digitAfterPointValue)f", self)
        return value
    }
}
