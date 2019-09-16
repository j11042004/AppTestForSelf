//
//  PlayerView.swift
//  HiPlayerForYT
//
//  Created by Uran on 2019/5/17.
//  Copyright © 2019 Uran. All rights reserved.
//

import Cocoa
import AVKit
class PlayerView: NSView {
    
    @IBOutlet var view: NSView!
    @IBOutlet weak var playerView: AVPlayerView!
    fileprivate let player = AVPlayer()
    fileprivate var playerItem : AVPlayerItem?
    fileprivate var lastPlayUrl : URL?
    
    //Control View
    @IBOutlet weak var controlView: NSView!
    fileprivate var totoalTime : Double = 0 {
        didSet{
            if self.totoalTime == 0 {
                return
            }
            
        }
    }
    
    
    //MARK:- Init
    convenience init(){
        self.init(frame: CGRect.zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customerInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customerInit()
    }
    fileprivate func customerInit(){
        let xibStr = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        
        bundle.loadNibNamed(xibStr, owner: self, topLevelObjects: nil)
        view.frame = self.bounds
        self.addSubview(view)
        
        self.playerView.controlsStyle = .none
        self.playerView.player = self.player
    }
    public func change(url : URL){
        let playerItem = AVPlayerItem(url: url)
        self.playerView.player?.replaceCurrentItem(with: playerItem)
        self.playerItem = playerItem
        totoalTime = 0
    }
}

extension PlayerView {
    fileprivate func removeObserver(){
        self.playerView.player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        self.playerView.player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.error))
        self.playerView.player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.duration))
        
        self.playerView.player?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.status))
    }
    fileprivate func addObserver(){
        self.playerView.player?.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new ], context: nil)
        self.playerView.player?.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.error), options: [.new ], context: nil)
        self.playerView.player?.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.duration), options: [.new , .old ], context: nil)
        
        self.playerView.player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.new , .old], context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(AVPlayerItem.status),
            let status = self.playerView.player?.currentItem?.status
        {
            
            switch status {
            case .readyToPlay:
                NSLog("AVPlayer Item readyToPlay")
                self.playerView.player?.volume = 0.2
                self.playerView.player?.play()
                break
            case .failed:
                self.playerView.player?.pause()
                NSLog("AVPlayer Item Failed")
                break
            case .unknown:
                self.playerView.player?.pause()
                NSLog("AVPlayer Item unknown")
                break
            default:
                self.playerView.player?.pause()
                NSLog("AVPlayer Item unknown default")
                break
            }
        }
        if keyPath == #keyPath(AVPlayerItem.error) ,
            let playerItem = self.playerView.player?.currentItem{
            NSLog("取得的 Player Item Error : \(playerItem.error?.localizedDescription)")
        }
        if keyPath == #keyPath(AVPlayerItem.duration) ,
            let duration = self.playerView.player?.currentItem?.duration
        {
            self.totoalTime = duration.seconds
        }
        
        if keyPath == #keyPath(AVPlayer.status) ,
            let playerStatus = self.playerView.player?.status{
            switch playerStatus{
            case .readyToPlay:
                NSLog("Player Status readyToPlay")
                self.playerView.player?.play()
                break
            case .failed:
                NSLog("Player Status failed")
                break
            case .unknown:
                NSLog("Player Status unknown")
                break
            default :
                NSLog("Player Status unknown default")
                break
            }
        }
    }
}
