//
//  ViewController.swift
//  Hello3DES
//
//  Created by Uran on 2018/6/6.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let secreat = TripleDes.sharedInstance
    let word = "Hello, World"
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func 進行3DES加密(_ sender: UIButton) {
        let password = "12345iejdl"
        let dict : [String : Any] = ["Hello" : 2]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted) else{
            NSLog("json data is nil")
            return
        }
        // 將 Json Data 加密
        guard let secertData = self.secreat.encryptTo3DES(encryptData: jsonData, WithKey: password) else{
            return
        }
        // 將 Data 轉成 16 進制的 Ascii 的 String
        let jsonSecretStr = secertData.changeToHexString
        // 將 16 進制的 Ascii 的 String 轉成 [Uint8]
        let jsonSecertBytes = jsonSecretStr.hexStringToBytes
        // 將 [Uint8] 轉成 Data
        let jsonBytesData = Data(bytes: jsonSecertBytes, count: jsonSecertBytes.count)
        // 做 3Des 解密
        guard let decryptData = self.secreat.decrypt3DES(inputData: jsonBytesData, WithKey: password) else{
            NSLog("decryptData is nil")
            return
        }
        // 轉成 Json 檔
        if let decrtptJson = try? JSONSerialization.jsonObject(with: decryptData, options: JSONSerialization.ReadingOptions.allowFragments){
            NSLog("decrtptJson : \(decrtptJson)")
        }
        
    }
    @IBAction func 進行3DES解密(_ sender: UIButton) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class Manage3DES: NSObject {
    


    
}



