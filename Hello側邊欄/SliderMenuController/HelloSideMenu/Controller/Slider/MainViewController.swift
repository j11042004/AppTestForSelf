//
//  SliderMainViewController.swift
//  HelloSideMenu
//
//  Created by Uran on 2018/6/4.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {

    @IBOutlet weak var playerView: UIView!
    
    var player : AVPlayer?
    var playerLayer : AVPlayerLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("MainVC viewDidLoad")
    }
    override func viewWillAppear(_ animated: Bool) {
        NSLog("MainVC viewWillAppear")
    }
    override func viewDidAppear(_ animated: Bool) {
        let item = AVPlayerItem(url: URL(string: "http://184.72.239.149/vod/smil:bigbuckbunnyiphone.smil/playlist.m3u8")!)
        self.player = AVPlayer(playerItem: item)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer?.frame = self.playerView.layer.bounds
        self.playerView.layer.addSublayer(self.playerLayer!)
        self.player?.play()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
