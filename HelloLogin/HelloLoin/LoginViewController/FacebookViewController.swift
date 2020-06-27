//
//  FacebookViewController.swift
//  HelloLoin
//
//  Created by Uran on 2019/11/27.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
class FacebookViewController: UIViewController {
    
    @IBOutlet weak var fbLoginBtn: UIButton!
    let loginManager = LoginManager()
    let permissions = ["public_profile", "email"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func fbLogin(_ sender: Any) {
        loginManager.logOut()
        loginManager.logIn(permissions: permissions, from: self)
        { [weak self](loginResult, error) in
            if let error = error {
                let nsError = error as NSError
                NSLog("FB Login Error : \(nsError.localizedDescription) , code : \(nsError.code)")
                return
            }
            guard let result = loginResult ,
                result.isCancelled != true
            else { return }
            self?.getFBInfo()
        }
    }
    private func getFBInfo(){
        guard let token = AccessToken.current else {
            NSLog("access Token is nil")
            return
        }
        NSLog("get access Token userID: \(token.userID)")
        NSLog("get tokenString : \(token.tokenString)")
        self.sendToAppSchool(with: token.tokenString)
        let parameters = ["fields" : "id,email,gender,name,age_range,link"]
        let request = GraphRequest(graphPath: "me", parameters: parameters)
        request.start {
            [weak self] (requestConnection, result, error) in
            guard let resultDict = result as? [String : Any] else{
                return
            }
            let email = resultDict["email"] as? String
            let name = resultDict["name"] as? String
            let tokenId = resultDict["id"] as? String
            NSLog("FB email :\(email)")
            NSLog("FB name : \(name)")
            NSLog("FB tokenId : \(tokenId)")
            
            
            return
            let lineInfo = LineInfo(accessToken: tokenId, name: name, pictureUrl: nil, statusMessage: nil, userId: nil, email: email)
            DispatchQueue.main.async {
                let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                profileVC.lineInfo = lineInfo
                self?.navigationController?.pushViewController(profileVC, animated: false)
            }
        }
    }
    func sendToAppSchool(with token : String){
        let urlStr = "https://api.appworks-school.tw/api/1.0/user/signin"
        guard let url = URL(string: urlStr) else {return}
        let parameters =
            ["provider" : "facebook" ,
             "access_token" : token ]
        Alamofire.request(url, method: .post, parameters: parameters).responseData { (responseData) in
            switch responseData.result {
            case .success(let data):
                do {
                    let decoderResult = try JSONDecoder().decode(FBJsonInfo.self, from: data)
                    NSLog("decoder result email: \(decoderResult.data.user.email)")
                } catch  {
                    NSLog("decoder error : \(error.localizedDescription)")
                }
/*
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                    return
                }
                NSLog("json : \(json)")
*/
                break
            case .failure(let error):
                NSLog("data error : \(error.localizedDescription)")
                break
            }
        }
    }
}


struct FBJsonInfo : Codable {
    var data : FBData
}
struct FBData : Codable {
    var expired : Int
    var token : String
    var user : FBUserInfo
    
    private enum CodingKeys: String, CodingKey {
        case expired = "access_expired"
        case token = "access_token"
        case user
    }
}
struct FBUserInfo : Codable {
    var email : String
    var userId : Int
    var name : String
    var pictureUrlStr : String
    var provider : String
    
    private enum CodingKeys: String, CodingKey {
        case email
        case userId = "id"
        case name
        case pictureUrlStr = "picture"
        case provider
    }
}
