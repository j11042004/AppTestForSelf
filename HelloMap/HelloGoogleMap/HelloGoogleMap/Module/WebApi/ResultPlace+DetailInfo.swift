//
//  ResultPlace+DetailInfo.swift
//  HelloGoogleMap
//
//  Created by Uran on 2018/5/7.
//  Copyright © 2018年 Uran. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
extension ResultPlace {

    /// 取得地點更詳細的資訊
    public func getPlaceDetailInfos(){
        let apiKey = Define.googleApiKey
        guard let placeID = self.placeID else {
            print("place id is nil")
            return
        }
        // 取得詳細的地點資訊
        let detailUrlString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=\(apiKey)"
        guard let url = URL(string: detailUrlString) else{
            print("Detail Url is nil")
            return
        }
        // 進行 http 要求
        let request = URLRequest(url: url)
        let configure = URLSessionConfiguration.default
        let session = URLSession(configuration: configure)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error{
                NSLog("Detail request Error : \(error.localizedDescription)")
                return
            }
            // 判斷 response 是否存在以及 statusCode 是否為 200
            guard let response = response as? HTTPURLResponse ,
                  response.statusCode == 200
            else{
                print("Detail response is nil or Status Code not 200")
                return
            }
            
            guard let data = data else{
                NSLog("Detail Data is nil")
                return
            }
            do{
                // 取得 地點詳細的 data json
                guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] else{
                    print("Detail jsonDict is nil")
                    return
                }
                // 解析 Detail Json
                self.decodeDetailJson(jsonDict)
            }catch{
                NSLog("Detail Change to Json Error : \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
    
    /// 解析 Detail Json
    ///
    /// - Parameter detailJson: 詳細資訊的 json
    func decodeDetailJson(_ detailJson : [String : Any]){
        let DetailResultKey = "result"
        // 分析 detailJson
        guard let result = detailJson[DetailResultKey] as? [String : Any] else {
            print("detailJson is nil")
            return
        }
        if let iconUrlStr = result["icon"] as? String {
            self.icon = self.changeUrlToImage(With: iconUrlStr)
        }
        // 地址名
        if let name = result["name"] as? String {
            self.name = name
            print("店名：\(name)")
        }
        // 官網
        if let websiteUrlStr = result["website"] as? String {
            self.websiteUrl = URL(string: websiteUrlStr)
        }
        // google
        if let placeid = result["place_id"] as? String {
            self.placeID = placeid
        }
        // 地址
        if let address = result["formatted_address"] as? String {
            self.address = address
        }
        // 評價星等
        if let rating = result["rating"] as? Double {
            self.rating = rating
        }
        // 電話號碼
        if let telphone = result["formatted_phone_number"] as? String{
            self.telphone = telphone
            print("電話：\(telphone)")
        }
        // 營業時間
        if let openHours = result["opening_hours"] as? [String : Any] {
            if let openDays = openHours["weekday_text"] as? [String]{
                self.openDays = openDays
            }
        }
        // 取得詳細圖片的資訊
        guard let photos = result["photos"] as? [[String : Any]] else{
            print("photos is nil")
            return
        }
        self.photos = [UIImage]()
        // 取得 所有照片的資訊
        for info in photos{
            var photo = Photo()
            if let ref = info["photo_reference"] as? String{
                photo.reference = ref
            }
            if let height = info["height"] as? Double{
                photo.height = height
            }
            if let width = info["width"] as? Double{
                photo.width = width
            }
            
            // 根據 reference 取得圖片
            self.getPlaceImage(With: photo.reference) { (image) in
                if let image = image {
                    self.photos?.append(image)
                }
            }
           
        }
    }
    
    struct Photo {
        var reference : String!
        var height : Double!
        var width : Double!
    }
}
