//
//  UIImage+Resize.swift
//  HelloBarItemWithBadgeNum
//
//  Created by Uran on 2018/11/30.
//  Copyright © 2018 Uran. All rights reserved.
//

import Foundation
import CoreImage
import UIKit
extension UIImage{
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        // 取的 兩邊的寬高比
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        // 取的最小的寬高比
        let ratio = widthRatio > heightRatio ? heightRatio : widthRatio
        // 取得新的 Size
        newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        // 製作圖層 Frame
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // 建立繪圖圖層
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        // 將 image 畫上繪圖圖層
        self.draw(in: rect)
        // 取得新的 image
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 重要：一定要關閉圖層
        UIGraphicsEndImageContext()
        
        return newImage
    }

}
