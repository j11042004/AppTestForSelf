//
//  LiveViewController.swift
//  HelloHaishinKitSwift
//
//  Created by Uran on 2018/6/26.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import VideoToolbox
import HaishinKit
class LiveViewController: UIViewController {
    
    let sampleRate: Double = 44_100

    var rtmpConnection : RTMPConnection = RTMPConnection()
    var rtmpStream : RTMPStream!
    var sharedObject : RTMPSharedObject!
    // 模糊化效果
    var currentEffect : VisualEffect?
    // 鏡頭方向
    var currentPosition : AVCaptureDevice.Position = .back
    
    @IBOutlet weak var liveView: GLHKView!
    // UI 設定
    @IBOutlet weak var zoomLabel: UILabel!{
        didSet{
            // 設定圓形
            zoomLabel.layer.masksToBounds = false
            zoomLabel.layer.cornerRadius = zoomLabel.frame.width / 2
            zoomLabel.layer.masksToBounds = true
            // 設定邊框
            zoomLabel.layer.borderWidth = 1
            zoomLabel.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var zoomSlider: UISlider!{
        didSet{
            self.zoomSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        }
    }
    // 設定 Zoom Slider 垂直後靠右的距離
    @IBOutlet weak var zoomSliderRightConstraint: NSLayoutConstraint!{
        didSet{
            self.zoomSliderRightConstraint.constant = -self.zoomSlider.frame.height/2 + self.zoomSlider.frame.width
        }
    }
    // 設定 Zoom Slider 垂直後靠右的距離
    @IBOutlet weak var zoomLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var videoKbpsLabel: UILabel!
    @IBOutlet weak var videoKbpsSlider: UISlider!
    
    @IBOutlet weak var soundKbpsLabel: UILabel!
    @IBOutlet weak var soundKbpsSlider: UISlider!
    
    @IBOutlet weak var filterControl: UISegmentedControl!
    @IBOutlet weak var fpsControl: UISegmentedControl!
    
    @IBOutlet weak var currentFpsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 設定 UI
        // 設定 zoomLabel 在 ZoomSlider 之下的距離
        self.zoomLabelTopConstraint.constant = self.zoomSlider.frame.height / 2 + 10
        zoomLabel.text = "\(self.zoomSlider.value.string(1))x"
        
        // 設定 影像串流
        rtmpStream = RTMPStream(connection: rtmpConnection)
        
        rtmpStream.syncOrientation = true
        rtmpStream.captureSettings = [
            "sessionPreset": AVCaptureSession.Preset.hd1280x720.rawValue,
            "continuousAutofocus": true,
            "continuousExposure": true
        ]
        
        rtmpStream.videoSettings = [
            "width":720,
            "height":1280
        ]
        
        rtmpStream.audioSettings = [
            "sampleRate" : sampleRate
        ]
        // 設定 兩個 slider 預設值
        videoKbpsSlider.value = Float(RTMPStream.defaultVideoBitrate)
        soundKbpsSlider.value = Float(RTMPStream.defaultAudioBitrate)
        
        rtmpStream.mixer.recorder.delegate = LiveRecordDelegate()
        
        // 設定 kps label 的值
        videoKbpsLabel.text = self.videoKbpsSlider.value.string(1)
        soundKbpsLabel.text = self.soundKbpsSlider.value.string(1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rtmpStream.attachAudio(AVCaptureDevice.default(for: AVMediaType.audio)) { (error) in
            NSLog("attachAudio error :\(error.localizedDescription)")
        }
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: currentPosition)) { (error) in
            NSLog("get camera Error : \(error.localizedDescription)")
        }
        rtmpStream.addObserver(self, forKeyPath: "currentFPS", options: NSKeyValueObservingOptions.new, context: nil)
        // 將收到的影像放到 LiveView 上
        liveView.attachStream(rtmpStream)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // 移除觀察者
        rtmpStream.removeObserver(self, forKeyPath: "currentFPS")
        // 關閉 Stream
        rtmpStream.close()
        rtmpStream.dispose()
    }
    
    // 更換螢幕鏡頭
    @IBAction func cameraChanged(_ sender: UIButton) {
        NSLog("更換鏡頭")
        // 設定使用哪個鏡頭
        let position : AVCaptureDevice.Position = currentPosition == .back ? .front : .back
        // 重新設定 Stream 的鏡頭
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: position)) { (error) in
            NSLog("error:\(error.localizedDescription)")
        }
        currentPosition = position
    }
    // 是否開啟閃光燈
    @IBAction func flashed(_ sender: UIButton) {
        // 是否開啟閃光燈
        rtmpStream.torch = !rtmpStream.torch
    }
    
    
    
    // 控制鏡頭長短變換
    @IBAction func zoomChanged(_ sender: UISlider) {
        self.zoomLabel.text = "\(sender.value.string(1))x"
        // 開始移動鏡頭
        rtmpStream.setZoomFactor(CGFloat(sender.value), ramping: true, withRate: 5.0)
    }
    // 控制畫質變換
    @IBAction func videoKbpsChanged(_ sender: UISlider) {
        videoKbpsLabel.text = self.videoKbpsSlider.value.string(1)
        rtmpStream.videoSettings["bitrate"] = sender.value
    }
    // 控制音量變換
    @IBAction func soundKbpsChanged(_ sender: UISlider) {
        soundKbpsLabel.text = self.soundKbpsSlider.value.string(1)
        rtmpStream.audioSettings["bitrate"] = sender.value * 1024
    }
    
    /// 控制 Fps 變換
    @IBAction func fpsValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            rtmpStream.captureSettings["fps"] = 15.0
            break
        case 1:
            rtmpStream.captureSettings["fps"] = 30.0
            break
        case 2:            rtmpStream.captureSettings["fps"] = 60.0
            break
        default :
            break
        }
    }
    
    /// 控制濾鏡變換
    @IBAction func fliterValueChanged(_ sender:UISegmentedControl){
        // 看 全域變數的模糊化效果是否為 nil，若是就移除濾鏡
        if let currentEffect : VisualEffect = currentEffect{
            // 移除濾鏡
            _ = rtmpStream.unregisterEffect(video: currentEffect)
        }
        // 根據選擇的選項選擇濾鏡
        switch sender.selectedSegmentIndex {
        
        case 1:
            currentEffect = MonochromeEffect()
            _ = rtmpStream.registerEffect(video: currentEffect!)
            break
        case 2:
            currentEffect = PronameEffect()
            _ = rtmpStream.registerEffect(video: currentEffect!)
            break
        default:
            break
        }
    }
    
    // 關閉 live 畫面
    @IBAction func closeIive(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    // 暫停錄影
    @IBAction func pauseLive(_ sender: UIButton) {
        rtmpStream.togglePause()
    }
    // 開始或結束錄影
    @IBAction func recordLive(_ sender: UIButton) {
        if sender.isSelected{
            // 允許 iPhone 進入待機畫面
            UIApplication.shared.isIdleTimerDisabled = false
            sender.setTitle("⏺", for: [])
            // 關閉連線
            rtmpConnection.close()
            // rtmpConnection 移除事件聆聽者
            rtmpConnection.removeEventListener(Event.RTMP_STATUS, selector: #selector(LiveViewController.rtmpStateHandler(_:)))
        }else{
            // 不允許 iPhone 進入待機畫面
            UIApplication.shared.isIdleTimerDisabled = true
            // rtmpConnection 新增事件聆聽者
            rtmpConnection.addEventListener(Event.RTMP_STATUS, selector: #selector(LiveViewController.rtmpStateHandler(_:)))
            // 重新設定連線的 URI
            
//            rtmpConnection.connect(<#T##command: String##String#>, arguments: <#T##Any?...##Any?#>)
            sender.setTitle("⏹", for: [])
        }
        sender.isSelected = !sender.isSelected
    }
    
    @objc func rtmpStateHandler(_ notification : Notification){
        let event : Event = Event.from(notification)
        guard let data : ASObject = event.data as? ASObject ,
            let code : String = data["code"] as? String
            else {
            return
        }
        
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            // 設定 Stream 設定的標題
            rtmpStream.publish("Hello world")
            break
        default:
            break
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 若是在 main Thread 更新 FPS 數值
        if Thread.isMainThread {
            self.currentFpsLabel.text = "\(rtmpStream.currentFPS)"
        }
    }
}
class LiveRecordDelegate: DefaultAVMixerRecorderDelegate {
    override func didFinishWriting(_ recorder: AVMixerRecorder) {
        guard let writer : AVAssetWriter = recorder.writer else {
            return
        }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: writer.outputURL)
        }) { (success, error) in
            do{
                try FileManager.default.removeItem(at: writer.outputURL)
            }catch let removeError {
                NSLog("remove Error : \(removeError.localizedDescription)")
            }
        }
    }
}
