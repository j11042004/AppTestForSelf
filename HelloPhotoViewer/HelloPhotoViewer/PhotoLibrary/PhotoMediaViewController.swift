//
//  PhotoMediaViewController.swift
//  HelloLivePhoto
//
//  Created by Uran on 2019/8/14.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import AVKit
class PhotoMediaViewController: UIViewController {
    public var mediaInfo : AlbumItemInfo?
    let player = AVPlayer()
    var playerItem : AVPlayerItem?
    lazy var playerLayer = AVPlayerLayer(player: self.player)
    
    @IBOutlet weak var mediaView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mediaInfo = self.mediaInfo else {return}
        var url : URL?
        switch mediaInfo.mediaType {
        case .video:
            url = mediaInfo.videoUrl
            break
        case .audio:
            url = mediaInfo.audioUrl
            break
        default:
            break
        }
        guard let playerUrl = url else {return}
        
        self.playerItem = AVPlayerItem(url: playerUrl)
        self.player.replaceCurrentItem(with: self.playerItem)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.playerLayer.frame = self.mediaView.bounds
        self.mediaView.layer.addSublayer(self.playerLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.playerLayer.frame = self.mediaView.bounds
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.playerLayer.frame = self.mediaView.bounds
    }
    
    @IBAction func play(_ sender: Any) {
        self.player.play()
    }
    @IBAction func pause(_ sender: Any) {
        self.player.pause()
    }
}
