//
//  ViewController.swift
//  HelloVision
//
//  Created by Uran on 2018/6/4.
//  Copyright © 2018年 Uran. All rights reserved.
//  文字辨識系統


// vision Framework 使用流程
/*
 Requests – Requests 是指當你要求 Framework 為你偵測一些東西時。
 Handlers – Handlers 是指當你想要 Framework 在 Request 產生後執行一些東西或處理這個 Request 時.
 Observations – Observations 是指你想要用你提供的資料做什麼。
 */


import UIKit
import AVFoundation
import Vision
class ViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIImageView!
    // 建立一個即時與非即時的影音截取物件
    var session = AVCaptureSession()
    var requests : [VNRequest] = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 這時候因為 UIImageView 還未開始取的範圍，所以要在 viewDidLayoutSubviews 設定底下 laver 的範圍
        self.startLiveVideo()
        self.startTextDetection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.layer.sublayers?.first?.frame = self.cameraView.bounds
    }
    
    
    /// 設定並影像擷取，與開始擷取影像
    func startLiveVideo(){
        // 設定影像的 type 是可以即時更新的影片
        session.sessionPreset = AVCaptureSession.Preset.photo
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        // 定義相機所看到的影像
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        // 定義相機輸出到螢幕上的影像
        let deviceOutput = AVCaptureVideoDataOutput()
        // 設定輸出到螢幕上的影像格式
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32BGRA)]
        // 設定輸出時的 Delegate，以及在哪個 Queue 下執行
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        
        // 設定影音截取物件的範圍
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        // 設定這行 imageLayer 才會佈滿整個 CameraView
        cameraLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraLayer.frame = cameraView.bounds
        // 把它加到 ImageView 的 Laver 上
        cameraView.layer.addSublayer(cameraLayer)
        // 開始進行擷取影像
        session.startRunning()
    }
    
    // 開始進行影像辨識
    func startTextDetection(){
        let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
        let detectBarCodeRequest = VNDetectBarcodesRequest { (request, error) in
            if let error = error{
                NSLog("barcode Error :\(error.localizedDescription)")
                return
            }
            guard let results = request.results else {
                return
            }
            NSLog("barcode result : \(results.count)")
            for result in results{
                NSLog("result : \(result)")
            }
        }
        // 設定是否要回報字母的辨識 Boxes
        textRequest.reportCharacterBoxes = true
        self.requests = [textRequest , detectBarCodeRequest]
    }
    /// 將 VNDetectTextRectanglesRequest 的結果 VNRequest 轉成 VNTextObservation，以及處理 VNRequest
    func detectTextHandler(request: VNRequest, error: Error?) {
        if let error = error {
            NSLog("VNRequest request Error :\(error.localizedDescription) ")
        }
        guard let observations = request.results else {
            NSLog("observations is nil")
            return
        }
        // 將所有 Request 的結果轉成 VNTextObservation
        let results = observations.map({$0 as? VNTextObservation})
        // 先移除除了 sublayers[0]（AVCapturesession） 之外的 layer
        DispatchQueue.main.async {
            self.cameraView.layer.sublayers?.removeSubrange(1...)
            for result in results{
                guard let region = result else{
                    continue
                }
                // 畫出 單字 的範圍
                self.drawWordRect(region)
                // 取的字母的結果
                if let boxes = region.characterBoxes {
                    for charBox in boxes {
                        self.drawLetterRect(charBox)
                    }
                }
            }
        }
    }
    /// 為辨識到的單字加上紅框
    func drawWordRect(_ observation : VNTextObservation){
        guard let boxes = observation.characterBoxes else {
            NSLog("VNTextObservation's boxes are nil")
            return
        }
        var maxX : CGFloat = 9999.0
        var minX : CGFloat = 0.0
        var maxY : CGFloat = 9999.0
        var minY : CGFloat = 0.0
        
        // 取得每個單字的最大和最小座標
        for char in boxes{
            if char.bottomLeft.x < maxX {
                maxX = char.bottomLeft.x
            }
            if char.bottomRight.x > minX {
                minX = char.bottomRight.x
            }
            if char.bottomRight.y < maxY {
                maxY = char.bottomRight.y
            }
            if char.topRight.y > minY {
                minY = char.topRight.y
            }
        }
        // 取得框線的 X，Y，Width，Height
        let xCord = maxX * cameraView.frame.size.width
        let yCode = (1-minY) * cameraView.frame.size.height
        let width = (minX - maxX) * cameraView.frame.size.width
        let height = (minY - maxY) * cameraView.frame.size.height
        
        let wordLine = CALayer()
        wordLine.frame = CGRect(x:xCord, y: yCode, width: width, height: height)
        wordLine.borderWidth = 2
        wordLine.borderColor = UIColor.red.cgColor
        
        cameraView.layer.addSublayer(wordLine)
    }
    /// 畫出 字母 的範圍
    func drawLetterRect(_ box: VNRectangleObservation) {
        let xCord = box.topLeft.x * cameraView.frame.size.width
        let yCord = (1 - box.topLeft.y) * cameraView.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * cameraView.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * cameraView.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 1.0
        outline.borderColor = UIColor.blue.cgColor
        
        cameraView.layer.addSublayer(outline)
    }
    
}


extension ViewController : AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            NSLog("pixelBuffer is nil")
            return
        }
        var requestOptions : [VNImageOption : Any] = [:]
        if let cameraData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [VNImageOption.cameraIntrinsics : cameraData]
        }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
        do {
            try imageRequestHandler.perform(self.requests)
        } catch  {
            NSLog("imageRequestHandler error : \(error.localizedDescription)")
        }
        
    }
}
