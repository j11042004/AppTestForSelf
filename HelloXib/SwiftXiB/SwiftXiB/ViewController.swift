//
//  ViewController.swift
//  SwiftXiB
//
//  Created by Uran on 2018/2/12.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let cusCellNib = UINib(nibName: "CusTableViewCell", bundle: nil)
        self.tableView.register(cusCellNib, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
    }

    @IBAction func showBtnAction(_ sender: UIButton) {
        let xibVC = XibViewController(nibName: "XibViewController", bundle: nil)
        self.present(xibVC, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CusTableViewCell
        cell.firstLabel.text = "First : \(indexPath.row)"
        cell.secondLabel.text = "Second : \(indexPath.row)"
        return cell
    }
}

