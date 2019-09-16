//
//  UIColor+Extension.swift
//  ControllerPresentAnimation
//
//  Created by Uran on 2018/12/7.
//  Copyright © 2018 Uran. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    // 取得 RGBA
    func rgba() -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)? {
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        var alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            
            return (red:red, green:green, blue:blue, alpha:alpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}
