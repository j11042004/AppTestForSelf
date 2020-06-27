//
//  ViewController.swift
//  HelloGoogleImaAd
//
//  Created by Uran on 2020/1/16.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit
import GoogleInteractiveMediaAds
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var blueView: UIView!
    var contentPlayhead : IMAAVPlayerContentPlayhead?
    let contentPlayer = AVPlayer()
    var avLayer : AVPlayerLayer?
    var adsLoader : IMAAdsLoader?
    var adsManager : IMAAdsManager?
    let adTestTagUrlStr = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avLayer = AVPlayerLayer(player: self.contentPlayer)
        setUpContentPlayer()
        setUpAdLoader()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func requesAds(_ sender: Any) {
        requestAds(scrollContentView)
    }
}
extension ViewController {
    func setUpContentPlayer(){
        contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: contentPlayer)
    }
    func setUpAdLoader(){
        adsLoader = IMAAdsLoader(settings: nil)
        adsLoader?.delegate = self
    }
    func requestAds(_ view : UIView){
        avLayer?.removeFromSuperlayer()
        avLayer?.frame = view.bounds
        avLayer?.backgroundColor = UIColor.green.cgColor
        view.layer.addSublayer(avLayer!)
        
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: view, companionSlots: nil)
        let request = IMAAdsRequest(adTagUrl: adTestTagUrlStr, adDisplayContainer: adDisplayContainer,  contentPlayhead: contentPlayhead, userContext: nil)
        adsLoader?.requestAds(with: request)
    }
}
extension ViewController : IMAAdsLoaderDelegate{
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        adsManager = adsLoadedData.adsManager
        adsManager?.delegate = self
        let adsRenderingSetting = IMAAdsRenderingSettings()
        adsRenderingSetting.webOpenerDelegate = self
        adsManager?.initialize(with: adsRenderingSetting)
    }
    
    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        
    }
    
    
}
extension ViewController : IMAAdsManagerDelegate{
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        
    }
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        switch event.type {
        case .AD_BREAK_READY :
            NSLog("event : AD_BREAK_READY")
            break
        case .AD_BREAK_FETCH_ERROR :
            NSLog("event : AD_BREAK_FETCH_ERROR")
            break
        case .AD_BREAK_ENDED :
            NSLog("event : AD_BREAK_ENDED")
            break
        case .AD_BREAK_STARTED :
            NSLog("event : AD_BREAK_STARTED")
            break
        case .AD_PERIOD_ENDED :
            NSLog("event : AD_PERIOD_ENDED")
            break
        case .AD_PERIOD_STARTED :
            NSLog("event : AD_PERIOD_STARTED")
            break
        case .ALL_ADS_COMPLETED :
            NSLog("event : ALL_ADS_COMPLETED")
            return
        case .CLICKED :
            NSLog("event : CLICKED")
            break
        case .COMPLETE :
            NSLog("event : COMPLETE")
            return
        case .CUEPOINTS_CHANGED :
            NSLog("event : CUEPOINTS_CHANGED")
            break
        case .FIRST_QUARTILE :
            NSLog("event : FIRST_QUARTILE")
            return
        case .LOADED :
            NSLog("event : LOADED")
            break
        case .LOG :
            NSLog("event : LOG")
            break
        case .MIDPOINT :
            NSLog("event : MIDPOINT")
            return
        case .PAUSE :
            NSLog("event : PAUSE")
            break
        case .RESUME :
            NSLog("event : RESUME")
            return
        case .SKIPPED :
            NSLog("event : SKIPPED")
            return
        case .STARTED :
            NSLog("event : STARTED")
            return
        case .STREAM_LOADED :
            NSLog("event : STREAM_LOADED")
            break
        case .STREAM_STARTED :
            NSLog("event : STREAM_STARTED")
            break
        case .TAPPED :
            NSLog("event : TAPPED")
            break
        case .THIRD_QUARTILE :
            NSLog("event : THIRD_QUARTILE")
            return
        }
        adsManager.start()
    }
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        NSLog("adsManager did not receive error :\(error.message)")
    }
}
//MARK:- IMAWebOpenerDelegate
extension ViewController : IMAWebOpenerDelegate{
    func webOpenerWillOpenExternalBrowser(_ webOpener: NSObject!) {
        NSLog("點擊開啟網頁")
        adsManager?.resume()
    }
    func webOpenerWillClose(inAppBrowser webOpener: NSObject!) {
        NSLog("點擊關閉網頁")
        adsManager?.resume()
    }
}
