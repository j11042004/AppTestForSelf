//
//  HighPassFilter.swift
//  MetalFilter
//
//  Created by Uran on 2019/7/4.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import CoreImage
/// 高反差保留
class HighPassFilter: CIFilter {
    public var inputImage : CIImage?
    public var inputRadius : CGFloat = 1.0
    override var outputImage: CIImage? {
        guard let img = self.inputImage else {
            return nil
        }
        // 對圖片做模糊化
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(img, forKey: kCIInputImageKey)
        blurFilter?.setValue(inputRadius, forKey: kCIInputRadiusKey)
        guard let blurImg = blurFilter?.outputImage else {
            return nil
        }
        let resultImg = self.kernel?.apply(extent: img.extent, arguments: [img , blurImg])
        return resultImg
    }
    private var kernel : CIColorKernel?
    //MARK:- Init
    override init() {
        super.init()
        self.customInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customInit()
    }
    private func customInit(){
        guard let url : URL = Bundle.main.url(forResource: "default", withExtension: "metallib") ,
            let data = try? Data(contentsOf: url)
            else {
                return
        }
        kernel = try? CIColorKernel(functionName: "highPass", fromMetalLibraryData: data)
    }
}
