//
//  ViewController.swift
//  HelloPlayVideo
//
//  Created by Uran on 2018/7/2.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreGraphics
class ViewController: UIViewController {
    var player : AVPlayer!
    var playerLayer : AVPlayerLayer!
    var count : Int = 0
    var playUrl : URL!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var timeSlider: UISlider!
    
    var paused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playDownloadVideo(_ sender: UIButton) {
        guard let url = URL(string: "http://184.72.239.149/vod/smil:bigbuckbunnyiphone.smil/playlist.m3u8") else{
            print("download Url is nil")
            return
        }
        self.play(With: url)
    }
    
    
    @IBAction func playLocalVideo(_ sender: UIButton) {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "stevejobs.mp4", withExtension: nil) else{
            print("local video is nil")
            return
        }
        self.play(With: url)
    }
    
    @IBAction func playDownloadSound(_ sender: UIButton) {
        guard let url = URL(string: "http://t.softarts.cc/class/Sample.mp3") else{
            print("download Sound is nil")
            return
        }
        self.play(With: url)
    }
    @IBAction func getVideoThumbnail(_ sender: UIButton) {
        self.getVideoThumbnail()
        
        
    }
    @IBAction func rePlayVideo(_ sender: UIButton) {
        if self.player == nil || self.playUrl == nil{
            return
        }
        self.stopAVItemLayer()
        self.play(With: self.playUrl)
    }
    @IBAction func pauseVideo(_ sender: UIButton) {
        self.player.pause()
    }
    
    @IBAction func selectTimeChanged(_ sender: UISlider) {
        if sender.value < 10 {
            return
        }
        let intValue = Int(sender.value)
        var atTime = Double(intValue)
        if atTime > Double(sender.value){
            atTime = Double(sender.value)
        }
        self.getVideoThumbnail(With: atTime)
    }
    
}


extension ViewController {
    func play(With url : URL){
        
        if self.player != nil {
            if !self.paused {
                self.player.pause()
                self.paused = true
            }else{
                self.player.play()
                self.paused = false
            }
            return
        }
        self.playUrl = url
        
        let playerItem : AVPlayerItem = AVPlayerItem(url: url)
        
        self.player = AVPlayer(playerItem: playerItem)
        // 把 player 加到 playerLayer
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.frame = self.resultImageView.frame
        // playerLayer 放到 view 上
        self.view.layer.addSublayer(self.playerLayer)
        // 播放速度
        self.player.rate = 1.0
        
        self.paused = false
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { (notification) in
            print("播放完畢")
            // 關閉 播放畫面
            DispatchQueue.main.async {
                self.stopAVItemLayer()
            }
        }
    }
    /// 移除並關閉播放畫面
    func stopAVItemLayer(){
        if self.player == nil {
            return
        }
        self.player.rate = 0.0
        
        self.playerLayer.removeFromSuperlayer()
        // 一定要先把 playLayer 移除
        
        self.player = nil
        self.playerLayer = nil
        
        // 把之前註冊的 notificiation 移除
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    /// 取得 Video 的截圖
    func getVideoThumbnail(With atTime : Double = 0){
        guard let thumbUrl = self.playUrl else {
            return
        }
        self.stopAVItemLayer()
        
        let asset : AVURLAsset = AVURLAsset(url: thumbUrl, options: nil)
        
        let videotime = asset.duration
        let videoSec = CMTimeGetSeconds(videotime)
        self.timeSlider.maximumValue = Float(videoSec)
        print("url sec : \(videoSec)")
        
        // 取得影格
        let generator : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceAfter = kCMTimeZero
        generator.requestedTimeToleranceBefore = kCMTimeZero
        
        let time = CMTimeMake(1, 2)
        if let _ = try? generator.copyCGImage(at: time, actualTime: nil){
            print("img is not nil")
        }else{
            print("img is nil")
        }
        
        do {
            let timestamp = CMTime(seconds: atTime, preferredTimescale: 60)
            let cgimg = try generator.copyCGImage(at: timestamp, actualTime: nil)
            let img = UIImage(cgImage: cgimg)
            self.resultImageView.image = img
            self.resultImageView.contentMode = .scaleAspectFit
            self.count += 1
            
        } catch  {
            print("cgimg error :\(error.localizedDescription)")
        }
    }
}

