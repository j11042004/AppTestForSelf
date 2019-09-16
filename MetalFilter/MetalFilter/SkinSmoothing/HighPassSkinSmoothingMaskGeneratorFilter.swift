//
//  HighPassSkinSmoothingMaskGeneratorFilter.swift
//  MetalFilter
//
//  Created by Uran on 2019/7/4.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import CoreImage
/// 影像 皮膚平滑 曝光調整
class HighPassSkinSmoothingMaskGeneratorFilter: CIFilter {
    public var inputImage : CIImage?
    public var inputRadius : CGFloat = 0
    
    override var outputImage: CIImage? {
        let filter = CIFilter(name: "CIExposureAdjust")
        filter?.setValue(self.inputImage, forKey: kCIInputImageKey)
        filter?.setValue(-1.0, forKey: kCIInputEVKey)
        let channelOverlayFilter = GreenBlueChannelOverlayBlendFilter()
        channelOverlayFilter.inputImage = filter?.outputImage
        //
        let highPassFilter = HighPassFilter()
        highPassFilter.inputImage = channelOverlayFilter.outputImage
        highPassFilter.inputRadius = self.inputRadius
        // 進行圖片 Skin Smoothing
        let highSkinSmoothingFilter = HighPassSkinSmoothingMaskGeneratorFilter()
        highSkinSmoothingFilter.inputImage = highPassFilter.outputImage
        return highSkinSmoothingFilter.outputImage
    }
    
}
