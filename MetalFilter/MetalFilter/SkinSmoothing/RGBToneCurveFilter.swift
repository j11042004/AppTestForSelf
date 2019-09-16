//
//  RGBToneCurveFilter.swift
//  MetalFilter
//
//  Created by Uran on 2019/7/4.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import CoreImage
/// RGB 曲線調整 Filter
class RGBToneCurveFilter: CIFilter {
    public var inputImage : CIImage?
    public var inputRedControlPoints : [CIVector] = [CIVector]()
    public var inputGreenControlPoints : [CIVector] = [CIVector]()
    public var inputBlueControlPoints : [CIVector] = [CIVector]()
    public var inputRGBCompositeControlPoints : [CIVector] = [CIVector]()
    public var inputIntensity : CGFloat = 1.0
    
    private var redCurve = [CGFloat]()
    private var greenCurve = [CGFloat]()
    private var blueCurve = [CGFloat]()
    private var rpgCompositeCurve = [CGFloat]()
    private var toneCurveTexture : CIImage?
    
    private let defaultCurveControlPoints =
        [CIVector(x: 0, y: 0) ,
         CIVector(x: 0.5, y: 0.5) ,
         CIVector(x: 1 , y: 1)]
    
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
        kernel = try? CIColorKernel(functionName: "rgbToneCurveFilter", fromMetalLibraryData: data)
    }
}
