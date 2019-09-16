//
//  ViewController.swift
//  HelloGCD
//
//  Created by Uran on 2018/3/23.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
enum SyncType {
    case sync
    case async
}
class ViewController: UIViewController {
    var inactivityQueue : DispatchQueue!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.queueTest(syncType: .async)
//        self.qosTest()
//        self.concurrentTest()
        
//        self.initiallyInactiveQueue(mulActivity: true)
//        NSLog("Hi initiallyInactiveQueue")
//        if let queue = inactivityQueue{
//            queue.activate()
//        }
        
        
//        self.delayQueue(time: 2)
        self.globalMainSetImage()
    }
    
    @IBAction func createQueue(_ sender: UIButton) {
        
    }
    
    
    //MARK:- 同步執行與異步執行
    ///同步執行與異步執行
    func queueTest(syncType : SyncType){
        let testQueue = DispatchQueue(label: "uram.queue.test")
        switch syncType {
        case .sync:
            print("同步執行")
            testQueue.sync {
                self.run1()
            }
            self.run2()
            break
        case .async:
            print("異步執行")
            // 在主行緒的會先執行，背景執行緒的會在主執行緒的空檔值行
            testQueue.async  {
                self.run1()
            }
            self.run2()
            break
        }
        
    }
    
    //MARK:- Qos , 程式執行的優先權設定
    ///Qos , 程式執行的優先權設定
    func qosTest(){
        /* 執行緒優先順序高到低：
         userInteractive
         userInitiated
         default
         utility
         background
         unspecified
        */
        let quere1 = DispatchQueue(label: "uran.queue.test1", qos: .userInteractive)
        let quere2 = DispatchQueue(label: "uran.queue.test2", qos: .unspecified)
        // 若優先權相同就會輪流執行
        // 若一方優先權更高，高的那方會更快被執行完畢
        // 若一方的優先權為最高時，會與主執行緒交錯完成
        quere1.async {
            self.run1()
        }
        quere2.async {
            self.run2()
        }
        self.run3()
    }
    
    //MARK:- Concurrent Queues 多工處理，所有任務會被同時執行
    /// Concurrent Queues 多工處理，所有任務會被同時執行
    func concurrentTest(){
        let concurrentQueue = DispatchQueue(label: "uran.queue.test", qos: .utility, attributes: .concurrent)
        concurrentQueue.async {
            self.run1()
        }
        concurrentQueue.async {
            self.run2()
        }
        concurrentQueue.async {
            self.run3()
        }
    }
    //MARK:- 不會主動執行，當queue activity 時才會執行
    /// 不會主動執行，當queue activity 時才會執行，若要同時多工就將 attribute 設為  [.concurrent, .initiallyInactive]
    func initiallyInactiveQueue(mulActivity:Bool){
        var anotherQueue : DispatchQueue!
        if mulActivity {
            anotherQueue = DispatchQueue(label: "uran.queue.test", qos: .utility, attributes: [.concurrent, .initiallyInactive])
        }else{
            anotherQueue = DispatchQueue(label: "uran.queue.test", qos: .utility, attributes: .initiallyInactive)
        }
        self.inactivityQueue = anotherQueue
        anotherQueue.async {
            self.run1()
        }
        anotherQueue.async {
            self.run2()
        }
        anotherQueue.async {
            self.run3()
        }
    }
    
    /// 延遲做事
    func delayQueue(time :Int){
        NSLog("not delay")
        let delayTime = DispatchTimeInterval.seconds(time)
        DispatchQueue.main.asyncAfter(deadline: .now()+delayTime) {
            NSLog("Delay finish")
        }
    }
    
    /// Global and MainQueue
    func globalMainSetImage(){
        
        let imageURL: URL = URL(string: "https://www.elastic.co/assets/blt3541c4519daa9d09/maxresdefault.jpg?uid=blt3541c4519daa9d09")!
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = session.dataTask(with: imageURL) { [weak self](data, response, error) in
            if let data = data {
                print("Did download image data")
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }
        }
        dataTask.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController{
    func run1(){
        for i in 0..<10{
            print("😀",i)
        }
    }
    func run2(){
        for i in 100..<110{
            print("௹",i);
        }
    }
    func run3(){
        for i in 1000..<1010 {
            print("👽",i)
        }
    }
}


