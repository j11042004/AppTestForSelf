//
//  ViewController.swift
//  HelloLocalNotification
//
//  Created by Uran on 2018/4/10.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import UserNotifications

enum NoteSendType : String {
    case iOS10Local = "iOS 10 之後本地推播"
    case iOS10CalenderLocal = "iOS 10 之後 排程 本地推播"
    case iOS9Local = "iOS 9 之後本地推播"
}
class ViewController: UIViewController {
    private let sender = LocalNoteSender.shared
    let cellId = "Cell"
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    let noteSendTypes : [NoteSendType] = [.iOS10Local , .iOS10CalenderLocal , .iOS9Local]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewHeight.constant = tableview.contentSize.height
        tableview.isScrollEnabled = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = noteSendTypes[indexPath.row]
        switch type {
        case .iOS10Local:
            sender.sendiOS10Notification()
            break
        case .iOS9Local:
            sender.sendiOS9Notification()
            break
        default:
            sender.sendiOS10CalendarNotification()
            break
        }
    }
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteSendTypes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let noteSendType = noteSendTypes[indexPath.row]
        cell.textLabel?.text = noteSendType.rawValue
        return cell
    }
}
