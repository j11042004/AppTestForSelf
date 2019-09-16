//
//  ViewController.swift
//  FiveInput
//
//  Created by Uran on 2018/4/2.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputTextField.delegate = self
        self.inputTextField.addTarget(self, action: #selector(valueChange(_:)), for: UIControlEvents.editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 只取前五個字
    @objc func valueChange(_ sender: UITextField) {
        if let text = sender.text {
            let finalText  = String(text.prefix(5))
            self.showLabel.text = String(finalText)
        }
    }
    
    
}

