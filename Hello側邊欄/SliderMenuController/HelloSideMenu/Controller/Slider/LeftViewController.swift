//
//  LeftViewController.swift
//  HelloSideMenu
//
//  Created by Uran on 2018/6/4.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    lazy var bundle = Bundle(for: type(of: self))
    private let cellID = "Cell"
    private let viewNames = ["main","yellow" , "blue" , "red"]
    private var viewControllers = [UIViewController]()
    var viewController : ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        // 加入 ViewController
        let mainVC = MainViewController(nibName: "MainViewController", bundle: bundle)
        let yellowVC = YellowViewController(nibName: "YellowViewController", bundle: bundle)
        let blueVC = BlueViewController(nibName: "BlueViewController", bundle: bundle)
        let redVC = RedViewController(nibName: "RedViewController", bundle: bundle)
        viewControllers.append(mainVC)
        viewControllers.append(yellowVC)
        viewControllers.append(blueVC)
        viewControllers.append(redVC)
        
        
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: bundle)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        self.viewController = vc
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension LeftViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let name = viewNames[indexPath.row]
        cell.textLabel?.text = name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.viewControllers[indexPath.row]
        self.slideMenuController()?.changeMainViewController(vc, close: true)
    }
}
