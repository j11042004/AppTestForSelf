//
//  SigninViewController+imgTapHandle.swift
//  HelloFirebaseChat
//
//  Created by Uran on 2018/4/17.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import Photos
import MobileCoreServices

extension SigninViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    /// 註冊按鈕按下時的 Action
    @objc func loginRegisterHandle(_ sender: UIButton){
        guard let email = self.emailTextField.text ,
            let password = self.passwordTextField.text ,
            let name = self.nameTextField.text
            else {
                return
        }
        // 設定 Button 無法被動作
        self.loginRegisterButton.isUserInteractionEnabled = false
        
        switch self.signInRegisterSegmentedController.selectedSegmentIndex {
        case 0:
            // 登入
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error{
                    print("Sign In Error : \(error.localizedDescription)")
                    return
                }
                guard let user = user else{
                    print("user is nil")
                    return
                }
                print("user : \(user)")
                print(user.isEmailVerified)
                self.presentChatNavigationVC()
            }
        default:
            
            // 在 Database 建立帳號
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                // 設定 Button 可以被動作
                self.loginRegisterButton.isUserInteractionEnabled = true
                if let error = error{
                    print("get error : \(error.localizedDescription)")
                    return
                }
                guard let user = user else{
                    print("create User is nil")
                    return
                }
                // 在 Firebase storage 存放圖片
                if let image = self.profileImageView.image{
                    // 要給予存進去的圖片一個名子，否則會 Crash
                    let imageName = NSUUID().uuidString
                    let storageRef = Storage.storage().reference().child("profileImage").child("\(imageName).png")
                    if let imgData = UIImagePNGRepresentation(image){
                        storageRef.putData(imgData, metadata: nil) { (metadata, error) in
                            if let error = error{
                                NSLog("save img error : \(error.localizedDescription)")
                                return
                            }
                            guard let metadata = metadata else{
                                NSLog("storage metadata is nil")
                                return
                            }
                            guard let imgUrlStr = metadata.downloadURL()?.absoluteString else{
                                NSLog("metadata download str is nil")
                                return
                            }
                            // 設定在 Database 中儲存 email 和 name 的格式
                            let infoDict : [String : AnyObject] = [
                                DefaultClass.infoNameKey : name as AnyObject ,
                                DefaultClass.infoEmailKey : email as AnyObject,
                                DefaultClass.infoProfileImageKey : imgUrlStr as AnyObject
                            ]
                            
                            self.createUser(With: user.uid, infoDict: infoDict)
                        }
                    }
                }
                
            }
            
            
            
            
        }
        
    }
    
    /// 建立帳號
    ///
    /// - Parameters:
    ///   - userID: 建立的USer id
    ///   - infoDict: 帳號的內容
    func createUser(With userID : String , infoDict : [String:AnyObject]){
        
        // 在 database 中建立一個使用者
        let ref = Database.database().reference(fromURL: DefaultClass.databaseURLStr)
        // 在原本的 Database 下新增一個 users 的類別，
        // 註冊的訊息分別放在 users 底下的各自 id 的資料夾中
        let userRef = ref.child(DefaultClass.infoUsersKey).child(userID)
        userRef.updateChildValues(infoDict, withCompletionBlock: { (error, databaseRef) in
            if let error = error {
                print("Update user Fail : \(error.localizedDescription)")
                return
            }
            print("Saved Successful in Database")
            self.presentChatNavigationVC()
        })
    }
    
    
    
    /// 要求更換圖片
    @objc func tapSelectProfileImage(){
        self.showImageAlert()
       
    }
    
    /// 顯示選擇圖片或是相機的 Alert
    ///
    /// - Parameters:
    ///   - dataName: 傳送剛跳出的 View 上的 目的地，防止跳回去時會不見
    ///   - dataNote: 傳送剛跳出的 View 上的 目的地 Note，防止跳回去時會不見
    public func showImageAlert(){
        
        let alert = UIAlertController(title: nil, message: "請選擇圖片來源", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let picture = UIAlertAction(title: "圖片", style: .default) { (action) in
            // 詢問 圖片 要求是否允許
            self.checkImageAuth(imageType: .picture, check: { (allowed) in
                if allowed{
                    DispatchQueue.main.async {
                        self.launchImagePickerManager(sourceType: UIImagePickerControllerSourceType.photoLibrary)
                    }
                }else{
                    self.showSettingAuthAlert(with: "Wanning", Message: "是否跳轉到設定頁面，同意相簿權限")
                }
            })
        }
        let photo = UIAlertAction.init(title: "相機", style: .default) { (action) in
            // 詢問相機功能是否允許
            self.checkImageAuth(imageType: .photo, check: { (allowed) in
                if allowed{
                    DispatchQueue.main.async {
                        self.launchImagePickerManager(sourceType: UIImagePickerControllerSourceType.camera)
                    }
                }else{
                    self.showSettingAuthAlert(with: "Wanning", Message: "是否跳轉到設定頁面，同意相機權限")
                }
            })
        }
        alert.addAction(cancel)
        alert.addAction(picture)
        alert.addAction(photo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK:- 使用 ImagePickerController 做 相片取得
    /// 建立一個 ImagePickerController 並設定他的類別是 相機或是相簿
    ///
    /// - Parameter sourceType: UIImagePickerControllerSourceType
    private func launchImagePickerManager(sourceType : UIImagePickerControllerSourceType){
        let sourceTypeAllowed = UIImagePickerController.isSourceTypeAvailable(sourceType)
        if !sourceTypeAllowed{
            NSLog("請檢察相關設備，例如：相機，是否正常")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        
        // 設定可支援 影片和圖片要 import MobileCoreServices
        imagePicker.mediaTypes = [kUTTypeImage ,kUTTypeMovie] as [String]
        // 允許圖片做切割，在 ipad 上 實作時，只會出現左上角的 bug
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let type = info[UIImagePickerControllerMediaType] as? String else {
            NSLog("info error")
            return
        }
        if type != (kUTTypeImage as String) {
            NSLog("不是相片")
            let alert = UIAlertController(title: "錯誤", message: "您選擇的不是相簿", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "回到登入畫面", style: .destructive) { (action) in
                DispatchQueue.main.async {
                    picker.dismiss(animated: true, completion: nil)
                }
            }
            alert.addAction(cancel)
            picker.present(alert, animated: true, completion: nil)
            return
        }
        let originalImg = info[UIImagePickerControllerOriginalImage] as? UIImage
        let resizeImg = info[UIImagePickerControllerEditedImage] as? UIImage
        let savedImg =  resizeImg != nil ? resizeImg! : originalImg!
        self.profileImageView.image = savedImg
        
        // 結束後 關閉
        picker.dismiss(animated: true) {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - 詢問權限要求
extension SigninViewController{
    enum imageType {
        case picture
        case photo
    }
    private func checkImageAuth(imageType:imageType ,check:@escaping (_ success:Bool)->Void){
        switch imageType {
        case .photo:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                if granted{
                    NSLog("允許 Camera")
                    check(true)
                }else{
                    NSLog("不允許 Camera")
                    check(false)
                }
            }
            break
        case .picture:
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status{
                case .authorized :
                    NSLog("允許")
                    check(true)
                    break
                case .notDetermined :
                    NSLog("未決定")
                    break
                case .denied:
                    NSLog("拒絕")
                    check(false)
                    break
                case .restricted :
                    NSLog("有限制")
                    break
                }
            }
            break
        }
    }
    // MARK: - 跳轉到 設定 View
    private func showSettingAuthAlert(with Title : String? , Message : String?){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            if let settingUrl = URL(string: UIApplicationOpenSettingsURLString){
                UIApplication.shared.open(settingUrl, options: [String : Any](), completionHandler: nil)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}
