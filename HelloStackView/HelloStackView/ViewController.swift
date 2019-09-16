//
//  ViewController.swift
//  HelloStackView
//
//  Created by Uran on 2019/6/17.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var baseButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<3{
            let button = UIButton()
            button.setTitle("test \(index)", for: .normal)
            let red = CGFloat(arc4random_uniform(255))/255
            let blue = CGFloat(arc4random_uniform(255))/255
            let green = CGFloat(arc4random_uniform(255))/255
            let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            button.backgroundColor = color
            button.restorationIdentifier = "test \(index) button"
            if index % 2 == 0{
                // 將 button 插入到指定的 index 中
                self.stackView.insertArrangedSubview(button, at: index)
            }else{
                self.stackView.addArrangedSubview(button)
            }
        }
        for subView in self.stackView.arrangedSubviews{
            guard let subBtn = subView as? UIButton else { continue }
            NSLog("sub Button title :\(subBtn.titleLabel?.text) , restoration ID : \(subBtn.restorationIdentifier)")
        }
    }
}

