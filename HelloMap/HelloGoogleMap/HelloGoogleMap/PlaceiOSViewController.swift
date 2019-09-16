//
//  PlaceiOSViewController.swift
//  HelloGoogleMap
//
//  Created by Uran on 2018/5/8.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceiOSViewController: UIViewController {
    let searbarHeight : CGFloat = 55
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searbarHeightConstraint: NSLayoutConstraint!
    var userMarker : GMSMarker!
    var location : Location!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searbarHeightConstraint.constant = 0
        location = Location.shardInstrance
        
        // 取得現在 user 的位置
        if let nowUser = location.requireNowUserLocation() {
            self.moveRegion(coordinate: nowUser.coordinate)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 重新簽定 Delegate
        location.delelgate = self
        // 取得現在 user 應該在的位置
        if let nowUser = location.requireNowUserLocation() {
            self.mapSetUserLocation(Location: nowUser.coordinate)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension PlaceiOSViewController : LocationDelegate{
    func locationDidSet(FirstLocation location: CLLocation) {
        print("set region")
        self.moveRegion(coordinate: location.coordinate)
    }
    func locationGotUser(With location: CLLocation) {
        self.mapSetUserLocation(Location: location.coordinate)
    }
    /// 移動到特定座標並放大該區域
    func moveRegion(coordinate : CLLocationCoordinate2D){
        let camera = GMSCameraPosition.camera(withLatitude:coordinate.latitude,
                                              longitude:coordinate.longitude,
                                              zoom:20)
        self.googleMapView.camera = camera
    }
    /// 設定使用者座標
    /// - Parameter location: 使用者移動後的座標
    func mapSetUserLocation(Location location : CLLocationCoordinate2D ){
        // 若 userMark is nil 就建立
        if self.userMarker == nil{
            self.userMarker = GMSMarker()
            self.userMarker.title = "User"
            self.userMarker.icon = GMSMarker.markerImage(with: .blue)
        }
        self.userMarker.map = self.googleMapView
        self.userMarker.position = location
    }
}
extension PlaceiOSViewController : UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
