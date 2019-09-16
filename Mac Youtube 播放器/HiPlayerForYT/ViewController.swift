//
//  ViewController.swift
//  HiPlayerForYT
//
//  Created by Uran on 2019/5/16.
//  Copyright © 2019 Uran. All rights reserved.
//

import Cocoa
import XCDYouTubeKit
import GoogleAPIClientForREST
import AVFoundation
import AVKit
import Carbon

/// 搜尋的 type
enum SearchType : String {
    case video = "影片"
    case playList = "播放清單"
    case channel = "頻道"
}

class ViewController: NSViewController {
    //MARK: - Player
    @IBOutlet weak var playerView: AVPlayerView!
    /// 正在播放到的 PlayerItem
    fileprivate var playerItem : AVPlayerItem?
    /// 正在播放的 Player
    fileprivate let player = AVPlayer()
    fileprivate var lastPlayUrl : URL?
    fileprivate var nowVideoInfo : VideoInfo?
    @IBOutlet weak var selectTypePopUpBtn: NSPopUpButton!
    
    //MARK:- Search
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var sendBtn: NSButton!
    fileprivate var searchType : SearchType = .video
    
    fileprivate let youtubeClient = XCDYouTubeClient.default()
    //MARK:- Youtube
    
    //MARK:- TableView
    
    @IBOutlet weak var tableView: NSTableView!
    let column = "CellColumn"
    let cellField = "CellField"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerView.player = self.player
        self.playerView.videoGravity = .resizeAspect
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerPlayToEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        let testPlayerview = PlayerView()
        self.view.addSubview(testPlayerview)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear() {
        super.viewWillAppear()
        let videoID = "FMl7GEaYwAE"
        
        self.loadYoutubeInfo(videoId: videoID){
            videoInfo in
            guard
                let videoInfo = videoInfo ,
                let videoUrl = videoInfo.streamUrls.first
            else { return }
            self.nowVideoInfo = videoInfo
            self.changeItem(videoUrl)
        }
    }
    override func viewDidAppear() {
        super.viewDidAppear()
        // 將 FirstResponder 設為 Self ，否則 firstResponder 會一直固定在 SearchField 上
        NSApplication.shared.keyWindow?.makeFirstResponder(self)
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    //MARK: - IBAction
    /// 傳送搜尋要求
    @IBAction func sendSearch(_ sender: NSButton) {
        let searchStr = self.searchField.stringValue
        NSApplication.shared.keyWindow?.makeFirstResponder(self)
        if searchStr == "" { return }
        self.searchField.stringValue = ""
        self.search(word: searchStr)
    }
    /// 更換要搜尋的 Type
    @IBAction func changeSearchType(_ sender: NSPopUpButton) {
        switch sender.titleOfSelectedItem {
        case SearchType.channel.rawValue:
            self.searchType = .channel
            break
        case SearchType.playList.rawValue:
            self.searchType = .playList
            break
        default:
            self.searchType = .video
            break
        }
    }
    override func keyDown(with event: NSEvent) {
        let code = event.keyCode
        NSLog("code : \(code)")
        NSLog("self.playerView.frame : \(self.playerView.frame) , \(NSScreen.main?.frame)")
        
        
        if code == 53
        {
            if self.view.isInFullScreenMode{
                self.view.exitFullScreenMode(options: nil)
            }
            if self.playerView.isInFullScreenMode {
                self.playerView.exitFullScreenMode(options: nil)
            }
            if self.playerView.frame.size == NSScreen.main?.frame.size{
                
                self.playerView.showsFullScreenToggleButton = false
                self.playerView.showsFullScreenToggleButton = true
            }
        }
    }
    override func mouseDown(with event: NSEvent) {
        NSLog("mouse Down")
        NSApplication.shared.keyWindow?.makeFirstResponder(self)
    }
}
//MARK: Private Func
extension ViewController{
    /// 讀取 搜尋 Youtube
    fileprivate func search(word : String){
        YoutubeManager.stand.search(with: word, type: self.searchType) { (results) in
            
        }
    }
    /// 讀取 Youtube Video Info
    fileprivate func loadYoutubeInfo(videoId : String , completion: @escaping (VideoInfo?)->Void){
        youtubeClient.getVideoWithIdentifier(videoId)
        { (youtubeInfo, error) in
            if let error = error {
                NSLog("取得 Video Info Error : \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let youtubeInfo = youtubeInfo else{
                completion(nil)
                return
            }
            let streamUrls = youtubeInfo.streamURLs
            var currentStremUrls = [URL]()
            
            if let liveStreamingUrl = streamUrls[XCDYouTubeVideoQualityHTTPLiveStreaming]{
                NSLog("取得 Live Stream \(XCDYouTubeVideoQualityHTTPLiveStreaming)")
                currentStremUrls.append(liveStreamingUrl)
            }
            if let hd720Url = streamUrls[XCDYouTubeVideoQuality.HD720.rawValue]{
                NSLog("取得 hd720 Stream \(XCDYouTubeVideoQuality.HD720.rawValue)")
                currentStremUrls.append(hd720Url)
            }
            if let medium360Url = streamUrls[XCDYouTubeVideoQuality.medium360.rawValue] {
                NSLog("取得 medium360 Stream \(XCDYouTubeVideoQuality.medium360.rawValue)")
                currentStremUrls.append(medium360Url)
            }
            if let small240Url = streamUrls[XCDYouTubeVideoQuality.small240.rawValue]{
                NSLog("取得 small240 Stream \(XCDYouTubeVideoQuality.small240.rawValue)")
                currentStremUrls.append(small240Url)
            }
            let videoInfo = VideoInfo(id: youtubeInfo.identifier, title: youtubeInfo.title, totalSec: youtubeInfo.duration , thunbnailUrl: youtubeInfo.thumbnailURL , streamUrls : currentStremUrls)
            DispatchQueue.main.async {
                completion(videoInfo)
                return
            }
        }
    }
    /// 更換要播放的影片
    fileprivate func changeItem(_ url : URL){
        DispatchQueue.main.async {
            if self.playerView.player?.currentItem != nil{
                self.removeObserver()
            }
            self.playerItem = AVPlayerItem(url: url)
            self.playerView.player?.replaceCurrentItem(with: self.playerItem)
            self.addObserver()
            self.player.play()
            self.lastPlayUrl = url
        }
    }
}
//MARK:- Notification Func
extension ViewController{
    @objc fileprivate func playerPlayToEnd(){
        guard let lastUrl = self.lastPlayUrl else{ return }
        NSLog("播放到最後")
        self.changeItem(lastUrl)
    }
}
//MARK:- NSTableViewDelegate
extension ViewController : NSTableViewDelegate{
    
}
//MARK:- NSTableViewDataSource
extension ViewController : NSTableViewDataSource{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 2
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard
            let identifier =  tableColumn?.identifier
        else {
            return nil
        }
        let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
        cell?.textField?.stringValue = "identifier \(row)"
        return cell
    }
}
//MARK:- Observer
extension ViewController {
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
        func changeNextUrl(){
            guard
                let playingUrl = self.lastPlayUrl,
                let streamUrls = self.nowVideoInfo?.streamUrls,
                let index = streamUrls.firstIndex(of: playingUrl),
                streamUrls.count > index+1
                else {
                    NSLog("正在播放中的 url 是 nil ")
                    return
            }
            NSLog("現在播放中的 index :\(index)")
            let newUrl = streamUrls[index+1]
            self.changeItem(newUrl)
        }
        
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
                changeNextUrl()
                break
            case .unknown:
                self.playerView.player?.pause()
                NSLog("AVPlayer Item unknown")
                changeNextUrl()
                break
            default:
                self.playerView.player?.pause()
                NSLog("AVPlayer Item unknown default")
                changeNextUrl()
                break
            }
        }
        if keyPath == #keyPath(AVPlayerItem.error) ,
            let playerItem = self.playerView.player?.currentItem{
            NSLog("取得的 Player Item Error : \(playerItem.error?.localizedDescription)")
            changeNextUrl()
        }
        if keyPath == #keyPath(AVPlayerItem.duration) ,
            let duration = self.playerView.player?.currentItem?.duration
            {
                NSLog("總時間 :\(duration.seconds)")
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
