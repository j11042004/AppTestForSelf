//
//  ViewController.swift
//  HelloUrlScheme
//
//  Created by Uran on 2018/7/12.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var valueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getSchemeValue(_:)), name: NSNotification.Name("GetSchemeUrl"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @objc func getSchemeValue(_ note : Notification){
        guard let sendUrlStr = note.object as? String else{
            print("sendUrlStr is nil")
            return
        }
        // 將傳來的 urlScheme 用 :// 做分隔
        let sendStrArray = sendUrlStr.components(separatedBy: "://")
        let asciiStrings : String = sendStrArray.last!
        // 每隔三個就存成同樣的Unicode
        var count = 0
        var asciiWord = ""
        var asciiArray = [String]()
        for str in asciiStrings{
            asciiWord.append(str)
            count += 1
            if count == 3 {
                asciiArray.append(asciiWord)
                count = 0
                asciiWord = ""
            }
        }
        
        // 把 Ascii Code 轉成 Unicode
        var unicodeStrings : String = ""
        for ascii in asciiArray {
            guard let num : Int = Int(ascii),
                // 把 Int 轉成 Ascii Code
                let uniCode  = UnicodeScalar(num) else{
                continue
            }
            let str = String(uniCode)
            unicodeStrings.append(str)
        }
        // 將Unicode 轉成 Data -> String
        guard let unicodeData = unicodeStrings.data(using: String.Encoding.utf8) else{
            return
        }
        let str = String(data: unicodeData, encoding: String.Encoding.nonLossyASCII)
        self.valueLabel.text = str
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @IBAction func openApp2(_ sender: UIButton) {
        guard let scheme1Url = URL(string: "secondScheme://") else{
            print("scheme1Url is nil")
            return
        }
        if UIApplication.shared.canOpenURL(scheme1Url) {
            UIApplication.shared.open(scheme1Url, options: [:], completionHandler: nil)
        }else{
            NSLog("請安裝 First scheme url")
        }
    }
    
    
    @IBAction func openUwinclub(_ sender: UIButton) {
        let sendUrlStr = "com.ios.uwinclub.slot://"
        // 傳到裝在同手機上的 App 中
        guard let uwinclubUrl = URL(string: sendUrlStr) else{
            print("scheme1Url is nil")
            return
        }
        if UIApplication.shared.canOpenURL(uwinclubUrl) {
            UIApplication.shared.open(uwinclubUrl, options: [:], completionHandler: nil)
        }else{
            NSLog("請安裝 豪爺遊藝館")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

