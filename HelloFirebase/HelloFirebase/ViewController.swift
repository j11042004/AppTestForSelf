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

enum Result<T> {
    case success(T)
    case fail(Error)
}
typealias Completion<T> = (Result<T>)->Void

class ViewController: UIViewController {
    enum FirebaseType : String {
        case crash = "崩潰測試"
        case analystic = "分析測試傳送"
    }
    @IBOutlet weak var tableView: UITableView!
    let cellID = "Cell"
    let gaTrackId = "UA-126739995-1"
    
    var propertiesName = ""
    // 要執行的 Firebase 功能
    var actions = [FirebaseType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        actions.append(.crash)
        actions.append(.analystic)
        

        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidOrientation), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        self.deviceDidOrientation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let infoDict = Bundle.main.infoDictionary {
            for (key , value) in infoDict{
                NSLog("key : \(key) , value : \(value)")
            }
        }
        
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
        // 傳送轉向資訊到 Firebase 分析
//        Analytics.setUserProperty(self.propertiesName, forName: "Properties")
        let display = Bundle.main.object(forInfoDictionaryKey: "CFBundleName")
        let event = "\(display == nil ? "App" : "\(display!)")_\(orientation)"
        var parameters = [String : Any]()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd hh:mm:ss"
        let dateStr = dateFormatter.string(from: date)
        parameters["Time"] = dateStr
        parameters[AnalyticsParameterItemID] =  "id-\(Date())"
        parameters[AnalyticsParameterItemName] =  "\(Date())"
        parameters[AnalyticsParameterContentType] = "App 轉向"
        Analytics.logEvent(event, parameters: parameters)
    }
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = self.actions[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        switch action {
        case .crash: // Crash 測試
            Crashlytics.sharedInstance().crash()
            break
        case .analystic:
//            Google 分析 ：點擊測試
            let events = "Firebase分析測試"
            var parameters = [String : Any]()
            parameters["Action"] = "Cell被點擊"
            parameters[AnalyticsParameterItemID] =  "id-\(Date())"
            parameters[AnalyticsParameterItemName] =  "\(Date())"
            parameters[AnalyticsParameterContentType] = "TableViewType"
            Analytics.logEvent(events, parameters: parameters)
            break
        }
        cell?.setSelected(false, animated: true)
    }
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = self.actions[indexPath.row].rawValue
        return cell
    }
    
    
}
