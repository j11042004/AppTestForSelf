//
//  SetColorFilter.swift
//  MetalFilter
//
//  Created by Uran on 2019/7/3.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import CoreImage
class SetColorFilter: CIFilter {
    fileprivate var kernel : CIColorKernel?
    public var inputImg : CIImage?
    override var outputImage: CIImage? {
        guard let img = self.inputImg else {
            return nil
        }
        let resultImg = self.kernel?.apply(extent: img.extent, arguments: [img])
        return resultImg
    }
    
    override init() {
        let url : URL = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        kernel = try? CIColorKernel(functionName: "myColor", fromMetalLibraryData: data)
        NSLog("color kernel : \(kernel)")
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
