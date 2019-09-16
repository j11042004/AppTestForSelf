//
//  UIView+NibInit.swift
//  SwiftXibExtension
//
//  Created by Uran on 2018/6/4.
//  Copyright © 2018年 Uran. All rights reserved.
//

import Foundation
import UIKit

protocol NibInstance { }
extension UIView : NibInstance{ }

// 擴充 NibInstance ，並對他做 Where 約束，約束當他為 UIView 時，才有以下的方法
extension NibInstance where Self : UIView{
    // 這個方法只能無法用在 init?(code : aDecoder) 中
    
    /// 用 Nib 建立並回傳 UIView
    ///
    /// - Returns: NibView
    static func instantiateFromNib() -> Self {
        if let view = Bundle(for: self).loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as? Self {
            return view
        } else {
            assert(false, "The nib named \(self) is not found")
            return Self()
        }
    }
}
