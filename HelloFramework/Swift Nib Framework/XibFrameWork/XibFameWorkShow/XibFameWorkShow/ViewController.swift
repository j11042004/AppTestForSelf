//
//  ViewController.swift
//  XibFameWorkShow
//
//  Created by Uran on 2018/3/26.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import DownloadSDK
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showAction(_ sender: UIButton) {
        self.showDownloadView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showDownloadView() {
        
        let downloadView = DownloadView(frame: self.view.bounds)
        
        downloadView.set(headline: "Hello")
        downloadView.set(subHeadline: "Good")
        self.view.addSubview(downloadView)
    }

}

