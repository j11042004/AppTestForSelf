//
//  ViewController.swift
//  HelloFirebase
//
//  Created by Uran on 2019/4/19.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import Crashlytics
import Firebase
class PlayerView: UIView {
    var theClassName: String {
        return String(describing: type(of: self))
    }
}
class ViewController: UIViewController {
    enum FirebaseType : String {
        case crash = "崩潰測試"
        case analystic = "分析測試傳送"
    }
    @IBOutlet weak var tableView: UITableView!
    let cellID = "Cell"
    let gaTrackId = "UA-126739995-1"
    
    var propertiesName = ""
    var firebaseFuns = [FirebaseType]()
    let player = PlayerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        firebaseFuns.append(.crash)
        firebaseFuns.append(.analystic)
        
        self.view.addSubview(player)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidOrientation), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        self.deviceDidOrientation()
    }

    @objc func deviceDidOrientation(){
        var orientation = "直向"
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft , .landscapeRight:
            orientation = "橫向"
            self.propertiesName = "Landscape"
            break
        default:
            self.propertiesName = "Portrait"
            break
        }
//        Analytics.setUserProperty(self.propertiesName, forName: "Properties")
        let event = "\(self.player.theClassName)_\(orientation)"
        var parmeters = [String : Any]()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd hh:mm:ss"
        let dateStr = dateFormatter.string(from: date)
        parmeters["Time"] = dateStr
        Analytics.logEvent(event, parameters: parmeters)
        NSLog("分析要傳送的 Properties : \(self.propertiesName) time : \(date)")
    }
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let funcs = self.firebaseFuns[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        switch funcs {
        case .crash: // Crash 測試
            Crashlytics.sharedInstance().crash()
            break
        case .analystic:
//            Google 分析 ：點擊測試
            let events = "Player測試"
            var parameters = [String : Any]()
            parameters["Action測試"] = "Cell被點擊"
            parameters[AnalyticsParameterItemID] =  "id-\(Date())"
            parameters[AnalyticsParameterItemName] =  "\(Date())"
            parameters[AnalyticsParameterContentType] = "TableViewType"
            Analytics.logEvent(events, parameters: parameters)
            Analytics.logEvent(AnalyticsEventViewItem, parameters: parameters)
            break
        }
        cell?.setSelected(false, animated: true)
    }
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseFuns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = self.firebaseFuns[indexPath.row].rawValue
        return cell
    }
    
    
}
