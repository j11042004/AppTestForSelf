//
//  ViewController.swift
//  HelloTableViewRefresh
//
//  Created by Uran on 2019/4/17.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var counts : [Int] = [Int]()
    
    let footerViewId = "ReloadFooterView"
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: footerViewId, bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: footerViewId)
        for index in 0..<20{
            counts.append(index)
        }
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.section)-\(counts[indexPath.row])"
        return cell
    }

    //MARK:- Footer View 無法達到預期效果
/*
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerViewId) as! ReloadFooterView
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 41
    }
 */
}

