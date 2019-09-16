//
//  AuthManager.swift
//  HelloFaceID
//
//  Created by Uran on 2018/5/31.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import LocalAuthentication

typealias AuthCompletion = (_ success : Bool , _ error : Error?) -> Void

class AuthManager: NSObject {
    static let shardInstance = AuthManager()
    private let faceIDReasonStr = "FaceID 驗證"
    private let touchIDReasonStr = "Touch ID 驗證"
    public func authUser(completion : @escaping AuthCompletion){
        self.authFaceIDUserID { (success, error) in
            completion(success , error)
        }
    }
    public func authFaceIDUserID(completion : @escaping AuthCompletion){
        let context : LAContext = LAContext()
        var authError : NSError? = nil
        /*
         deviceOwnerAuthenticationWithBiometrics:
         判斷是否允許 只驗證 Touch ID 或 Face ID，若是就只驗證 Touch ID 或 Face ID，當失敗時要輸入 密碼 解鎖
        */
        // 判斷是否允許驗證
        let availableAuth = context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &authError )
        
        if availableAuth {
            // .none 是在 ios 11.2 釋出
            if #available(iOS 11.2, *),
                context.biometryType == .none{
                NSLog("none Confirm")
                if let error = authError {
                    NSLog("auth error : \(error.code)")
                }
                completion(false , nil)
                return
            }
            // Face id 是在 iOS 11.0 釋出
            if #available(iOS 11.0, *) {
                // 判斷是否 是 Face ID 或是 Touch ID
                let allowed = context.biometryType == .faceID ||
                    context.biometryType == .touchID
                if allowed {
                    // 進行驗證
                    context.evaluatePolicy(
                        LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                        localizedReason: faceIDReasonStr) {
                            (success, error) in
                            completion(success , error)
                    }
                    return
                }
                if let error = authError {
                    NSLog("auth error : \(error.code)")
                }
                completion(false , nil)
                return
            }
        }else if #available(iOS 8.0, *){
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: touchIDReasonStr) { (success, error) in
                completion(success , error)
            }
        }
            
    }
    
}
