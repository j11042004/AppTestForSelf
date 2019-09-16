//
//  ViewController.swift
//  HelloClosure
//
//  Created by Uran on 2018/2/7.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let send : SendManager = SendManager.sharedInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        send.sendValue { (str, color) in
            if let str = str{
                NSLog("str is :\(str)")
            }else{
                NSLog("str is nil")
            }
            if let color = color {
                self.view.backgroundColor = color
            }else{
                NSLog("color is nil")
                self.view.backgroundColor = UIColor.white
            }
        }
    }
    @IBAction func show(_ sender: UIButton) {
        guard let secVC = self.storyboard?.instantiateViewController(withIdentifier: "SecViewController") as? SecViewController else {
            return
        }
        self.present(secVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

