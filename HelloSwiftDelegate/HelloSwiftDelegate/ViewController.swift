//
//  ViewController.swift
//  HelloSwiftDelegate
//
//  Created by Uran on 2017/12/15.
//  Copyright © 2017年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController,sendValueDelegate {
    
    
    var textLabel :UILabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/4, y: 100, width: self.view.frame.size.width/2, height: 30))
        textLabel.backgroundColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 0.8)
        self.view.addSubview(textLabel)
        let goDelegateVCBtn = UIButton(frame: CGRect(x: self.view.frame.size.width/2-self.view.frame.size.width/8, y: 200, width: self.view.frame.size.width/4, height: 30))
        goDelegateVCBtn.setTitle("Go Next", for: UIControlState.normal)
        goDelegateVCBtn.backgroundColor = UIColor.red
        goDelegateVCBtn.addTarget(self, action: #selector(goNextVC), for: UIControlEvents.touchUpInside)
        self.view.addSubview(goDelegateVCBtn)
    }
    @objc func goNextVC() {
        let next = storyboard?.instantiateViewController(withIdentifier: "DelegateViewController") as! DelegateViewController
        // 簽訂 sendValueDelegate 
        next.delegate = self
        self.present(next, animated: true, completion: nil)
    }
    
    
    
    func sendValue(string: String?) {
        
        self.textLabel.text = string
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

