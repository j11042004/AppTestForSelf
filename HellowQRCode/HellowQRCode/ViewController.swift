//
//  ViewController.swift
//  HellowQRCode
//
//  Created by Uran on 2019/7/29.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let wikiImg = UIImage(named: "wikiQrcode.png")
    let dnaImag = UIImage(named: "dnaQrcode.png")
    let testImage = UIImage(named: "qrTest.png")
    let dnaLiveImage = UIImage(named: "dnaLive.png")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = dnaImag
    }
    @IBAction func changeImage(_ sender: Any) {
        switch imageView.image {
        case dnaImag:
            imageView.image = wikiImg
            break
        case wikiImg:
            imageView.image = dnaLiveImage
            break
        case dnaLiveImage :
            imageView.image = testImage
            break
        default:
            imageView.image = dnaImag
            break
        }
    }
    @IBAction func decodeImage(_ sender: Any) {
        guard let features = QrCoder.shared.decodeQRCode(self.imageView.image)
            else{
                NSLog("can't decode Image")
                return
        }
        NSLog("features count : \(features.count)")
        for feature in features {
            print("feature : \(feature)")
            if let qrCodeFeature = feature as? CIQRCodeFeature {
                NSLog("QRCode Feature : \(qrCodeFeature.messageString)")
            }
            if let textCodeFeature = feature as? CITextFeature {
                NSLog("Text Feature : \(textCodeFeature)")
            }
        }
    }
    
}

