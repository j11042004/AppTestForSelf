//
//  AlertController+Image.swift
//  HelloSqlite
//
//  Created by Uran on 2018/2/27.
//  Copyright © 2018年 Uran. All rights reserved.
//

import Foundation
import UIKit
extension UIAlertController {
    //  Alert擴充方法，可以放一張照片到Alert 上
    func addImage(image:UIImage){
        // 設定 Alert 上相片的Size
        let maxSize = CGSize(width: 245, height: 245)
        let imgSize = image.size
        var radio : CGFloat!
        // 取得縮小倍率
        if imgSize.width > imgSize.height{
            radio = maxSize.width / imgSize.width
        }else{
            radio = maxSize.height / imgSize.height
        }
        
        let scaleSize = CGSize.init(width: imgSize.width*radio, height: imgSize.height*radio)
        let resizeImg = image.imageWithSize(scaleSize)
        
        
        let imageAction = UIAlertAction(title: "", style: .default, handler: nil)
        // 不讓alert action 被按或是其他的
        imageAction.isEnabled = false
        // 這裡的 key 不能被更動
        imageAction.setValue(resizeImg.withRenderingMode(.alwaysOriginal), forKey: "image")
        
        self.addAction(imageAction)
    }
    
}
