//
//  ViewController.swift
//  HelloReplayKit
//
//  Created by Uran on 2020/4/13.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit
import ReplayKit

class ViewController: UIViewController {
    var broadcastActivityVC : RPBroadcastActivityViewController?
    var broadcastController : RPBroadcastController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        if #available(iOS 13.0, *){
            if let scene = UIApplication.shared.connectedScenes.first {
                let windowScene = UIApplication.shared.keyWindow?.windowScene
                NSLog("scene : \(scene)")
                NSLog("windowScene : \(windowScene)")
                let viewScene = self.view.window?.windowScene
                NSLog("viewScene : \(viewScene)")
                
            }
        }
        
        if #available(iOS 12.0, *) {
            let w : CGFloat = 50
            let h : CGFloat = 50
            let broadcastPicker = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: w, height: h))
            broadcastPicker.backgroundColor = .blue
            broadcastPicker.showsMicrophoneButton = true
            broadcastPicker.preferredExtension = "com.uran.HelloReplayKit.BroadcastUpload"
            self.view.addSubview(broadcastPicker)
            broadcastPicker.translatesAutoresizingMaskIntoConstraints = false
            var topRange : CGFloat = 100
            if let height =  self.navigationController?.navigationBar.frame.height {
                topRange = height
            }
            let top = broadcastPicker.topAnchor.constraint(equalToSystemSpacingBelow: self.view.safeAreaLayoutGuide.topAnchor, multiplier: -topRange)
            let left = broadcastPicker.leftAnchor.constraint(equalToSystemSpacingAfter: self.view.safeAreaLayoutGuide.leftAnchor, multiplier: 0)
            let width = broadcastPicker.widthAnchor.constraint(equalToConstant: w)
            let height = broadcastPicker.heightAnchor.constraint(equalToConstant: h)
            
            top.isActive = true
            left.isActive = true
            width.isActive = true
            height.isActive = true
            
//            self.view.layoutIfNeeded()
        } 
    }
    @IBAction func startLive(_ sender : Any){
        if #available(iOS 11.0, *) {
            // 直接指定要的 setUI Extension，若無的話就會跳出到 Apple store 的下載別的 app 的 alert
            RPBroadcastActivityViewController.load(withPreferredExtension: "com.uran.HelloReplayKit.BroadcastUploadSetupUI") { (broadcastActivityVC, error) in
                if let error = error {
                    NSLog("load RPBroadcastActivityViewController error : \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    guard let broadcastVC = broadcastActivityVC else { return }
                    NSLog("broadcastActivityVC : \(broadcastVC)")
                    self.broadcastActivityVC = broadcastVC
                    self.broadcastActivityVC?.delegate = self
                    self.broadcastActivityVC?.modalPresentationStyle = .custom
                    self.present(self.broadcastActivityVC!, animated: true)
                }
            }
        } else {
            RPBroadcastActivityViewController.load
            { (broadcastActivityVC, error) in
                if let error = error {
                    NSLog("load RPBroadcastActivityViewController error : \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    guard let broadcastVC = broadcastActivityVC else { return }
                    NSLog("broadcastActivityVC : \(broadcastVC)")
                    self.broadcastActivityVC = broadcastVC
                    self.broadcastActivityVC?.delegate = self
                    self.present(self.broadcastActivityVC!, animated: true)
                }
            }
        }
        
    }
    @IBAction func finishLive(_ sender : Any){
        self.broadcastController?.finishBroadcast()
        { (error) in
            if let error = error {
                NSLog("error : \(error.localizedDescription)")
            }
        }
    }
}

extension ViewController : RPBroadcastActivityViewControllerDelegate {
    func broadcastActivityViewController(_ broadcastActivityViewController: RPBroadcastActivityViewController, didFinishWith broadcastController: RPBroadcastController?, error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                NSLog("Finish With broadcastController Error : \(error.localizedDescription)")
            }
            self.broadcastActivityVC?.dismiss(animated: true)
            self.broadcastController = broadcastController
            NSLog("broadcastController : \(broadcastController)")
            broadcastController?.startBroadcast()
            { (error) in
                if let error = error {
                    NSLog("start Broadcast error : \(error.localizedDescription)")
                    return
                }else {
                    NSLog("正常直播")
                }
            }
        }
        
    }
    
    
}
