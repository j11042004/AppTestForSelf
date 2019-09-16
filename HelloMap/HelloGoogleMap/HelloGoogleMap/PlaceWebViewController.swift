//
//  ViewController.swift
//  HelloGoogleMap
//
//  Created by Uran on 2018/5/2.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceWebViewController: UIViewController {

    @IBOutlet weak var googleMapview: GMSMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet var accessToolBar: UIToolbar!
    @IBOutlet weak var radiousLabel: UILabel!
    
    var searchItem: UIBarButtonItem!
    var closeItem: UIBarButtonItem!
    var userMark : GMSMarker!
    var waitingView : WaitingView!
    
    var places = [ResultPlace]()
    var markers = [GMSMarker]()
    
    let location : Location = Location.shardInstrance
    var userLocation : CLLocation!
    
    var isSearching = false
    
    override func loadView() {
        super.loadView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 把 google map view 放到最後
        view.sendSubview(toBack: self.googleMapview)
        
        // 去尋訪每個 tabbar 上的 VC，最後再回到第一個 item 上的 VC
//        if let tabItemCount = self.tabBarController?.tabBar.items?.count{
//            let reviewCount = 0..<tabItemCount
//            for index in reviewCount{
//                self.tabBarController?.selectedIndex = index
//            }
//            self.tabBarController?.selectedIndex = 0
//        }
        
        // 新增一個等待的 View
        self.waitingView = WaitingView()
        // 設定 
        waitingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(waitingView)
        // 設定 Constraint
        waitingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        waitingView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        waitingView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        waitingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        // 新增 item
        self.searchItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(startSearch(_:)))
        self.closeItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeSearch(_:)))
        // 隱藏 Searchbar
        self.navigationItem.rightBarButtonItems = [searchItem]
        self.isSearching = false
        self.searchHeightConstraint.constant = 0
        self.searchBar.delegate = self
        // 隱藏 waiting View
        self.waitingView.isHidden = true;
        
        // 設定 radious Slider 為最大
        self.radiusSlider.value = self.radiusSlider.maximumValue
        // 執行當 Value change 時的 Function
        self.radiusValueChanged(self.radiusSlider)
        // 設定 searchbar 上的新 toolbar 
        self.searchBar.inputAccessoryView = accessToolBar
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 重新簽定 Delegate
        location.delelgate = self
        // 取得現在 user 應該在的位置
        if let nowUser = location.requireNowUserLocation() {
            self.mapSetUserLocation(Location: nowUser.coordinate)
        }
        // 設定地圖種類與 Delegate
        self.googleMapview.mapType = .normal
        self.googleMapview.delegate = self

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @objc func startSearch(_ sender: UIBarButtonItem) {
        self.isSearching = true
        self.navigationItem.rightBarButtonItems = [self.closeItem]
        self.searchHeightConstraint.constant = 60
    }
    @objc func closeSearch(_ sender: UIBarButtonItem){
        self.isSearching = false
        self.navigationItem.rightBarButtonItems = [searchItem]
        self.searchHeightConstraint.constant = 0
    }
    
    @IBAction func radiusValueChanged(_ sender: UISlider) {
        self.radiousLabel.text = "\(self.radiusSlider.value)"
    }
    
    @IBAction func inputRadius(_ sender: UIButton) {
        let alert = UIAlertController(title: "更換範圍", message: "距離最遠為 1000 公尺，最近為 10 公尺", preferredStyle: .alert)
        alert.addTextField { (textField) in
            // 設定出現的鍵盤種類
            textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        }
        // 按下確定會更改距離
        let sure = UIAlertAction(title: "確定", style: .cancel) { (action) in
            DispatchQueue.main.async {
                guard let text = alert.textFields?.first?.text ,
                    let value = Float(text) ,
                    value >= 10
                else{
                    self.radiusSlider.value = 10
                    self.radiousLabel.text = "\(10)"
                    return
                }
                if value > 1000{
                    self.radiusSlider.value = 1000
                    self.radiousLabel.text = "\(1000)"
                    return
                }
                self.radiusSlider.value = value
                self.radiousLabel.text = "\(value)"
            }
        }

        alert.addAction(sure)
        self.present(alert, animated: true, completion: nil)
    }
    func showSureAlert(Title title: String? , Message message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let sure = UIAlertAction(title: "確定", style: .cancel)
        alert.addAction(sure)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
}

//MARK: - Location Delegate
extension PlaceWebViewController: LocationDelegate{
    func locationGotUser(With location: CLLocation) {
        self.userLocation = location
        self.mapSetUserLocation(Location: self.userLocation.coordinate)
    }
    func locationDidSet(FirstLocation location: CLLocation) {
        self.moveRegion(coordinate: location.coordinate)
    }
    /// 移動到特定座標並放大該區域
    func moveRegion(coordinate : CLLocationCoordinate2D){
        let camera = GMSCameraPosition.camera(withLatitude:coordinate.latitude,
                                              longitude:coordinate.longitude,
                                              zoom:20)
        self.googleMapview.camera = camera
    }
    
}
// MARK: - Searchbar Delegate
extension PlaceWebViewController : UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    /// MARK: 搜尋按鈕按下時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        guard let query = searchBar.text , searchBar.text?.count != 0 else {
            print("query is nil or 0 word")
            return
        }
        // 開始 等待畫面
        self.waitingView.isHidden = false
        // 清除 mapView 上的 maps
        self.googleMapview.clear()
        // 清除 places 與 marksers 中的 內容
        self.places.removeAll()
        self.markers.removeAll()
        // 加回 user markers
        self.mapSetUserLocation(Location: self.userLocation.coordinate)
        // 清除 nextPageToken
        SearchObject.shardInstance.nextPageToken = nil
        // 距離是 slider 上的 數值
        let radious = Double(self.radiusSlider.value)
        // 開始搜尋
        self.insertSearchMarks(query, Radious: radious)
    }
    
    /// 新增搜尋到的Markers
    ///
    /// - Parameter query: 搜尋的文字
    /// - Parameter radious: 搜尋的距離
    func insertSearchMarks(_ query : String , Radious radious : Double){
        let search = SearchObject.shardInstance
        // 搜尋地點
        search.searchPlaces(With: query,
                            Location: self.userMark.position,
                            Radious: radious,
                            NextPage: search.nextPageToken,
                            completion: { [weak self](places, error) in
            if let error = error{
                print("搜尋 error 訊息 : \(error)")
                return
            }
            guard let places = places else{
                print("搜尋到的 places is nil")
                return
            }
            DispatchQueue.main.async {
                for place in places{
                    let marker = GMSMarker()
                    marker.map = self?.googleMapview
                    if let location = place.location{
                        marker.position = location
                    }
                    marker.title = place.name
                    marker.snippet = place.address
                    // 加到 自己的 places 與 markers 中
                    self?.places.append(place)
                    self?.markers.append(marker)
                }
                self?.waitingView.isHidden = true
                if places.count == 0{
                    self?.showSureAlert(Title: "搜尋錯誤", Message: "未收尋到結果，請重新換個關鍵字後，再次搜尋！")
                }
            }
            // 判斷是否還有 next Page Token
            guard let _ = search.nextPageToken else{
                print("next page token is nil")
                return
            }
            // 若有再次執行新增。marks 的 Function
            self?.insertSearchMarks(query, Radious: radious)
        })
    }
    
}


//MARK: - Google Map Delegate
extension PlaceWebViewController:GMSMapViewDelegate{
    // 點擊大頭針時會做的一些事
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let isMarker = mapView.selectedMarker == marker
        mapView.selectedMarker = isMarker ? nil : marker
        return true;
    }
    // 點擊訊息框時會執行的動作
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if marker == self.userMark{
            print("User Mark")
            return
        }
        if !self.markers.contains(marker){
            return
        }
        guard let index = self.markers.index(of: marker) else {
            return
        }
        let place = self.places[index]
        print(place.name)
        print(place.telphone)
    }
    
    
    // 點擊到相關位置會出現資訊
    func mapView(_ mapView:GMSMapView, didTapPOIWithPlaceID placeID:String,
                 name:String, location:CLLocationCoordinate2D) {
        let placeName = name.replacingOccurrences(of: "\n", with: " ")
        NSLog("按到的地點 : \(placeName)")
        NSLog("按到的地點 placeID : \(placeID)")
        NSLog("按到的地點座標 : \(location)")
    }
}


//MARK: - Google Map Normal Function
extension PlaceWebViewController {
    /// 設定全景 View 某個座標的街景
    /// - Parameters:
    ///   - panoView: 全景 View
    ///   - coordinate: 座標
    func markerSetPanormaView(_ panoView : GMSPanoramaView , WithCoordinate coordinate : CLLocationCoordinate2D){
         GMSPanoramaService().requestPanoramaNearCoordinate(coordinate) { (panorama, error) in
            if let error = error{
                print("request 街景 Error : \(error.localizedDescription)")
                return
            }
            // 設定 全景 View 的街景
            panoView.panorama = panorama
        }
    }
    
    
    /// 新增一個大頭針到 Google map 上
    ///
    /// - Parameters:
    ///   - addMap: 要加到的 google map
    ///   - location: 大頭針座標
    ///   - title: 大頭針名字
    ///   - snippet: 大頭針介紹
    ///   - icon: 大頭針圖案，若要更改顏色就用 GMSMarker.markerImage(with: .color)
    func googleMapAddNewMarker(AddMap addMap : GMSMapView ,
                               Location location : CLLocationCoordinate2D ,
                               Title title : String? ,
                               Snippet snippet : String? ,
                               MarkerIcon icon: UIImage?){
        let maker = GMSMarker()
        maker.position = location
        maker.map = addMap
        maker.title = title
        maker.snippet = snippet
        maker.icon = icon
    }
    
    
    /// 設定使用者座標
    /// - Parameter location: 使用者移動後的座標
    func mapSetUserLocation(Location location : CLLocationCoordinate2D ){
        // 若 userMark is nil 就建立
        if self.userMark == nil{
            self.userMark = GMSMarker()
            self.userMark.title = "User"
            self.userMark.icon = GMSMarker.markerImage(with: .blue)
        }
        self.userMark.map = self.googleMapview
        self.userMark.position = location
        
    }
}
