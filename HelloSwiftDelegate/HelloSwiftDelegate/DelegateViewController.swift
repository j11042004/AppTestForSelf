//
//  DelegateViewController.swift
//  HelloSwiftDelegate
//
//  Created by Uran on 2017/12/15.
//  Copyright © 2017年 Uran. All rights reserved.
//

import UIKit
protocol sendValueDelegate {
    func sendValue(string:String?)
}
class DelegateViewController: UIViewController {

    @IBOutlet weak var VCLabelShowTextField: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    var delegate:sendValueDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.delegate?.sendValue(string: VCLabelShowTextField.text)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
