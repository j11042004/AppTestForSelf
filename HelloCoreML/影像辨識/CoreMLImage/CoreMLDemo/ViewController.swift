//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by Sai Kambampati on 14/6/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreML
class ViewController: UIViewController{
    var model : Inceptionv3!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var propertyNum: UILabel!
    @IBOutlet weak var classifier: UILabel!
    var imagePicker : ImagePickerManager = ImagePickerManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 這個 inceptionv3 模型只能放入 299 x 299 的圖片
        model = Inceptionv3()
        imagePicker.imagePickerDelegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func camera(_ sender: Any) {
        self.imagePicker.requestImage(With: ImagePickerManager.imageType.photo)
    }
    
    
    @IBAction func openLibrary(_ sender: Any) {
        self.imagePicker.requestImage(With: ImagePickerManager.imageType.picture)
    }

}

extension ViewController : ImagePickerManagerDelegate{
    func imagePickerGetImage(success: Bool, image: UIImage?, imgName: String?) {
        self.classifier.text = "分析圖片中"
        guard let image = image else {
            NSLog("choose image is nil")
            return
        }
        let resize = CGSize(width: 299, height: 299)
        // 將圖片更新成 model 所允許的最大 Size 的圖片
        UIGraphicsBeginImageContextWithOptions(resize, true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else{
            NSLog("resize Image is nil")
            return
        }
        UIGraphicsEndImageContext()
        
        self.coreMLCheckItem(With: newImage)
    }
}

extension ViewController {
    
    /// 將 image 轉成 ， CVPixelBuffers
    /// CVPixelBuffers 是一個將像數（Pixcel）存在主記憶體裡的圖像緩衝器
    func changeImageToPixelBuffer(With image : UIImage) -> CVPixelBuffer?{
        let attrs = [kCVPixelBufferCGImageCompatibilityKey : kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey : kCFBooleanTrue] as CFDictionary
        
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            NSLog("pixelBuffer status not ok")
            return nil
        }
        return pixelBuffer
    }
    
    
    /// CoreML進行影像辨識
    ///
    /// - Parameter image: 要分析的影像
    func coreMLCheckItem(With image : UIImage){
        let attrs = [kCVPixelBufferCGImageCompatibilityKey : kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey : kCFBooleanTrue] as CFDictionary
        
        var buffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &buffer)
        guard status == kCVReturnSuccess else {
            NSLog("pixelBuffer status not ok")
            return
        }
        guard let pixelBuffer = buffer else {
            NSLog("pixelBuffer is nil")
            return
        }
        // 將 buffer 轉成 pixelData
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        // 取得像數並轉成裝置的 RGB 色彩
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        // CoreImage context 的設定
        guard let context = CGContext(data: pixelData,
                                      width: Int(image.size.width),
                                      height: Int(image.size.height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                      space: rgbColorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
            else{
                NSLog("context is nil")
                return
        }
        // CoreImage context 翻轉
        context.translateBy(x: 0, y: image.size.height)
        // CoreImage Context 縮放
        context.scaleBy(x: 1.0, y: -1.0)
        
        
        UIGraphicsPushContext(context)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        self.imageView.image = image
        // 進行影像辨識
        guard let prediction = try? model.prediction(image: pixelBuffer) else {
            NSLog("model prediction is nil")
            return
        }
        self.classifier.text = "我猜測這是 \(prediction.classLabel)"
        guard let range = prediction.classLabelProbs[prediction.classLabel] else{
            self.propertyNum.text = "這很神秘，是未知機率"
            return
        }
        let num = range * 100
        let proNum = String(format: "%.4f", num)
        self.propertyNum.text = "可能機率高達 \(proNum)%"
        
    }
}
