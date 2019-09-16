//
//  Location.swift
//  HelloGoogleMap
//
//  Created by Uran on 2018/5/8.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import CoreLocation
@objc protocol LocationDelegate {
    /// 第一次取得的位置
    /// - Parameter location: 第一次取得的位置
    @objc func locationDidSet(FirstLocation location : CLLocation)
    /// 取到 user Location 時呼叫
    ///
    /// - Parameter location: user 現在的 location
    func locationGotUser(With location : CLLocation)
}

class Location: NSObject {
    public static let shardInstrance = Location.init()
    var delelgate : LocationDelegate?
    private var locationManager : CLLocationManager?
    private var startLocation : CLLocation!
    private var lastLocation : CLLocation!
    override init() {
        super.init()
        self.requestLocationAllowed()
        if self.startLocation == nil{
            print("is nil")
        }else{
            print("not nil")
        }
    }
    /// location manager 的設定 與 詢問權限要求
    private func requestLocationAllowed(){
        // locationManager 設定
        self.locationManager = CLLocationManager()
        self.locationManager?.requestWhenInUseAuthorization()
        // 設定位置精準度
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        // location 的總類：行人模式
        locationManager?.activityType = CLActivityType.fitness
        self.locationManager?.delegate = self
        // 詢問位置授權要求
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    public func requireNowUserLocation() -> CLLocation?{
        if self.lastLocation == nil{
            return nil
        }
        return self.lastLocation
    }
}

extension Location : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let nowLocation = locations.last else {
            return
        }
        
        // 在 第一次執行時 說小範圍到現在所在位址
        // 因為是 nil 才設定 現在位置為起始位置
        if startLocation == nil {
            self.startLocation = nowLocation
            self.delelgate?.locationDidSet(FirstLocation: nowLocation)
        }
        self.lastLocation = nowLocation
        // 重複設定使用者座標
        self.delelgate?.locationGotUser(With: self.lastLocation)
        
    }
    
    
    // 當 location 權限改變時會被觸發
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:    // 還未決定是否允許
            self.locationManager?.requestWhenInUseAuthorization()
            break
        case .denied:   // 拒絕
            self.showSetAlert()
            break
        case .restricted:   // 有所限制
            self.showSetAlert()
            break
        default:
            // 若同意，開始回報現在位置
            self.locationManager?.startUpdatingLocation()
            break
        }
    }
    
    
    /// 顯示跳轉到 設定的 Alert
    private func showSetAlert(){
        let alert = UIAlertController(title: nil, message: "請問是否要開啟設定，前往權限要求畫面，將權限改成允許使用？", preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel)
        let ok = UIAlertAction.init(title: "前往", style: .default) { (action) in
            if let setUrl = URL(string: UIApplicationOpenSettingsURLString){
                UIApplication.shared.open(setUrl, options: [String : Any](), completionHandler: nil)
            }
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
