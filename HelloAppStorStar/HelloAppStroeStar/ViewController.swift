//
//  ViewController.swift
//  HelloAppStroeStar
//
//  Created by Uran on 2018/5/11.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var appImageView: AppraiseImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        appImageView.setRating(15)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

