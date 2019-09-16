//
//  AppleAuthorizer.swift
//  SignInWithApple
//
//  Created by Uran on 2019/6/11.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import AuthenticationServices

@available(iOS 13.0 , *)
protocol AuthenticationDelegate : AnyObject {
    func authorization(completeGetError error : Error)
    func authorizationGetAuthorInfo(userId : String , email : String? , nameInfo : PersonNameComponents? , state : String? , authorizationCode : Data? , identityToken : Data? )
    func authorizationGetAutoEnter(user : String, password : String )
}
@available(iOS 13.0, *)
class AppleAuthorizer: NSObject {
    
    static let shared = AppleAuthorizer()
    
    public weak var delegate : AuthenticationDelegate?
    
    
    /// 登入用的 Button，文字顯示 Type :
    ///
    ///     * default : 登入
    ///     * Continue : Continue
    ///     * Sign up : 註冊
    public let authorizationBtn : ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .white)
    
    public func checkCredentialState(with userId : String){
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        appleIdProvider.getCredentialState(forUserID: userId)
        { (credentialState, error) in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                NSLog("Apple ID 登入授權有授權")
                break
            case .revoked:
                // The Apple ID credential is revoked.
                NSLog("Apple ID 登入授權拒絕授權")
                break
            case .notFound:
                // No credential was found, so show the sign-in UI.
                NSLog("Apple ID 登入授權未找到")
                break
            default:
                break
            }
        }
    }
    
    public func performExitAccountSetupFlows(){
        let requests = [ASAuthorizationAppleIDProvider().createRequest() ,
                        ASAuthorizationPasswordProvider().createRequest()]
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    /// 使用 appleID 進行登入
    @objc public func signInWithApple(){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}


@available(iOS 13.0, *)
extension AppleAuthorizer : ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredentinal = authorization.credential as? ASAuthorizationAppleIDCredential
        {
            self.delegate?.authorizationGetAuthorInfo(userId: appleIdCredentinal.user, email: appleIdCredentinal.email, nameInfo: appleIdCredentinal.fullName, state: appleIdCredentinal.state, authorizationCode: appleIdCredentinal.authorizationCode, identityToken: appleIdCredentinal.identityToken)
        }
        else if let passwordCredentinal = authorization.credential as? ASPasswordCredential
        {
            self.delegate?.authorizationGetAutoEnter(user: passwordCredentinal.user, password: passwordCredentinal.password)
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.delegate?.authorization(completeGetError: error)
    }
}
@available(iOS 13.0, *)
extension AppleAuthorizer : ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow!
    }
}
