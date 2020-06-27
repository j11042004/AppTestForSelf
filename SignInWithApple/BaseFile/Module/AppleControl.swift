//
//  AppleControl.swift
//  Camerabay
//
//  Created by Uran on 2019/12/27.
//  Copyright © 2019 WalkGame. All rights reserved.
//

import UIKit
import AuthenticationServices

struct AuthMemberInfo{
    let userId : String
    let email : String?
    let name : String?
    let authState : String?
    let authCode : String?
    let idToken : String?
}

let bundleId = Bundle.main.bundleIdentifier

protocol AppleControlDelegate : AnyObject {
    func appleControlDidLogedIn(error: Error?, authMember : AuthMemberInfo?)
}
@available(iOS 13.0, *)
class AppleControl: NSObject {
    public var delegate : AppleControlDelegate?
    class var shared : AppleControl {
        struct Static {
            static let sharedInstance = AppleControl()
        }
        return Static.sharedInstance
    }
}
@available(iOS 13.0, *)
extension AppleControl {
    @objc public func passwordLogin(){
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let appleIdRequest = appleIdProvider.createRequest()
        appleIdRequest.requestedScopes = [.email , .fullName]
        let passwordProvider = ASAuthorizationPasswordProvider()
        let passwordRequest = passwordProvider.createRequest()
        let requests = [appleIdRequest,
                        passwordRequest]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    /// 使用 apple id 的登入 request
    public func login() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email , .fullName]
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
    /// 確認 Sign in with Apple 的 UserId 是否還正在授權中
    public func checkAuth(completion : @escaping(_ success : Bool)->Void){
        guard let saveUserId = self.getSavedUserId() else {
            completion(false)
            return
        }
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: saveUserId)
        { (authState, error) in
            if let _ = error{
                completion(false)
                return
            }
            let allow = authState == .authorized
            completion(allow)
        }
    }
}
//MARK : - Apple Sign in Save Func
@available(iOS 13.0 , *)
extension AppleControl {
    private func save(userId : String){
        let keychain = KeychainItem(service: bundleId!, account: AppleControl.appleSignKey)
        guard let userIdData = userId.data(using: .utf8) else { return }
        do {
            try keychain.saveItem(userIdData)
        } catch  {
            NSLog("Apple Control Save Apple Sign UserID Error : \(error.localizedDescription)")
        }
    }
    public func getSavedUserId() -> String?{
        let keychain = KeychainItem(service: bundleId!, account: AppleControl.appleSignKey)
        do {
            let savedData = try keychain.readItem()
            let savedUserId = String(data: savedData, encoding: .utf8)
            return savedUserId
        } catch  {
            NSLog("Apple Control Get Saved Apple Sign UserID Error : \(error.localizedDescription)")
            return nil
        }
    }
    public func deleteUserId(){
        let keychain = KeychainItem(service: bundleId!, account: AppleControl.appleSignKey)
        do {
            try keychain.deleteItem()
        } catch {
            NSLog("Apple Control Delete Saved Apple Sign UserID Error : \(error.localizedDescription)")
        }
    }
}
//MARK:- ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension AppleControl : ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        NSLog("ASAuthorization : \(authorization.credential)")
        if let appleIdCredentinal = authorization.credential as? ASAuthorizationAppleIDCredential
        {
            NSLog("AppleID Credential")
            let userId = appleIdCredentinal.user
            // 若用真實 Email 登入才會有下列資訊，否則只會有 Apple SignIn User Id
            let email = appleIdCredentinal.email
            let nameInfo = appleIdCredentinal.fullName
            var name = ""
            if let firstName = nameInfo?.givenName {
                name.append("\(firstName)")
            }
            if let middle = nameInfo?.middleName {
                let space = name.count == 0 ? "" : " "
                name.append("\(space)\(middle)")
            }
            if let familyName = nameInfo?.familyName{
                let space = name.count == 0 ? "" : " "
                name.append("\(space)\(familyName)")
            }
            let state = appleIdCredentinal.state
            let authCodeData = appleIdCredentinal.authorizationCode
            var authCode : String?
            if let data = authCodeData {
                authCode = String(data: data, encoding: .utf8)
            }
            let idToken = appleIdCredentinal.identityToken
            var idTokenStr : String?
            if let tokenData = idToken {
                idTokenStr = String(data: tokenData, encoding: .utf8)
            }
            let authInfo = AuthMemberInfo(userId: userId, email: email, name: name, authState: state, authCode: authCode, idToken: idTokenStr)
            self.delegate?.appleControlDidLogedIn(error: nil, authMember: authInfo)
        }
        else if let passwordCredentinal = authorization.credential as? ASPasswordCredential
        {
            NSLog("Password Credential")
            let userId = passwordCredentinal.user
            let password = passwordCredentinal.password
            let authInfo = AuthMemberInfo(userId: userId, email: nil, name: nil, authState: nil, authCode: nil, idToken: nil)
            NSLog("password : \(password)")
            self.delegate?.appleControlDidLogedIn(error: nil, authMember: authInfo)
        }else {
            let error = NSError(domain: "Can't get current userId", code: 404, userInfo: nil)
            self.delegate?.appleControlDidLogedIn(error: error, authMember: nil)
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.delegate?.appleControlDidLogedIn(error: error, authMember: nil)
    }
}
//MARK:- ASAuthorizationControllerPresentationContextProviding
@available(iOS 13.0, *)
extension AppleControl : ASAuthorizationControllerPresentationContextProviding{
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

@available(iOS 13.0 , *)
extension AppleControl {
    static let appleSignKey = "com.walkgame.WGCR.AppleSign.UserId"
}
