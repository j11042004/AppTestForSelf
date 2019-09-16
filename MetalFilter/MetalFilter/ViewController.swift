//
//  ViewController.swift
//  MetalFilter
//
//  Created by Uran on 2019/7/3.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import CoreImage
import Metal
class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    let sakuraImg = UIImage(named: "sakura")!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = sakuraImg
        
    }
    @IBAction func filterImage(_ sender: Any) {
        let colorFilter = SetColorFilter()
        guard let cgImage = sakuraImg.cgImage else {
            NSLog("cgimage is nil")
            return
        }
        let ciImg = CIImage(cgImage: cgImage)

        colorFilter.inputImg = ciImg
        guard let outputImg = colorFilter.outputImage else {
            NSLog("outputImg is nil")
            return
        }
        let resultImg = UIImage(ciImage: outputImg)
        self.imageView.image = resultImg
    }
}

