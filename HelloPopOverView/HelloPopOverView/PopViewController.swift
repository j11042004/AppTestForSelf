//
//  PopViewController.swift
//  HelloPopOverView
//
//  Created by Uran on 2019/9/11.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit

class PopViewController: UIViewController {
    public var color : UIColor = .green
    @IBOutlet weak var centerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = color
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapClose)))
        
        self.view.alpha = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.1) {
            [weak self] in
            self?.view.alpha = 1
        }
    }
    @objc func tapClose(){
        UIView.animate(withDuration: 0.3, animations: {
            [weak self] in
            self?.view.alpha = 0
        }) { [weak self] (_) in
            self?.dismiss(animated: false, completion: nil)
        }
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
