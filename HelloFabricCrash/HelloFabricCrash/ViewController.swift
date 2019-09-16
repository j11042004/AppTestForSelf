//
//  ViewController.swift
//  HelloFabricCrash
//
//  Created by Uran on 2018/5/25.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import Crashlytics

class ViewController: UIViewController {

    @IBAction func crash(_ sender: UIButton) {
        Crashlytics.sharedInstance().crash()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

