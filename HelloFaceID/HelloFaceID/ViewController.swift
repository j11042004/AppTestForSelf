//
//  ViewController.swift
//  HelloFaceID
//
//  Created by Uran on 2018/5/31.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import LocalAuthentication
//@available(iOS 11.0, *)
class ViewController: UIViewController {
    let auth = AuthManager.shardInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func faceIDAuth(_ sender: UIButton) {
        auth.authUser { (success, error) in
            if let error = error {
                
                
                let laError = error as! LAError
                let errorMessage =  self.paserLaErrorReason(With: laError)
                let alert = UIAlertController(title: "錯誤", message: errorMessage, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(cancel)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            if success {
                let alert = UIAlertController(title: nil, message: "驗證成功", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(cancel)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func paserLaErrorReason(With error : LAError) -> String{
        var errorMessage = ""
        switch error.code{
        case .appCancel:
            break
        case .authenticationFailed:
            break
        case .biometryLockout:
            break
        case .biometryNotAvailable:
            break
        case .biometryNotEnrolled:
            break
        case .invalidContext:
            break
        case .notInteractive:
            break
        case .passcodeNotSet:
            break
        case .systemCancel:
            break
        case .userCancel:
            break
        case .userFallback:
            break
        default:
            break
        }
        return errorMessage
    }
}

