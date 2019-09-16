//
//  SideTableViewController.swift
//  SliderMenu
//
//  Created by Uran on 2019/7/29.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit

class SideTableViewController: UITableViewController {
    let colors = [UIColor.red , UIColor.orange , UIColor.blue]
    let colorStrs = ["Red" , "Orange" , "Blue"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return colors.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.colorStrs[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let color = self.colors[indexPath.row]
        print("select color : \(color)")
    }
}
