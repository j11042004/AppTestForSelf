//
//  ViewController.swift
//  SignInWithApple
//
//  Created by Uran on 2019/6/10.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import AuthenticationServices
class ViewController: UIViewController , UISearchBarDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var baseView: UIView!
    #if SIGNINAPPLE
    let checkCode = "Sign in With Apple"
    #elseif APPLESIGNIN
    let checkCode = "Apple Sign In"
    #else
    let checkCode = "No thing"
    #endif
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13, *) {
            AppleControl.shared.delegate = self
            let authorizeBtn = ASAuthorizationAppleIDButton(type: .default, style: .whiteOutline)
            authorizeBtn.addTarget(AppleControl.shared, action: #selector(AppleControl.shared.passwordLogin), for: .touchUpInside)
            self.baseView.addSubview(authorizeBtn)
            authorizeBtn.translatesAutoresizingMaskIntoConstraints = false
            authorizeBtn.widthAnchor.constraint(equalTo: self.signInBtn.widthAnchor, multiplier: 1.0).isActive = true
            authorizeBtn.heightAnchor.constraint(equalTo: self.signInBtn.heightAnchor, multiplier: 1.0).isActive = true
            authorizeBtn.bottomAnchor.constraint(equalTo: self.signInBtn.topAnchor, constant: -20).isActive = true
            if let superView = authorizeBtn.superview{
                authorizeBtn.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: 0).isActive = true
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let savedUserId = AppleControl.shared.getSavedUserId() else{
            return
        }
        AppleControl.shared.checkAuth { (allow) in
            NSLog("had loged : \(allow)")
        }
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
//        appleIDProvider.getCredentialState(forUserID: savedUserId) { (credentialState, error) in
//            switch credentialState {
//            case .authorized:
//                break // The Apple ID credential is valid.
//            case .revoked, .notFound:
//                AppleControl.shared.login()
//                break
//            default:
//                break
//            }
//        }
    }
    @IBAction func appleSignIn(_ sender: Any) {
        if #available(iOS 13, *) {
            AppleControl.shared.login()
        }
    }
}

@available(iOS 13.0 , *)
extension ViewController : AppleControlDelegate {
    func appleControlDidLogedIn(error: Error?, authMember: AuthMemberInfo?) {
        if let error = error {
            self.textView.text = "Error : \n\(error.localizedDescription)"
            return
        }
        guard let memberInfo = authMember else{ return }
        var message = ""
        message.append("userId : \(memberInfo.userId)\n")
        NSLog("userId : \(memberInfo.userId)")
        if let email = memberInfo.email {
            message.append("email : \(email)\n")
        }
        if let name = memberInfo.name ,
            name.count > 0
        {
            message.append("name : \(name)\n")
        }
        if let authState = memberInfo.authState {
            message.append("authState : \(authState)\n")
        }
        if let authCode = memberInfo.authCode {
            message.append("authCode : \(authCode)\n\n")
            NSLog("authCode : \(authCode)")
        }
        if let idToken = memberInfo.idToken {
            message.append("idToken : \(idToken)\n\n")
            NSLog("idToken : \(idToken)")
        }
        self.textView.text = message
    }
}
