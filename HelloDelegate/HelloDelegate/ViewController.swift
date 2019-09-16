//
//  ViewController.swift
//  HelloDelegate
//
//  Created by Uran on 2018/2/7.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ManagerDelegate {
    
    let manager : DelegateManager = DelegateManager.sharedInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(getValue(_:)), name: NSNotification.Name.init("CallSend"), object: nil)
    }
    @objc func getValue(_ note:Notification){
        guard let str = note.object
            as? String else {
            return
        }
        NSLog("Notification Call Send Get Sting :\(str)")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func show(_ sender: UIButton) {
        guard let secVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else {
            return
        
        }
        self.navigationController?.pushViewController(secVC, animated: true)
    }
    func sendValue(str: String, color: UIColor) {
        NSLog("View get Str:\(str)")
        self.view.backgroundColor = color
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSLog("View did Disappear")
    }
}

