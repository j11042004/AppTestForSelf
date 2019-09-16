//
//  BeaconTableViewController.swift
//  HelloBeacon
//
//  Created by Uran on 2018/6/15.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation
class BeaconTableViewController: UITableViewController {
    let cellID = "Cell"
    let loationManager = CLLocationManager()
    let beaconUUID : UUID = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
    lazy var beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: "beacon1")
    var infoArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loationManager.delegate = self
        // locationManager 開始要求 准許總是取得位置 權限
        self.loationManager.requestAlwaysAuthorization()
        
        // 當使用者進入範圍或離開時會進行通知
        self.beaconRegion.notifyOnEntry = true
        self.beaconRegion.notifyOnExit = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func scanDevice(_ sender: UISwitch) {
        if sender.isOn {
            // location manager 開始掃描指定的範圍
            self.loationManager.startMonitoring(for: self.beaconRegion)
            return
        }
        loationManager.stopMonitoring(for: self.beaconRegion)
        loationManager.stopRangingBeacons(in: self.beaconRegion)
    }
}

extension BeaconTableViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.infoArray.count
    }
    
    
     override func tableView(_ tableView: UITableView,
                             cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let info = self.infoArray[indexPath.row]
        cell.textLabel?.text = info
        cell.textLabel?.sizeToFit()
        cell.textLabel?.numberOfLines = 0
        return cell
     }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}


extension BeaconTableViewController : CLLocationManagerDelegate{
    // 當 location Manager 開始監測指定範圍時
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        // 檢查裝置是否在指定範圍內
        self.loationManager.requestState(for: region)
    }
    
    // 查看回報的結果是否在 範圍內
    // 在 背景執行
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        guard let conRegion = region as? CLBeaconRegion else{
            NSLog("DetermineState Region is not BeaconRegion")
            return
        }
        var localNotificationMessage : String!
        switch state {
        case CLRegionState.inside:
            
            localNotificationMessage = "\(region.identifier)：警戒中... "
            self.loationManager.startRangingBeacons(in: conRegion)
            break
        case CLRegionState.outside:
            localNotificationMessage = "\(region.identifier):撒呦那拉～有緣再相會～"
            self.loationManager.stopRangingBeacons(in: conRegion)
            break
        case CLRegionState.unknown:
            localNotificationMessage = "\(region.identifier):何方妖孽，從實招來！！！！"
            self.loationManager.stopRangingBeacons(in: conRegion)
            break
        }
        self.showLocationNotification(With: localNotificationMessage)
    }
    
    //當開始測量 Beacon 距離時就一直被呼叫
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        self.infoArray.removeAll()
        for beacon in beacons {
            var proimityString : String = ""
            //  距離 iBeacon 的範圍大小
            switch beacon.proximity {
            case .immediate :
                proimityString = "Immediate"
                break
            case .far:
                proimityString = "Far"
                break
            case .near :
                proimityString = "Near"
                break
            case .unknown:
                proimityString = "Unknown"
                break
            }
            // 精準度
            let accurateness = String(format: "%.2f", beacon.accuracy)
            // rssi 距離
            let rssiRotaio = self.calculateRange(WithRssi: beacon.rssi)
            let beaconID = Int(truncating: beacon.minor)
            let placeID = Int(truncating: beacon.major)
            let info = "\(region.identifier)\n距離遠近:\(proimityString)\n距離:\(rssiRotaio)\n精確度:\(accurateness)\n所在地ID:\(placeID)\nBeacon 編號:\(beaconID)"
            self.infoArray.append(info)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func calculateRange(WithRssi rssi : Int)->Double{
        let iRssi = abs(Int32(rssi))
        let power = (Double(iRssi)-59)/(10*2.0)
        
        return pow(10, power);
    }
    
    
    /// 顯示本地通知
    func showLocationNotification(With message :String){
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = "偵測到小寶貝"
            content.subtitle = "Come on baby"
            content.body = message
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                print("成功建立通知...")
            })
        }else{
            let localNotify = UILocalNotification()
            localNotify.fireDate = Date(timeIntervalSinceReferenceDate: 0.5)
            localNotify.alertBody = message
            UIApplication.shared.scheduleLocalNotification(localNotify)
        }
        
    }
    
    
}
