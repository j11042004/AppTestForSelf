//
//  ViewController.swift
//  HelloClosure
//
//  Created by Uran on 2018/7/10.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sam = People()
        sam.cheakAdult(name: "Sam", birthAge: 1991) { (name, age) -> Bool in
            NSLog("receive : \(Date())")
            print(name)
            print(age)
            
            return age < 18 ? false : true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

