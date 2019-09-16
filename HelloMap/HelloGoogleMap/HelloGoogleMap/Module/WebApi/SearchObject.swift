//
//  SearchObject.swift
//  HelloGoogleMap
//
//  Created by Uran on 2018/5/3.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import CoreLocation
class SearchObject: NSObject {
    
    public static let shardInstance = SearchObject()
    public var nextPageToken : String?
    private let apiKey = Define.googleApiKey
    /// 當搜尋完成後要做的事
    public typealias SearchComplete = (_ places : [ResultPlace]? , _ errorStr: String?)  -> Void
    /// 解析完成後要做的事
    private typealias DecodeComplete = (_ places : [ResultPlace]? )  -> Void
    
    /// 尋找有關關鍵字的地點
    ///
    /// - Parameters:
    ///   - query: 搜尋的關鍵字
    ///   - location: 要搜尋的中心座標
    ///   - radious: 搜尋的範圍 ， 單位為 公尺
    ///   - nextToken: 下一頁的 pageToken
    ///   - completion: 完成後回傳的 Closure 裡面有處理好的 Place Array [ResultPlace]? 或 錯誤訊息 String?
    public func searchPlaces(With query : String ,
                      Location location : CLLocationCoordinate2D ,
                      Radious radious: Double ,
                      NextPage nextToken : String?,
                      completion : @escaping SearchComplete){
        let set : CharacterSet = CharacterSet.urlHostAllowed
        // 關鍵字做 url 編碼
        guard let queryEncoding = query.addingPercentEncoding(withAllowedCharacters: set) else{
            print("urlQuery is nil")
            let errStr = "Query Encoding is nil"
            completion(nil , errStr)
            return
        }
        // 搜尋附近的url
        var urlStr = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.latitude),\(location.longitude)&radius=\(radious)&keyword=\(queryEncoding)&language=zh-TW&key=\(apiKey)"
        
        if let next = nextToken {
            urlStr = "\(urlStr)&pagetoken=\(next)"
        }
        
        guard let url = URL(string: urlStr) else {
            print("url is nil")
            let errStr = "url is nil"
            completion(nil , errStr)
            return
        }
        let request = URLRequest(url: url)
        let configure = URLSessionConfiguration.default
        let session = URLSession(configuration: configure)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print("search query error : \(error.localizedDescription)")
                completion(nil , error.localizedDescription)
                return
            }
            guard let response = response as? HTTPURLResponse else{
                print("HTTPURLResponse is nil")
                let errStr = "HTTPURLResponse is nil"
                completion(nil , errStr)
                return
            }
            if response.statusCode != 200 {
                let errStr = "the StaeCode :\(response.statusCode) is error"
                completion(nil , errStr)
                return
            }
            guard let data = data else{
                print("request data is nil")
                let errStr = "request data is nil"
                completion(nil , errStr)
                return
            }
            
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            guard let jsonDict = jsonObject as? [String : Any] else{
                let errStr = "jsonObject Dict is nil"
                completion(nil , errStr)
                print("jsonObject Dict is nil ")
                return
            }
            self.decodeJsonToPlacesInfo(With: jsonDict, completion: { (places) in
                completion(places , nil)
                if let places = places{
                    for place in places {
                        print("name : \(place.name)")
                    }
                }
            })
        }
        dataTask.resume()
    }
    
    /// 解析 jsonDict 資料
    ///
    /// - Parameters:
    ///   - json: jsonDict 為 [String : Any]
    ///   - completion: 回傳的 Closure 有 places [ResultPlace]? ， nextToken : String?
    private func decodeJsonToPlacesInfo(With json : [String : Any], completion : DecodeComplete){
        // 取得 nextPageToken
        self.nextPageToken = json["next_page_token"] as? String
        
        // 分析 json 將他們丟到 place Object 中
        guard let results = json["results"] as? [[String : Any]] else {
            print("results is nil")
            completion(nil )
            return
        }
        var places : [ResultPlace] = [ResultPlace]()
        for result in results {
            let place = ResultPlace()
            place.setPlaceInfo(With: result)
            places.append(place)
        }
        
        completion(places)
    }
    
    
}
