//
//  ServiceApi.swift
//  SongDecoder
//
//  Created by Uran on 2018/11/19.
//  Copyright © 2018 Uran. All rights reserved.
//

import UIKit

typealias UpdateApiCompletion = (_ success : Bool , _ songs : [Song]? , _ error : Error? ) -> Void
protocol ServiceApiProtocol {
    /** 下載並取的 Api 的資訊 */
    func updateApiInfo(urlStr : String,  completion : @escaping UpdateApiCompletion)
}
class SongServiceApi: ServiceApiProtocol {
    func updateApiInfo(urlStr : String, completion: @escaping UpdateApiCompletion) {
        guard let url = URL(string: urlStr) else {
            NSLog("這個String 不是一個網址")
            let error : Error = NSError(domain: "這個String 不是一個網址", code: 404, userInfo: nil) as Error
            completion(false , nil , error)
            return
        }
        let request = URLRequest(url: url)
        let configure = URLSessionConfiguration.default
        let session = URLSession(configuration: configure)
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil{
                completion(false , nil , error)
                return
            }
            if let response = response as? HTTPURLResponse{
                NSLog("Api Get Response Code : \(response.statusCode)")
            }
            guard let data = data else{
                NSLog("Api 取得的是空資料")
                let error = NSError(domain: "Api 取得的是空資料", code: 404, userInfo: nil) as Error
                completion(false , nil  , error)
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601
            guard let results = try? decoder.decode(SongResults.self, from: data) else{
                NSLog("Api Json 解析失敗")
                let error = NSError(domain: "Api Json 解析失敗", code: 444, userInfo: nil) as Error
                completion(true , nil ,error)
                return
            }
            completion(true , results.results , nil)
        }).resume()
    }
}
