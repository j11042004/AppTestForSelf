//
//  ViewController.swift
//  HelloAnimation
//
//  Created by Uran on 2018/6/22.
//  Copyright © 2018年 Uran. All rights reserved.
//  使用 CADisplayLink 持續跑動畫
//  一個定時器 CADisplayLink 持續時間與螢幕的刷新頻率相同

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!{
        didSet{
            countLabel.text = "\(0)"
        }
    }
    
    @IBOutlet weak var maxTextfield: UITextField! {
        didSet{
            maxTextfield.text = "\(12000)"
        }
    }
    @IBOutlet weak var minTextField: UITextField!{
        didSet{
            minTextField.text = "\(0)"
        }
    }
    
    var minValue : Double = 0
    var maxValue : Double = 12000
    let animationDuration : Double = 1.5
    var startDate = Date()
    
    lazy var displayLink = CADisplayLink(target: self, selector: #selector(self.updateHandle))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLink.isPaused = true
    }
   
    
    @IBAction func stopCount(_ sender: UIBarButtonItem) {
        self.countLabel.text = "\(minValue)"
        if displayLink.isPaused {
            return
        }
        // 把 displayLink 移除
        displayLink.remove(from: .main, forMode: .defaultRunLoopMode)
        displayLink.isPaused = true
    }
    
    @IBAction func startCount(_ sender: UIBarButtonItem) {
        guard let maxText = maxTextfield.text,
            let minText = minTextField.text ,
            let max = Double(maxText),
            let min = Double(minText)
        else {
            NSLog("最大或最小有個錯誤")
            return
        }
        maxValue = max
        minValue = min
        self.countLabel.text = "\(minValue)"
        // 更新 開始時間
        startDate = Date()
        // 若是正在執行就先移除
        if !displayLink.isPaused {
            displayLink.remove(from: .main, forMode: .defaultRunLoopMode)
        }
        // 要讓 Label 上數字像跑指數一樣變換，使用 CADisplay
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        // 設定 Paused 為 false
        displayLink.isPaused = false
    }
    
    @objc func updateHandle(){
        let now = Date()
        let passTime = now.timeIntervalSince(startDate)
        if passTime > animationDuration {
            self.countLabel.text = "\(maxValue)"
            return
        }
        // 取的 經過時間的比例
        let percentTime = passTime / animationDuration
        // 算出 該比例下的 數字
        let valueOnPercent = percentTime * (maxValue - minValue)
        self.countLabel.text = "\(valueOnPercent)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

