//
//  ViewController.swift
//  NavigationSelfTitleView
//
//  Created by Uran on 2018/11/7.
//  Copyright © 2018 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 每個 vc 的 title view 要 自己設定
        if let navigationbar = self.navigationController?.navigationBar{
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: navigationbar.frame.height))
            titleView.backgroundColor = .green
            let titleuBtton = UIButton(type: .custom)
            titleuBtton.backgroundColor = .blue
            titleuBtton.addTarget(self, action: #selector(titleButton(sender:)), for: UIControl.Event.touchUpInside)
            titleuBtton.frame = titleView.bounds
            titleView.addSubview(titleuBtton)
            self.navigationController?.navigationItem.titleView = titleView
            self.navigationItem.titleView = self.navigationController?.navigationItem.titleView
        }
    }

    @IBAction func showRedVC(_ sender: UIButton) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redVC = mainStoryBoard.instantiateViewController(withIdentifier: "RedViewController") as! RedViewController
        if let navigationVC = self.navigationController {
            navigationVC.pushViewController(redVC, animated: true)
        }else{
            self.present(redVC, animated: true, completion: nil)
        }
    }
    @objc func titleButton(sender : UIButton){
        NSLog("Title push")
    }
}

