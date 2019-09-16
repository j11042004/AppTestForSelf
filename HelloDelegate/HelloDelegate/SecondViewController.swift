//
//  SecondViewController.swift
//  HelloDelegate
//
//  Created by Uran on 2018/2/7.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    let manager : DelegateManager = DelegateManager.sharedInstance()
    @IBOutlet weak var callBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callBtn.backgroundColor = UIColor.white
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func callBtnAction(_ sender: UIButton) {
        manager.callSend()
        manager.delegate?.sendValue(str: "Good", color: .green)
    }
    func sendValue(str: String, color: UIColor) {
        NSLog("Get Str : \(str)")
        callBtn.backgroundColor = color
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSLog("sec View did Disappear")
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
