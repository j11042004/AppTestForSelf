//
//  ShowViewController.swift
//  HelloSwiftARKit
//
//  Created by Uran on 2018/4/9.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var showImg : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imgView.image = showImg
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
