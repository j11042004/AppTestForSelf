//
//  ViewController.swift
//  HelloSwiftDebugDefine
//
//  Created by Uran on 2019/1/10.
//  Copyright © 2019 Uran. All rights reserved.
//
//
// 設定 Objective-c DEBUG 與 RELEASE 模式：
// 前往專案的 Building Settings
// 尋找 other swift flags
// 將其展開，可在 Debug 模式與 Release 模式設定 ifdef 判斷用的辨識碼
// 辨識碼前要加 -D

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    #if DEBUG
    /// Debug 圖片 urlStr
    let urlStr = "https://i0.wp.com/dv.jredu.net/wp-content/uploads/2018/06/FreeGreatPicture.com-53470-winter-beautiful-snow-crystal.jpg"
    let color = UIColor.red
    #else
    /// Release 圖片 urlStr
    let urlStr = "https://www.southshorebreaker.ca/media/photologue/photos/cache/frozen_bubbles__large.jpg"
    let color = UIColor.blue
    #endif
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        NSLog("Debug 模式")
        #else
        NSLog("Release 模式")
        #endif
        guard let url = URL(string: urlStr) else { return }
        let request = URLRequest(url: url)
        let congigure = URLSessionConfiguration.default
        let session = URLSession(configuration: congigure)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            guard let data = data else{
                self.showAlert(message: "image data is nil")
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
                self.imageView.backgroundColor = self.color
            }
        }.resume()
    }

    fileprivate func showAlert(message : String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

