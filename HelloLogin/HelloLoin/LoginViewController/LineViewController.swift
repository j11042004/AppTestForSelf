//
//  LineViewController.swift
//  HelloLoin
//
//  Created by Uran on 2019/11/25.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import LineSDK
class LineViewController: UIViewController {
    
    @IBOutlet weak var lineLoginBtn: LoginButton!
    @IBOutlet weak var lineCustomBtn: UIButton!
    let linePermissions : Set<LoginPermission> = [.profile, .friends, .groups, .messageWrite, .openID]
    override func viewDidLoad() {
        super.viewDidLoad()
        lineLoginBtn.permissions = linePermissions
        lineLoginBtn.delegate = self
    }
    
    @IBAction func lineCustomLogin(_ sender: UIButton) {
        LoginManager.shared.login(permissions: linePermissions, in: self)
        { [weak self](result) in
            switch result{
            case .success(let loginResult) :
                self?.handle(loginResult: loginResult)
                break
            case .failure(let error) :
                NSLog("custom Login Error : \(error.localizedDescription)")
                break
            }
        }
    }
}
// MARK: - Private Function
extension LineViewController {
    private func handle(loginResult : LoginResult){
        let accessToken = loginResult.accessToken.value
        let profile = loginResult.userProfile
        let displayName = profile?.displayName
        let imgUrl = profile?.pictureURL
        let statusMsg = profile?.statusMessage
        let userId = profile?.userID
        let lineInfo = LineInfo(accessToken: accessToken, name: displayName, pictureUrl: imgUrl, statusMessage: statusMsg, userId: userId, email:nil)
        
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVC.lineInfo = lineInfo
        self.navigationController?.pushViewController(profileVC, animated: false)
    }
}

extension LineViewController : LoginButtonDelegate{
    func loginButtonDidStartLogin(_ button: LoginButton) {
        NSLog("開始登入")
    }
    
    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult) {
        handle(loginResult: loginResult)
        
    }
    
    func loginButton(_ button: LoginButton, didFailLogin error: Error) {
        NSLog("Line login error :\(error.localizedDescription)")
    }
    
    
}
