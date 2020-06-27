//
//  GoogleViewController.swift
//  HelloLoin
//
//  Created by Uran on 2019/12/6.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import GoogleSignIn
class GoogleViewController: UIViewController {
    
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var gidSignView: UIView!
    @IBOutlet weak var googleSignBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 設定你 App extension 的 bundle ID
        broadcastPicker.preferredExtension = "com.uran.HelloReplayKit"
        broadcastPicker.showsMicrophoneButton = true
        broadcastPicker.backgroundColor = .red
        self.view.addSubview(broadcastPicker)
        
        gidSignView.addSubview(gidSignUiBtn)
        gidSignUiBtn.translatesAutoresizingMaskIntoConstraints = false
        gidSignUiBtn.topAnchor.constraint(equalTo: gidSignView.topAnchor).isActive = true
        gidSignUiBtn.leftAnchor.constraint(equalTo: gidSignView.leftAnchor).isActive = true
        gidSignUiBtn.rightAnchor.constraint(equalTo: gidSignView.rightAnchor).isActive = true
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() == true {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            googleSignBtn.setTitle("Google Sign Out", for: .normal)
        }else {
            GIDSignIn.sharedInstance()?.signOut()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLog("frame :\(gidSignUiBtn.bounds) , viewFrame : \(gidSignView.bounds)")
    }
    @IBAction func googleSignIn(_ sender: UIButton) {
        
        guard GIDSignIn.sharedInstance()?.hasPreviousSignIn() == true
        else {
            GIDSignIn.sharedInstance()?.signIn()
            return
        }
        GIDSignIn.sharedInstance()?.disconnect()
    }
}

//MARK:- GIDSignInDelegate
extension GoogleViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser?, withError error: Error?) {
        if let error = error{
            NSLog("登入失敗 Error : \(error.localizedDescription)")
            return
        }
        guard let user = user else {
            GIDSignIn.sharedInstance()?.disconnect()
            return
        }
        googleSignBtn.setTitle("Google Sign Out", for: .normal)
        
        var resultTxt = ""
        let userId : String = user.userID
        resultTxt.append("userId : \(userId)\n\n")
        let idToken : String = user.authentication.idToken
        resultTxt.append("idToken : \(idToken)\n\n")
        let fullName : String = user.profile.name
        resultTxt.append("fullName : \(fullName)\n\n")
        let givenName : String = user.profile.givenName
        resultTxt.append("givenName : \(givenName)\n\n")
        let familyName : String = user.profile.familyName
        resultTxt.append("familyName : \(familyName)\n\n")
        let email : String = user.profile.email
        resultTxt.append("email : \(email)\n\n")
        infoTextView.text = resultTxt
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser?, withError error: Error?) {
        GIDSignIn.sharedInstance()?.signOut()
        if let error = error{
            NSLog("登出失敗 Error : \(error.localizedDescription)")
            return
        }
        NSLog("登出成功 ")
        NSLog("has auth : \(GIDSignIn.sharedInstance()?.hasPreviousSignIn() == true)")
        googleSignBtn.setTitle("Google Sign in", for: .normal)
    }
    
}
