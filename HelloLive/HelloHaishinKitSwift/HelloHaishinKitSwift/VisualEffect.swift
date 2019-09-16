//
//  VisualEffect.swift
//  HelloHaishinKitSwift
//
//  Created by Uran on 2018/6/26.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import HaishinKit
import AVFoundation

class CurrentTimeEffect: VisualEffect {
    let filter : CIFilter? = CIFilter(name: "CISourceOverCompositing")
    let label : UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        return label
    }()
    
    override func execute(_ image: CIImage) -> CIImage {
        let now : Date = Date()
        label.text = now.description
        
        UIGraphicsBeginImageContext(image.extent.size)
        label.drawText(in: CGRect(x: 0, y: 0, width: 200, height: 200))
        let result = CIImage(image: UIGraphicsGetImageFromCurrentImageContext()!)
        UIGraphicsEndImageContext()
        
        filter!.setValue(result, forKey: "inputImage")
        filter!.setValue(image, forKey: "inputBackgroundImage")
        return filter!.outputImage!
    }
}


/// 在畫面上顯示 自訂義圖片
class PronameEffect : VisualEffect {
    let filter : CIFilter? = CIFilter(name: "CISourceOverCompositing")
    
    var proName : CIImage?
    
    var extent : CGRect = CGRect.zero{
        didSet{
            if extent == oldValue {
                return
            }
            UIGraphicsBeginImageContext(extent.size)
            
            guard let iconImg = UIImage(named: "") else{
                NSLog("iconImg is nil")
                return
            }
            iconImg.draw(at: CGPoint(x: 50, y: 50))
            proName = CIImage(image: UIGraphicsGetImageFromCurrentImageContext()!)
            UIGraphicsEndImageContext()
        }
    }
    override init() {
        super.init()
    }
    
    override func execute(_ image: CIImage) -> CIImage {
        // 若是 proName 也是 nil，也要注意
        guard let filter = filter ,
            proName != nil
        else {
            return image
        }
        extent = image.extent
        filter.setValue(proName!, forKey: "inputImage")
        filter.setValue(image, forKey: "inputBackgroundImage")
        return filter.outputImage!
    }
}


/// 使用灰階濾鏡
final class MonochromeEffect: VisualEffect {
    let filter: CIFilter? = CIFilter(name: "CIColorMonochrome")
    
    override func execute(_ image: CIImage) -> CIImage {
        guard let filter: CIFilter = filter else {
            return image
        }
        filter.setValue(image, forKey: "inputImage")
        // 設定要進行覆蓋的顏色
        filter.setValue(CIColor(red: 0.75, green: 0.75, blue: 0.75), forKey: "inputColor")
        filter.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter.outputImage else {
            NSLog("MonochromeEffect outputImage is nil")
            return image
        }
        return outputImage
    }
}
