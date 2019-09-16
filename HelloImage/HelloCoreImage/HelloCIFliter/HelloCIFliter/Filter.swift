//
//  CustomerFilter.swift
//  HelloCIFliter
//
//  Created by Uran on 2018/6/27.
//  Copyright © 2018年 Uran. All rights reserved.
//

import Foundation
import CoreImage
import UIKit
enum FilterType : String  {
    case none = ""
    case SepiaTone = "CISepiaTone"
    case ExposureAdjust = "CIExposureAdjust"
    case ColorMonochrome = "CIColorMonochrome"
    case HighlightShadowAdjust = "CIHighlightShadowAdjust"
}

class Filter : NSObject{
    public static let sharedInstance = Filter()
    
    
    
    // 濾鏡的名字
    /// 所有的濾鏡
    public private(set) var filters : [FilterType] = [ .none , .SepiaTone , .ExposureAdjust , .ColorMonochrome , .HighlightShadowAdjust]
    /// 將影像做多次濾鏡
    func filterImage(With filters : FilterType ... , image : UIImage , rate : Float) -> UIImage?{
        
        var finalImg = image
        for filter in filters {
            
            // 若做濾鏡後的 cgImage 為 nil，continue
            switch filter{
            case .SepiaTone : // 褐色濾鏡
                guard let resultCGImg = self.sepiaTone(image: finalImg, changeRate: rate) else{
                    print("filterSepiaTone is nil")
                    continue
                }
                finalImg = UIImage(cgImage: resultCGImg)
                break
            case .ColorMonochrome: // 單色濾鏡
                guard let resultCGImg = self.colorMonochrome(image: finalImg, changeRate: rate) else{
                    print("filterColorMonochrome is nil")
                    continue
                }
                finalImg = UIImage(cgImage: resultCGImg)
                break
            case .ExposureAdjust : // 曝光濾鏡
                guard let resultCGImg = self.exposureAdjust(image: finalImg, changeRate: rate) else{
                    print("filterExposureAdjust is nil")
                    continue
                }
                finalImg = UIImage(cgImage: resultCGImg)
                break
            case .HighlightShadowAdjust: // 陰影平衡
                guard let resultCGImg = self.highlightShadowAdjust(image: finalImg, changeRate: rate) else{
                    continue
                }
                finalImg = UIImage(cgImage: resultCGImg)
                break
            case .none:
                break
            }
            
        }
        
        return finalImg
    }
    // MARK: 各個濾鏡
    /// 將不同影像合併
    func sourceOverCompositionimage (fountImg: UIImage , backImg : UIImage ) -> CGImage?{
        
        var mainImg = fountImg
        var backImg = backImg
        // 這邊比例要用 Main image 的比例
        let mainRate = mainImg.size.width / mainImg.size.height
        // 將兩個照片繪製成同樣 Size
        guard let newImgs = resizeImages(With: mainImg , backImg, rate: mainRate) else{
            print("nil resize newImgs")
            return nil
        }
        mainImg = newImgs[0]!
        backImg = newImgs[1]!
        // 取得要顯示的 image 與 要放在後面的 image
        let mainCIImg = CIImage(cgImage: mainImg.cgImage!)
        let backCIImg = CIImage(cgImage: backImg.cgImage!)
        // 使用 合併濾鏡
        let filter : CIFilter = CIFilter(name: "CISourceOverCompositing")!
        filter.setValue(mainCIImg, forKey: kCIInputImageKey)
        filter.setValue(backCIImg, forKey: kCIInputBackgroundImageKey)
        // 將濾鏡後的圖片取出
        let finalCIImage = filter.value(forKey: kCIOutputImageKey) as! CIImage
        
//        let context : CIContext = CIContext(options: nil)
//        let extent = finalCIImage.extent
//        print("filted size : \(extent)")
//        let finalCGImg = context.createCGImage(finalCIImage, from: extent)
        let finalCGImg = self.gpuCreateCGImage(With: finalCIImage)
        return finalCGImg
    }
    /// 將圖片棕褐化
    private func sepiaTone( image : UIImage , changeRate : Float) -> CGImage?{
        // UIImage 在產生時不會自動產生 CIImage，所以要先轉成 cgimage 在產生
        guard let cgImg = image.cgImage else{
            return nil
        }
        let coreImg = CIImage(cgImage: cgImg)
        // 建立要使用的濾鏡，要用的濾鏡用 name 設定
        guard let filter = CIFilter(name: FilterType.SepiaTone.rawValue) else{
            return nil
        }
        // 指定要使用濾鏡的圖片
        filter.setValue(coreImg, forKey: kCIInputImageKey)
        // 設定 指定濾鏡要使用的圖片
        let rating : Double = Double(Int(changeRate))/100
        // 先判斷是否有 要使用濾鏡的強度
        if filter.inputKeys.contains(kCIInputIntensityKey) {
            filter.setValue(rating, forKey: kCIInputIntensityKey)
        }
        // 取的濾鏡產生的圖案拉出
        let outputCIImg = filter.value(forKey: kCIOutputImageKey) as? CIImage
        let resultCGImg = self.gpuCreateCGImage(With: outputCIImg)
        return resultCGImg
    }
    /// 設定圖片的曝光度
    private func exposureAdjust( image : UIImage , changeRate : Float) -> CGImage?{
        // UIImage 在產生時不會自動產生 CIImage，所以要先轉成 cgimage 在產生
        guard let cgImg = image.cgImage else{
            return nil
        }
        let coreImg = CIImage(cgImage: cgImg)
        // 建立要使用的濾鏡，要用的濾鏡用 name 設定
        guard let filter = CIFilter(name:FilterType.ExposureAdjust.rawValue) else{
            return nil
        }
        // 指定要使用濾鏡的圖片
        filter.setValue(coreImg, forKey: kCIInputImageKey)
        // 設定 指定濾鏡要使用的圖片
        let rating : Double = Double(Int(changeRate))/100
        // 先判斷是否有 曝光率
        if filter.inputKeys.contains(kCIInputEVKey){
            filter.setValue(rating, forKey: kCIInputEVKey)
        }
        // 取的濾鏡產生的圖案拉出
        let outputCIImg = filter.value(forKey: kCIOutputImageKey) as? CIImage
        let resultCGImg = self.gpuCreateCGImage(With: outputCIImg)
        return resultCGImg
    }
    /// 相片單色化
    private func colorMonochrome(image : UIImage , changeRate : Float) -> CGImage?{
        // UIImage 在產生時不會自動產生 CIImage，所以要先轉成 cgimage 在產生
        guard let cgImg = image.cgImage else{
            return nil
        }
        let coreImg = CIImage(cgImage: cgImg)
        // 建立要使用的濾鏡，要用的濾鏡用 name 設定
        guard let filter = CIFilter(name: FilterType.ColorMonochrome.rawValue) else{
            return nil
        }
        // 指定要使用濾鏡的圖片
        filter.setValue(coreImg, forKey: kCIInputImageKey)
        // 設定 指定濾鏡要使用的圖片
        let rating : Double = Double(Int(changeRate))/100
        // 先判斷是否有 設定濾鏡的顏色
        if filter.inputKeys.contains(kCIInputColorKey){
            filter.setValue(CIColor(red: 0.75, green: 0.75, blue: 0.75), forKey: kCIInputColorKey)
        }
        // 先判斷是否有 要使用濾鏡的強度
        if filter.inputKeys.contains(kCIInputIntensityKey) {
            filter.setValue(rating, forKey: kCIInputIntensityKey)
        }
        // 取的濾鏡產生的圖案拉出
        let outputCIImg = filter.value(forKey: kCIOutputImageKey) as? CIImage
        let resultCGImg = self.gpuCreateCGImage(With: outputCIImg)
        return resultCGImg
    }
    // 曝光的陰影平衡
    private func highlightShadowAdjust(image : UIImage , changeRate : Float) -> CGImage?{
        // UIImage 在產生時不會自動產生 CIImage，所以要先轉成 cgimage 在產生
        guard let cgImg = image.cgImage else{
            return nil
        }
        let coreImg = CIImage(cgImage: cgImg)
        // 建立要使用的濾鏡，要用的濾鏡用 name 設定
        guard let filter = CIFilter(name:FilterType.HighlightShadowAdjust.rawValue) else{
            return nil
        }
        // 指定要使用濾鏡的圖片
        filter.setValue(coreImg, forKey: kCIInputImageKey)
        // 設定 指定濾鏡要使用的圖片
        let rating : Double = Double(Int(changeRate))/100
        // Filter 效果設定
        if filter.inputKeys.contains(kCIInputRadiusKey){
            filter.setValue(rating, forKey: kCIInputRadiusKey)
        }
        if filter.inputKeys.contains("inputShadowAmount"){
            filter.setValue(rating, forKey: "inputShadowAmount")
        }
        // 先判斷是否有 輸入的有效範圍
        if filter.inputKeys.contains("inputHighlightAmount"){
            filter.setValue(rating, forKey: "inputHighlightAmount")
        }
        
        
        // 取的濾鏡產生的圖案拉出
        let outputCIImg = filter.value(forKey: kCIOutputImageKey) as? CIImage
        let resultCGImg = self.gpuCreateCGImage(With: outputCIImg)
        return resultCGImg
    }
    // MARK: 圖片相關
    /// 用 Gpu 處理 CIImage ， 並轉成 CGImage
    private func gpuCreateCGImage(With ciImg : CIImage?) -> CGImage?{
        guard let img = ciImg else {
            return nil
        }
        // 使用 GPU 處理 CIImage
        guard let context : EAGLContext = EAGLContext(api: EAGLRenderingAPI.openGLES3) else{
            return nil
        }
        let ciContext = CIContext(eaglContext: context)
        // 使用 GPU 產生 CGImage
        guard let cgimageResult : CGImage = ciContext.createCGImage(img, from: img.extent) else{
            return nil
        }
        return cgimageResult
    }
    
    
    /// 根據輸入的圖片，取得新的範圍比例
    func imagesNewRate(With images : UIImage ...) -> CGFloat{
        var rates : [CGFloat] = [CGFloat]()
        // 取的所有圖片的比例
        for img in images {
            let rate = img.size.width / img.size.height
            rates.append(rate)
        }
        let rateIndexs = 0 ..< rates.count
        var newRate : CGFloat = rates[0]
        // 比對所有的 index 是否相同
        for index in rateIndexs {
            let selectRate = rates[index]
            let lastIndexs = index+1 ..< rates.count
            for lastIndex in lastIndexs{
                let lastRate = rates[lastIndex]
                // 比對選到的 rate 與接下來所有的 rate 若相同 就跳過繼續比對
                if lastRate == selectRate {
                    continue
                }else{ // 若不同就相乘，取得新的比例
                    newRate *= lastRate
                }
            }
        }
        return newRate
    }
    
    /// 重新繪製圖片到新的 Size 上
    func resizeImages(With images : UIImage ... , rate : CGFloat) -> [UIImage?]?{
        if images.count <= 0 || rate == 0 {
            return nil
        }
        let screenSize = UIScreen.main.bounds.size
        var newWidth : CGFloat = 0
        if screenSize.width < screenSize.height {
            newWidth = screenSize.width
        }else{
            newWidth = screenSize.height
        }
        let newHeight = newWidth / rate
        let newSize = CGSize(width: newWidth, height: newHeight)
        var newImgs = [UIImage?]()
        for img in images {
            let newImg = img.resize(With: newSize)
            newImgs.append(newImg)
        }
        return newImgs
    }
}


extension UIImage {
    /// 重新更新圖片Size
    func resize(With size : CGSize) -> UIImage?  {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        self.draw(in: rect)
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
}


