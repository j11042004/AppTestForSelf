//
//  ViewController.swift
//  CustomSlider
//
//  Created by Uran on 2019/5/20.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var testSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.testSlider.setThumbImage(UIImage(named: "長方形.png")!, for: .normal)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for subView in self.testSlider.subviews{
            if subView.subviews.count == 0{
                continue
            }
            for subSubView in subView.subviews{
                NSLog("subSubView :\(subSubView)")
            }
        }
    }

}

