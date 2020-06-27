//
//  BroadcastSetupViewController.swift
//  BroadcastUploadSetupUI
//
//  Created by Uran on 2020/4/16.
//  Copyright © 2020 Uran. All rights reserved.
//
// 要設定預設的 UIViewcontroller 要去 info.plist 的 UIExtension 選項改
// 在 NSExtensionAttributes ->
//   若設定 NSExtensionPrincipalClass 就設定 Viewcontroller.swift 檔位置($(PRODUCT_MODULE_NAME).BroadcastSetupViewController)，但沒 UI 畫面可實作

//   若要設定用 storyboard 就要設定 NSExtensionMainStoryboard 這個 key ，value 就設定 Storyboard 的 name
//  NSExtensionPrincipalClass 與 NSExtensionMainStoryboard 兩個同時存在時會衝突


import ReplayKit

class BroadcastSetupViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    @IBAction func startLive(_ sender: Any) {
        self.userDidFinishSetup()
    }
    @IBAction func cancel(_ sender: Any) {
        self.userDidCancelSetup()
    }
    
    
    func userDidFinishSetup() {
        // URL of the resource where broadcast can be viewed that will be returned to the application
        let broadcastURL = URL(string:"http://apple.com/broadcast/streamID")
        
        // Dictionary with setup information that will be provided to broadcast extension when broadcast is started
        let setupInfo: [String : NSCoding & NSObjectProtocol] = ["broadcastName": "example" as NSCoding & NSObjectProtocol]
        
        // Tell ReplayKit that the extension is finished setting up and can begin broadcasting
        if #available(iOSApplicationExtension 11.0, *) {
            self.extensionContext?.completeRequest(withBroadcast: broadcastURL!, setupInfo: setupInfo)
        } else {
            let configuration = RPBroadcastConfiguration()
            configuration.clipDuration = 5.0
            self.extensionContext?.completeRequest(withBroadcast: broadcastURL!, broadcastConfiguration: configuration, setupInfo: setupInfo)
        }
    }
    
    func userDidCancelSetup() {
        let error = NSError(domain: "YouAppDomain", code: -1, userInfo: nil)
        // Tell ReplayKit that the extension was cancelled by the user
        self.extensionContext?.cancelRequest(withError: error)
    }
}
