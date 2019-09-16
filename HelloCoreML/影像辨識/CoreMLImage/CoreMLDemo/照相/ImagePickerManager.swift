//
//  ImagePickerViewController.swift
//  HelloSqlite
//
//  Created by Uran on 2018/2/26.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import MobileCoreServices

@objc protocol ImagePickerManagerDelegate {
    
    /// 告知 ImagePicker 取得 Image
    ///
    /// - Parameters:
    ///   - success: 是否成功
    ///   - image: UIImage?
    ///   - imgNote: 備註
    ///   - imgName: image 名字
    @objc optional func imagePickerGetImage(success : Bool, image:UIImage? ,imgName :String?)
}

class ImagePickerManager: NSObject {
    
    typealias GetImageHandle = (_ image:UIImage)->Void
    static let shared : ImagePickerManager = ImagePickerManager()
    var imagePickerDelegate : ImagePickerManagerDelegate?
    
    private let rootVCManager = RootVCManager.standard
    
    // 因為 dataVC 會 present ImagePickerVC 導致上面被輸入的 String 在 ImagePickerVC dismiss 時不見，所以先存起來
    enum imageType {
        /// 圖片
        case picture
        /// 照片
        case photo
    }
    // MARK: - Public Function
    // Show Image Alert
    /// 顯示選擇圖片或是相機的 Alert
    public func showImageAlert(){
        let alert = UIAlertController(title: nil, message: "請選擇圖片來源", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let picture = UIAlertAction(title: "圖片", style: .default) { (action) in
            // 詢問 圖片 要求是否允許
            self.checkImageAuth(imageType: .picture, check: { (allowed) in
                if allowed{
                    DispatchQueue.main.async {
                        self.launchImagePickerManager(sourceType: UIImagePickerController.SourceType.photoLibrary)
                    }
                }else{
                    self.showSettingAuthAlert(with: "Wanning", Message: "是否跳轉到設定頁面，同意相簿取用的權限")
                }
            })
        }
        let photo = UIAlertAction.init(title: "相機", style: .default) { (action) in
            // 詢問相機功能是否允許
            self.checkImageAuth(imageType: .photo, check: { (allowed) in
                if allowed{
                    DispatchQueue.main.async {
                        self.launchImagePickerManager(sourceType: UIImagePickerController.SourceType.camera)
                    }
                }else{
                    self.showSettingAuthAlert(with: "Wanning", Message: "是否跳轉到設定頁面，同意相機取用的權限")
                }
            })
        }
        alert.addAction(cancel)
        alert.addAction(picture)
        alert.addAction(photo)
        if let rootVc = rootVCManager.getTopViewcontroller() {
            NSLog("rootVc is not nil")
            rootVc.present(alert, animated: true, completion: nil)
        }else{
            NSLog("rootVc is nil")
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            rootVC?.present(alert, animated: true, completion: nil)
        }
    }
    
    /// 根據 image Type 去要求相機或是相簿
    ///
    /// - Parameter imageType: image Type
    public func requestImage(With imageType : imageType){
        switch imageType {
        case .photo:
            self.checkImageAuth(imageType: .photo, check: { (allowed) in
                if allowed{
                    DispatchQueue.main.async {
                        self.launchImagePickerManager(sourceType: UIImagePickerController.SourceType.camera)
                    }
                }else{
                    self.showSettingAuthAlert(with: "Wanning", Message: "是否跳轉到設定頁面，同意相機權限")
                }
            })
            break
        case .picture:
            self.checkImageAuth(imageType: .picture, check: { (allowed) in
                if allowed{
                    DispatchQueue.main.async {
                        self.launchImagePickerManager(sourceType: UIImagePickerController.SourceType.photoLibrary)
                    }
                }else{
                    self.showSettingAuthAlert(with: "Wanning", Message: "是否跳轉到設定頁面，同意相簿權限")
                }
            })
            break
            
        }
    }
    // MARK: - 詢問權限要求
    
    /// 去詢問圖片要求或相片要求的權限
    ///
    /// - Parameters:
    ///   - imageType: 相簿或相機取用的 Type
    ///   - check: 是否授權成功
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
                @unknown default:
                    break
                }
            }
            break
        }
    }
    // MARK: - 跳轉到 設定 View
    /// 詢問跳轉到 Setting 的 Alert
    private func showSettingAuthAlert(with Title : String? , Message : String?){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            if let settingUrl = URL(string: UIApplication.openSettingsURLString){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(settingUrl)
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        
        // 取得最上層的 View Controller
        if let rootVc = rootVCManager.getTopViewcontroller() {
            rootVc.present(alert, animated: true, completion: nil)
        }else{
            let rootVC = UIApplication.shared.keyWindow?.rootViewController!
            rootVC?.present(alert, animated: true, completion: nil)
        }
    }
    // 顯示關閉的警告 Alert
    private func showDismissWarningAlert(with title : String? , message: String?){
        var rootViewController : UIViewController?
        if let rootVc = self.rootVCManager.getTopViewcontroller() {
            rootViewController = rootVc
        }else{
            let rootVC = UIApplication.shared.keyWindow?.rootViewController!
            rootViewController = rootVC
        }
        
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "確定", style: .cancel) { (action) in
            DispatchQueue.main.async {
                // 取得最上層的 View Controller
                if rootViewController?.navigationController != nil{
                    rootViewController?.navigationController?.popViewController(animated: true)
                }else{
                    rootViewController?.dismiss(animated: true)
                }
            }
        }
        alert.addAction(cancel)
        DispatchQueue.main.async {
            // 取得最上層的 View Controller
            rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    // MARK:- 使用 ImagePickerController 做 相片取得
    /// 建立一個 ImagePickerController 並設定他的類別是 相機或是相簿
    ///
    /// - Parameter sourceType: UIImagePickerControllerSourceType
    private func launchImagePickerManager(sourceType : UIImagePickerController.SourceType){
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
        if let rootVC = self.rootVCManager.getTopViewcontroller(){
            rootVC.present(imagePicker, animated: true, completion: nil)
        }else{
            UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
}
extension ImagePickerManager:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let type = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            NSLog("info error")
            return
        }
        if type != (kUTTypeImage as String) {
            NSLog("不是相片")
            self.showDismissWarningAlert(with: "警告！！", message: "請重新選擇相片或是圖片！！")
            return
        }
        let originalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let resizeImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        let savedImg =  resizeImg != nil ? resizeImg! : originalImg!
        
        let imgName : String? = ""
//        if #available(iOS 11.0 , *) {
//            if let imagePath = info[UIImagePickerControllerImageURL] as? NSURL {
//                imgName = imagePath.lastPathComponent
//            }else{
//                if picker.sourceType == .camera{
//                    NSLog("相機照片")
//                }else{
//                    NSLog("不知道圖片名")
//                }
//            }
//        }
        // 將圖片經由 Delegate 傳送出去
        self.imagePickerDelegate?.imagePickerGetImage?(success: true, image: savedImg, imgName: imgName)
        // 結束後 關閉
        picker.dismiss(animated: true)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePickerDelegate?.imagePickerGetImage?(success: true, image: nil, imgName: nil)
        picker.dismiss(animated: true)
    }
}
