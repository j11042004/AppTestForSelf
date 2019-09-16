//
//  ViewController.swift
//  HelloPopOverView
//
//  Created by Uran on 2019/9/10.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func popOverVC(_ sender: UIButton) {
        guard let popoverVC = self.storyboard?.instantiateViewController(withIdentifier: "PopViewController") as? PopViewController else {return}
        popoverVC.modalPresentationStyle = .popover
        popoverVC.popoverPresentationController?.delegate = self
        popoverVC.popoverPresentationController?.sourceView = sender
        popoverVC.preferredContentSize = CGSize(width: 250, height: self.view.bounds.height*0.8)
        // 設定箭頭出現在 PopOverVC 所在的方向
        popoverVC.popoverPresentationController?.permittedArrowDirections = .up
        // 控制 PopOverVC 箭頭所指向的位置
        popoverVC.popoverPresentationController?.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.maxY, width: 0, height: 0)
        self.present(popoverVC, animated: true, completion: nil)
    }
    @IBAction func barItemPopOver(_ sender: UIBarButtonItem) {
        guard let popoverVC = self.storyboard?.instantiateViewController(withIdentifier: "PopViewController") as? PopViewController else {return}
        popoverVC.modalPresentationStyle = .popover
        popoverVC.popoverPresentationController?.delegate = self
        popoverVC.popoverPresentationController?.barButtonItem = sender
        popoverVC.preferredContentSize = CGSize(width: 250, height: self.view.bounds.height*0.8)
        // 設定箭頭出現在 PopOverVC 所在的方向
        popoverVC.popoverPresentationController?.permittedArrowDirections = .up
        // 控制 PopOverVC 箭頭所指向的位置
//        popoverVC.popoverPresentationController?.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.maxY, width: 0, height: 0)
        self.present(popoverVC, animated: true, completion: nil)
    }
    
    @IBAction func presentVCAsPop(_ sender: Any) {
        guard let popoverVC = self.storyboard?.instantiateViewController(withIdentifier: "PopViewController") as? PopViewController else {return}
        popoverVC.color = .clear
        popoverVC.modalPresentationStyle = .overCurrentContext
        present(popoverVC, animated: false, completion: nil)
    }
    
}


extension ViewController : UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
