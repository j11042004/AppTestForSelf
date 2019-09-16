//
//  ViewController.swift
//  FaceDetection
//
//  Created by Uran on 2018/6/8.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let image = UIImage(named: "people.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = image
        self.imageView.contentMode = .scaleAspectFit
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 422 * 285
    }
    @IBAction func faceDetection(_ sender: Any) {
        self.imageView.layer.sublayers?.removeAll()
        let request =  VNDetectFaceRectanglesRequest(completionHandler: self.rectRequestHandle(_:_:))
        guard let cgImg = imageView.image?.cgImage else {
            NSLog("cgImg is nil")
            return
        }
        let handle = VNImageRequestHandler(cgImage: cgImg, orientation: .up)
        do{
            try handle.perform([request])
        }catch let reqErr {
            NSLog("request Error : \(reqErr.localizedDescription)")
        }
    }
}
//MARK:- 臉部位址辨識
extension ViewController{
    func rectRequestHandle(_ request : VNRequest, _ error : Error?){
        if let error = error{
            NSLog("request error :\(error.localizedDescription)")
            return
        }
        guard let results = request.results
            else{ return }
        NSLog("臉部辨識 一共有 \(results.count) 張臉")
        for result in results{
            guard let faceObserVation = result as? VNFaceObservation
                else {
                    NSLog("faceObserVation is nil")
                    continue
            }
            self.faceRectProcess(faceObserVation)
        }
    }
    func faceRectProcess(_ observation : VNFaceObservation){
        // boundingBox 是此座標在 Image 上的比例
        let obserRect = observation.boundingBox
        DispatchQueue.main.async {
            // 取得 image 在 ImageView 上的 Frame
            let rect = AVMakeRect(aspectRatio: self.imageView.image!.size, insideRect: self.imageView.bounds)
            let width = rect.width * obserRect.size.width
            let height = rect.height * obserRect.size.height
            let x = rect.width * obserRect.origin.x
            // y 在此設定
            let currentY = rect.maxY - (obserRect.origin.y * rect.height + height)
            let layer = CALayer()
            layer.frame = CGRect(x: x, y: currentY, width: width, height: height)
            layer.borderWidth = 1.5
            layer.borderColor = UIColor.red.cgColor
            self.imageView.layer.addSublayer(layer)
        }
    }
}
