//
//  GreenBlueChannelOverlayBlendFilter.swift
//  MetalFilter
//
//  Created by Uran on 2019/7/4.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import CoreImage
/// 藍綠 圖層混合覆蓋
class GreenBlueChannelOverlayBlendFilter: CIFilter {
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
        kernel = try? CIColorKernel(functionName: "greenBlueChannelOverlayBlend", fromMetalLibraryData: data)
    }
}
