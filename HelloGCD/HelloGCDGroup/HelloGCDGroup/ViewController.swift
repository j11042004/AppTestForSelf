//
//  ViewController.swift
//  HelloGCDGroup
//
//  Created by Uran on 2019/1/9.
//  Copyright © 2019 Uran. All rights reserved.
//  教學文章：https://www.jianshu.com/p/6faea7ef35bc

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    var firstImg : UIImage?
    var secondImg : UIImage?
    let groupQueue = DispatchGroup()
    let callQueue = DispatchQueue(label: "DownloadImageQueue")
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("測試 Group Gcd 使用")
        /*
         self.groupQueue.enter()
         鎖住 block Queue 中的 Block，不讓 Group Queue notify 內的 Block 在取得資料完成前就被執行
         */
        /*
        self.groupQueue.leave()
        解除鎖住 block Queue 中的 Block，讓 Group Queue notify 內的 Block 可以繼續被執行
        */
        /*
         self.groupQueue.notify(queue: self.callQueue) {}
         當 GroupQueue 工作結束後 的 彙整
        */
        self.groupQueue.enter()
        self.callQueue.async(group: self.groupQueue, execute: DispatchWorkItem(block: {
            NSLog("第一次擷取開始")
            let url = URL(string: "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?cs=srgb&dl=beautiful-blur-bright-326055.jpg&fm=jpg")!
            self.downloadData(url: url, completion: { (data, response, error) in
                if let error = error {
                    NSLog("1st image download fail : \(error.localizedDescription)")
                    NSLog("第一次擷取結束")
                    self.groupQueue.leave()
                    return
                }
                guard let data = data else{
                    NSLog("1st image data is nil")
                    NSLog("第一次擷取結束")
                    self.groupQueue.leave()
                    return
                }
                self.firstImg = UIImage(data: data)
                NSLog("第一次擷取結束")
                self.groupQueue.leave()
            })
        }))
        
        self.groupQueue.enter()
        self.callQueue.async(group: self.groupQueue, execute: DispatchWorkItem(block: {
            NSLog("第二次擷取開始")
            let url = URL(string: "https://images.pexels.com/photos/1386604/pexels-photo-1386604.jpeg?cs=srgb&dl=basket-beautiful-beauty-1386604.jpg&fm=jpg")!
            self.downloadData(url: url, completion: { (data, response, error) in
                if let error = error {
                    NSLog("2ed image download fail : \(error.localizedDescription)")
                    NSLog("第二次擷取結束")
                    self.groupQueue.leave()
                    return
                }
                guard let data = data else{
                    NSLog("2ed image data is nil")
                    NSLog("第二次擷取結束")
                    self.groupQueue.leave()
                    return
                }
                self.secondImg = UIImage(data: data)
                NSLog("第二次擷取結束")
                self.groupQueue.leave()
            })
        }))
        // 當所有的 group Queue 執行 leave 後 才會執行 Notify 中的 Code
        self.groupQueue.notify(queue: self.callQueue) {
            NSLog("開始彙整")
            DispatchQueue.main.async {
                self.firstImageView.image = self.firstImg
                self.secondImageView.image = self.secondImg
            }
        }
    }
    
    fileprivate func downloadData(url : URL, completion : @escaping (Data?, URLResponse?, Error?) -> Void){
        let request = URLRequest(url: url)
        let configure = URLSessionConfiguration.default
        let session = URLSession(configuration: configure)
        let dataTask = session.dataTask(with: request, completionHandler: completion)
        dataTask.resume()
    }
}

