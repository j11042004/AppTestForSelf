//
//  CameraViewController.swift
//  CoreMLDemo
//
//  Created by Uran on 2018/6/5.
//  Copyright © 2018年 AppCoda. All rights reserved.
//

import UIKit
import CoreML
import Vision
import AVKit
class CameraViewController: UIViewController {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var propertyNumLabel: UILabel!
    @IBOutlet weak var cameraView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else{
            return
        }
        
        guard let input = try? AVCaptureDeviceInput.init(device: captureDevice) else{
            return
        }
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.bounds
        self.cameraView.layer.addSublayer(previewLayer)
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue"))
        captureSession.addOutput(dataOutput)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.layer.sublayers?.first?.frame = self.cameraView.bounds
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CameraViewController : AVCaptureVideoDataOutputSampleBufferDelegate{
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else{
            NSLog("pixelBuffer is nil")
            return
        }
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            NSLog("model is nil")
            return
        }
        let request = VNCoreMLRequest(model: model) { (finishRequest, error) in
            if let error = error{
                NSLog("error : \(error.localizedDescription)")
            }
            guard let results = finishRequest.results as? [VNClassificationObservation] else{
                return
            }
            var item = ""
            var num : Float = 0
            // 取得最接近的信心度與名稱
            for result in results{
                if result.confidence > 1.0{
                    continue
                }
                if result.confidence > num {
                    num = result.confidence
                    item = result.identifier
                }
            }
            num = num * 100
            let numString = String(format: "%2f", num)
            DispatchQueue.main.async {
                self.itemLabel.text = "辨識到的物體名：\(item)"
                self.propertyNumLabel.text = "信心指數：\(numString)"
            }
            
        }
        
        do {
            try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        } catch {
            
        }
        
    }
}
