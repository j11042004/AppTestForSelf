//
//  ViewController.swift
//  HelloKKBox
//
//  Created by Uran on 2020/1/20.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit
enum Result<T> {
    case success(T)
    case failure(Error)
}
class ViewController: UIViewController {
    private let kkBoxID = "90c554d4986ec07b74ab490c7a4a74f8"
    private let kkBoxSecretKey = "f89f6f6a58d46a51d0d573a05318fde2"
    
    private let authUrlStr = "https://account.kkbox.com/oauth2/token"
    private var token : String?
    private var tokenType : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        getAuthInfo { (result) in
            switch result {
            case .failure(let error):
                NSLog("get authInfo error : \(error.localizedDescription)")
                break
            case .success(let tokenInfo):
                self.token = tokenInfo.token
                self.tokenType = tokenInfo.type
                self.getNewHitsPlayList { (result) in
                    switch result {
                    case .failure(let error ):
                        NSLog("Get New Hits Playlist error : \(error.localizedDescription)")
                        break
                    case .success(let playlistInfo):
                        let datas = playlistInfo.data
                        let pageInfo = playlistInfo.paging
                        NSLog("Page Info : \(pageInfo)")
                        let summary = playlistInfo.summary
                        NSLog("summary : \(summary)")
                        break
                    }
                }
                break
            }
        }
    }
}
extension ViewController {
    private func getAuthInfo(completion: @escaping (Result<TokenInfo>) -> Void){
        let url = URL(string: authUrlStr)!
        var request = URLRequest(url: url)
        let parameters = ["grant_type" : "client_credentials" , "client_id" : kkBoxID , "client_secret" : kkBoxSecretKey]
        request.httpMethod = "POST"
        request.httpBody = changeParametersData(from: parameters)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error{
                completion(Result.failure(error))
                return
            }
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode != 200
            {
                completion(Result.failure(NSError(domain: "Get Incorrect Data", code: httpResponse.statusCode, userInfo: nil)))
            }
            guard let data = data else {
                completion(Result.failure(NSError(domain: "The Json Data is nil", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
            do{
                let tokenInfo = try JSONDecoder().decode(TokenInfo.self, from: data)
                completion(Result.success(tokenInfo))
            }catch{
                completion(Result.failure(error))
            }
        }
        dataTask.resume()
    }
    func getNewHitsPlayList(offset : Int = 0 , limit : Int = 10 ,completion : @escaping (Result<NewHitsPlayListInfo>) -> Void){
        guard let accessToken = self.token else {
            getNewHitsPlayList(completion: completion)
            return
        }
        let urlStr = "https://api.kkbox.com/v1.1/new-hits-playlists?territory=TW&offset=\(offset)&limit=\(limit)"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        let header = ["Authorization" : "Bearer \(accessToken)"]
        request.allHTTPHeaderFields = header
        let dataTask = URLSession(configuration: .default).dataTask(with: request)
        { (data, response, error) in
            if let error = error {
                completion(Result.failure(error))
                return
            }
            let response = response as! HTTPURLResponse
            if response.statusCode != 200{
                let error = NSError(domain: "The response not 200", code: response.statusCode, userInfo: nil)
                let fail = Result<NewHitsPlayListInfo>.failure(error)
                completion(fail)
                return
            }
            guard let data = data else {
                let error = NSError(domain: "The Data is nil", code: response.statusCode, userInfo: nil)
                let fail = Result<NewHitsPlayListInfo>.failure(error)
                completion(fail)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let playListInfo = try jsonDecoder.decode(NewHitsPlayListInfo.self, from: data)
                completion(Result.success(playListInfo))
            }catch{
                completion(Result.failure(error))
            }
        }
        dataTask.resume()
    }
}
extension ViewController{
    func changeParametersData(from dict : [String : String]) -> Data?{
        var parameterStr = ""
        for (key , value) in dict{
            parameterStr.append(contentsOf: "&\(key)=\(value)")
        }
        parameterStr.removeFirst()
        return parameterStr.data(using: .utf8)
    }
}
