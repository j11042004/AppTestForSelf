//
//  ResultPlace.swift
//  HelloGoogleMap
//
//  Created by Uran on 2018/5/4.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import CoreLocation
class ResultPlace: NSObject {
    private let apiKey = Define.googleApiKey
    
    public var name : String?
    public var address : String?
    public var location : CLLocationCoordinate2D?
    public var icon : UIImage?
    public var websiteUrl : URL?
    public var placeID : String?
    public var rating : Double?
    public var stickerPhoto : UIImage?
    public var telphone : String?
    public var photos : [UIImage]?
    public var openDays : [String]?
    convenience override init() {
        self.init(With: [String : Any]())
    }
    public init(With result:[String : Any]) {
        super.init()
        if result.count == 0 {
            return
        }
        self.setPlaceInfo(With: result)
    }
    /// 設定 place 的資訊
    ///
    /// - Parameter infoDict: 從 webPlace 中取得的 Json
    public func setPlaceInfo(With infoDict : [String : Any]){
        // 設定 地點座標
        if let geometry = infoDict["geometry"] as? [String : Any]{
            self.location = self.setPlaceLocation(With: geometry)
        }
        // place 名字
        if let name = infoDict["name"] as? String{
            self.name = name
        }
        // place ID
        if let placeID = infoDict["place_id"] as? String {
            self.placeID = placeID
        }
        // place 地址
/*
    google nearby search 與 text Searh 的地址 key
    nearby 是 "vicinity"
    text 是 "formatted_address"
*/
        if let address = infoDict["vicinity"] as? String{
            self.address = address
        }
        // 取得 icon image
        if let iconUrlStr = infoDict["icon"] as? String{
            self.icon = self.changeUrlToImage(With: iconUrlStr)
        }
        // 取得星等評價
        if let rating = infoDict["rating"] as? Double {
            self.rating = rating
        }
        // 取得圖片資訊
        guard let photoInfos = infoDict["photos"] as? [[String:Any]] else {
            print("photoInfos is nil")
            return
        }
        guard let photoInfo = photoInfos.first else {
            print("photoInfos[0] is nil")
            return
        }
        // 取得圖片來源字串
        guard let photoRef = photoInfo["photo_reference"] as? String else {
            print("photoRef is nil")
            return
        }
        // 取得代表照片
        self.getPlaceImage(With: photoRef) { (image) in
            self.stickerPhoto = image
        }
        // 取得地點詳細資訊
        self.getPlaceDetailInfos()
    }
    
    
    
    
    /// 取的 place 上的 座標
    ///
    /// - Parameter geometry: 包含座標的 Dictionary
    /// - Returns: CLLocationCoordinate2D的 座標，可能為 nil
    private func setPlaceLocation(
        With geometry : [String : Any]) -> CLLocationCoordinate2D?{
        // 取得 place 座標
        if let locationDict = geometry["location"] as? [String : Double] {
            let lat = locationDict["lat"]!
            let lng = locationDict["lng"]!
            let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            return location
        }else{
            return nil
        }
    }
    
    
    
    /// 從 Google Place Photo reference 中取得圖片
    ///
    /// - Parameter reference: 圖片來源的 id
    /// - Returns: UIImge?
    open func getPlaceImage(With reference : String , complete : @escaping (_ image : UIImage? )  -> Void){
        // 取得圖片的網址
        let imageURLStr = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=\(Define.googleApiKey)"
        guard let photoUrl = URL(string: imageURLStr) else{
            print("photoUrl is nil")
            return 
        }
        let request = URLRequest(url: photoUrl)
        let configure = URLSessionConfiguration.default
        let session = URLSession(configuration: configure)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error{
                NSLog("photo Error : \(error.localizedDescription)")
                complete(nil)
                return
            }
            guard let data = data else{
                NSLog("photo data is nil")
                complete(nil)
                return
            }
            let image = UIImage(data: data)
            complete(image)
        }
        dataTask.resume()
    }
    /// 將 urlString 轉成 UIImage
    open func changeUrlToImage(With urlStr :String) -> UIImage?{
        guard let url = URL(string: urlStr) else {
            print("url img String is nil")
            return nil
        }
        do{
            let data = try Data(contentsOf: url)
            let img = UIImage(data: data)
            return img
        }catch{
            print("url img data is nil")
            return nil
        }
    }
    
    
    
}
