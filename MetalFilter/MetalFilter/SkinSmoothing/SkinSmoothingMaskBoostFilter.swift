//
//  SkinSmoothingMaskBoostFilter.swift
//  MetalFilter
//
//  Created by Uran on 2019/7/4.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import CoreImage
// 對影像加入 平滑化的 遮罩
class SkinSmoothingMaskBoostFilter: CIFilter {
    public var inputImage : CIImage?
    override var outputImage: CIImage? {
        guard let img = self.inputImage else {
            return nil
        }
        let resultImg = self.kernel?.apply(extent: img.extent, arguments: [img])
        return resultImg
    }
    private var kernel : CIColorKernel?
    //MARK:- Init
    override init() {
        super.init()
        customInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    private func customInit(){
        guard let url : URL = Bundle.main.url(forResource: "default", withExtension: "metallib") ,
            let data = try? Data(contentsOf: url)
            else {
                return
        }
        kernel = try? CIColorKernel(functionName: "skinSmoothingMaskBoost", fromMetalLibraryData: data)
    }
}
