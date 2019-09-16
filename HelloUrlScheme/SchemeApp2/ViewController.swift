//
//  ViewController.swift
//  SchemeApp2
//
//  Created by Uran on 2018/7/12.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sendTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func openScheme1(_ sender: UIButton) {
        // 要先在要開啟的 App -> Target -> info -> url Scheme 輸入要開啟的 urlScheme
        /*
         建立白名單，白名單上限為 50 個
         在本身的 info.plist 中加入 LSApplicationQueriesSchemes 「Array 型態」，在其中的 item 輸入要開啟的 urlScheme
        */
        
        // 若網址中有空白或非英文就不行
        // 要傳輸得值
        var text : String = sendTextField.text!
        text = "\(Define.scheme1)&\(text)"
        // 把 String 轉成 Unicode Data
        guard let unicodeData = text.data(using: String.Encoding.nonLossyASCII) else {
            return
        }
        guard let unicodeStr = String(data: unicodeData, encoding: String.Encoding.utf8) else{
            return
        }
        // unicode 轉成 String
        var ascillStr = ""
        for code in unicodeStr.unicodeScalars{
            let asciiCode = code.value >= 100 ? "\(code.value)" : "0\(code.value)"
            ascillStr.append(asciiCode)
        }
        
        let sendUrlStr = "com.uran.HelloUrlScheme://\(ascillStr)"
        
        // 傳到裝在同手機上的 App 中
        guard let scheme1Url = URL(string: sendUrlStr) else{
            print("scheme1Url is nil")
            return
        }
        if UIApplication.shared.canOpenURL(scheme1Url) {
            UIApplication.shared.open(scheme1Url, options: [:], completionHandler: nil)
        }else{
            NSLog("請安裝 First scheme url")
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

