//
//  ViewController.swift
//  SwiftFrameworkShow
//
//  Created by Uran on 2018/3/7.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import SwiftFramework
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let deviceName = UIDevice.current.name
        NSLog("deviceName : \(deviceName)")
    }
    
    @IBAction func show(_ sender: UIButton) {
        SwiftFramework.shared.hello()
        let swiftHello = SwiftHello.shared.sayHello()
        NSLog("Swift Hello : \(swiftHello)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

