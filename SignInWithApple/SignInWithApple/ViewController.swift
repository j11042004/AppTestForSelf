//
//  ViewController.swift
//  SignInWithApple
//
//  Created by Uran on 2019/6/10.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var baseView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13, *) {
            AppleAuthorizer.shared.delegate = self
            let authorizeBtn = AppleAuthorizer.shared.authorizationBtn
            authorizeBtn.addTarget(AppleAuthorizer.shared, action: #selector(AppleAuthorizer.signInWithApple), for: .touchUpInside)
            self.baseView.addSubview(authorizeBtn)
            authorizeBtn.translatesAutoresizingMaskIntoConstraints = false
            
            authorizeBtn.bottomAnchor.constraint(equalTo: self.signInBtn.topAnchor, constant: -20).isActive = true
            if let superView = authorizeBtn.superview{
                authorizeBtn.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: 0).isActive = true
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func appleSignIn(_ sender: Any) {
        if #available(iOS 13, *) {
            AppleAuthorizer.shared.signInWithApple()
        }
    }
}

@available(iOS 13.0 , *)
extension ViewController : AuthenticationDelegate{
    func authorizationGetAuthorInfo(userId: String, email: String?, nameInfo: PersonNameComponents?, state: String?, authorizationCode: Data?, identityToken: Data?) {
        AppleAuthorizer.shared.checkCredentialState(with: userId)
        var message = "UserId : \(userId) \n\n"
        if let familyName = nameInfo?.familyName{
            message.append("familyName : \(familyName)\n\n")
        }
        if let givenName = nameInfo?.givenName{
            message.append("givenName : \(givenName)\n\n")
        }
        if let middleName = nameInfo?.middleName{
            message.append("middleName : \(middleName)\n\n")
        }
        if let nickName = nameInfo?.nickname{
            message.append("nickName : \(nickName)\n\n")
        }
        if let email = email{
            message.append("email : \(email)\n\n")
        }
        NSLog("message :\(message)")
    }
    
    func authorization(completeGetError error: Error) {
        NSLog("登入失敗 Error : \(error.localizedDescription)")
    }
    func authorizationGetAutoEnter(user: String, password: String) {
        NSLog("App 幫你自動填入 資訊 :\(user) , password :\(password)")
    }
    
}
