//
//  ViewController.swift
//  SwiftXibExtension
//
//  Created by Uran on 2018/6/4.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var blueView: UIView!{
        didSet{            
            let nibView = NibView.instantiateFromNib()
            nibView.bounds = blueView.bounds
            nibView.imageview.image = UIImage(named: "sakura.jpg")
            blueView.addSubview(nibView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

