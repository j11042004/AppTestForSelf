//
//  NextViewController.swift
//  ControllerPresentAnimation
//
//  Created by Uran on 2018/12/6.
//  Copyright © 2018 Uran. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    @IBOutlet weak var dissBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let rgba = self.view.backgroundColor?.rgba(){
            let red = 1-rgba.red
            let green = 1-rgba.green
            let blue = 1-rgba.blue
            let color = UIColor(red: red, green: green, blue: blue, alpha: rgba.alpha)
            self.dissBtn.setTitleColor(color, for: .normal)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    @IBAction func dissSelf(_ sender: UIButton) {
        if let _ = self.navigationController{
            navigationController?.popViewController(animated: true)
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
