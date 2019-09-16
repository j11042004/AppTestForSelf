//
//  QrCoder.swift
//  HellowQRCode
//
//  Created by Uran on 2019/7/29.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import CoreImage
class QrCoder: NSObject {
    static let shared = QrCoder()
    func decodeQRCode(_ img : UIImage?) -> [CIFeature]?{
        guard let image = img else {return nil}
        return self.decodeQRCode(CIImage(image: image))
    }
    func decodeQRCode(_ img : CIImage?) -> [CIFeature]?{
        guard let ciImg = img else { return nil }
        let context = CIContext()
        var options : [String : Any] = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
        if ciImg.properties.keys.contains(kCGImagePropertyOrientation as String) {
            options = [CIDetectorImageOrientation: ciImg.properties[(kCGImagePropertyOrientation as String)] ?? 1]
        }else {
            options = [CIDetectorImageOrientation: 1]
        }
        guard
            let features = detector?.features(in: ciImg, options: options),
            features.count > 0
            else { return nil }
        return features
    }
}
