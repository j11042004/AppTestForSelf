//
//  SecViewController.swift
//  HelloClosure
//
//  Created by Uran on 2018/2/7.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class SecViewController: UIViewController {
    let send : SendManager = SendManager.sharedInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        send.getCompletion(str: "Hello sec", color: .black)
        self.dismiss(animated:true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
