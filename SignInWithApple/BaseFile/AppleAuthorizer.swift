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
protocol AppleSignAuthDelegate : AnyObject {
    func appleSignAuth(error : Error)
    func appleSignAuthGetInfo(userId : String , email : String? , nameInfo : PersonNameComponents? , state : String? , authorizationCode : Data? , identityToken : Data? )
    func appleSignGetPassword(userId : String , password : String)
    func appleSignPresentationWindow() -> UIWindow
}
@available(iOS 13.0, *)
class AppleAuthorizer: NSObject {
    static let shared = AppleAuthorizer()
    public weak var delegate : AppleSignAuthDelegate?
    /// 登入用的 Button，文字顯示 Type :
    ///
    ///     * default : 登入
    ///     * Continue : Continue
    ///     * Sign up : 註冊
    public let authorizationBtn : ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .whiteOutline)
    
    /// 確認是否有登入 Apple Sign In
    /// - Parameter userId: 要辨識的 Apple Sign In User ID
    /// - Parameter completion: 回傳的 Result Closure
    ///
    ///     * authorized : Apple ID 登入成功
    ///     * revoked : Apple ID 登入失敗
    ///     * notFound : Apple ID 登入的 id 未找到，或未登入
    public func checkAppleSignInAuth(with userId : String, completion: @escaping (ASAuthorizationAppleIDProvider.CredentialState, Error?) -> Void){
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        appleIdProvider.getCredentialState(forUserID: userId, completion: completion)
    }
    // 若 iCloud 或 Keychain 有存 Apple Sign In 資料可用此
    @objc public func performExitAccountSetupFlows(){
        let requests = [ASAuthorizationAppleIDProvider().createRequest() ,
                        ASAuthorizationPasswordProvider().createRequest()]
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    /// 使用 appleID 進行登入
    @objc public func signInWithApple(){
        // 要要求的權限
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        // 顯示登入的 ViewController
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
            let userId = appleIdCredentinal.user
            // 若用真實 Email 登入才會有下列資訊，否則只會有 Apple SignIn User Id
            let email = appleIdCredentinal.email
            let nameInfo = appleIdCredentinal.fullName
            let state = appleIdCredentinal.state
            let authCodeData = appleIdCredentinal.authorizationCode
            let idToken = appleIdCredentinal.identityToken
            self.delegate?.appleSignAuthGetInfo(userId: userId, email: email, nameInfo: nameInfo, state: state, authorizationCode: authCodeData, identityToken: idToken)
        }
        else if let passwordCredentinal = authorization.credential as? ASPasswordCredential
        {
            let userId = passwordCredentinal.user
            let password = passwordCredentinal.password
            self.delegate?.appleSignGetPassword(userId: userId, password: password)
        }else {
            NSLog("取得的 Data 為 other")
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.delegate?.appleSignAuth(error: error)
    }
}
@available(iOS 13.0, *)
extension AppleAuthorizer : ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        return keyWindow!
    }
}
