//
//  ViewController.swift
//  HelloDispatchSemaphore
//
//  Created by Uran on 2020/1/14.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController {
    
    let redStr = "🔴"
    let blueStr = "🔵"
    let redQueue = DispatchQueue.global(qos: .userInitiated)
    let blueQueue = DispatchQueue.global(qos: .utility)
    let sameQueue = DispatchQueue(label: "SameRunQueue")
    let semaphore = DispatchSemaphore(value: 1)
    let redSemphore = DispatchSemaphore(value: 1)
    let blueSemphore = DispatchSemaphore(value: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.asyncPrint(queue: sameQueue, symbol: redStr, runSemaphore: true)
        self.asyncPrint(queue: sameQueue, symbol: blueStr, runSemaphore: true)
    }
    func asyncPrint(queue: DispatchQueue, symbol: String , runSemaphore run : Bool) {
        NSLog("run async queue \(symbol)")
        queue.async {
            print("\(symbol) waiting")
            if run{
                // 告知 semaphore 正在使用中
                self.semaphore.wait()
            }
            

            for i in 0...10 {
              print(symbol, i)
            }
            print("\(symbol) signal")
            if run {
                // 告知 semaphore 使用完畢
                self.semaphore.signal()
            }
            
        }
    }

}

