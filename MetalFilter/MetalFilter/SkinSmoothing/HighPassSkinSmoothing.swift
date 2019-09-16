//
//  HighPassSkinSmoothing.swift
//  MetalFilter
//
//  Created by Uran on 2019/7/4.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import CoreImage
class HighPassSkinSmoothing: CIFilter {
    fileprivate let defaultInputRGBCompositeControlPoints : [CIVector] =
        [CIVector(x: 0, y: 0) ,
         CIVector(x: 120/255.0, y: 146/255.0) ,
         CIVector(x: 1, y: 1) ]
    
    public var inputImage : CIImage?
    public var inputAmount : CGFloat = 0.75
    public var inputRadius : CGFloat = 8.0
    public var inputSharpnessFactor : CGFloat = 0.6
    
    
    
    override var outputImage: CIImage? {
        guard let img = inputImage else {
            return nil
        }
        let skinMaskGeneratorFilter = HighPassSkinSmoothingMaskGeneratorFilter()
        skinMaskGeneratorFilter.inputImage = img
        skinMaskGeneratorFilter.inputRadius = self.inputRadius
        //MARK:- BugFix : ToneCurve Filter
        
        
        
        
        let blendWithMaskFilter = CIFilter(name: "CIBlendWithMask")
        blendWithMaskFilter?.setValue(img, forKey: kCIInputImageKey)
        // 放入 toneCurver 的 outputimage
//        blendWithMaskFilter?.setValue(<#T##value: Any?##Any?#>, forKey: kCIInputBackgroundImageKey)
        blendWithMaskFilter?.setValue(skinMaskGeneratorFilter.outputImage, forKey: kCIInputMaskImageKey)
        
        // 進行 線條明顯化處理
        if self.inputSharpnessFactor != 0 &&
            self.inputAmount != 0 &&
            self.inputSharpnessFactor * self.inputAmount > 0
        {
            let sharpnessValue = self.inputSharpnessFactor * self.inputAmount
            let shapenFilter = CIFilter(name: "CISharpenLuminance")
            shapenFilter?.setValue(sharpnessValue, forKey: "inputSharpness")
            shapenFilter?.setValue(blendWithMaskFilter?.outputImage, forKey: kCIInputImageKey)
            return shapenFilter?.outputImage
        }else
        {
            return blendWithMaskFilter?.outputImage
        }
    }
    
    public var inputToneCurveControlPoints : [CIVector] = [CIVector](){
        didSet{
            if inputToneCurveControlPoints.count == 0{
                inputToneCurveControlPoints = self.defaultInputRGBCompositeControlPoints
            }
        }
    }
    
    
}
