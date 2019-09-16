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

protocol ImagePickerManagerDelegate {
    func imagePickerGetImage(image:UIImage?)
}

class ImagePickerManager: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    static let standard : ImagePickerManager = ImagePickerManager()
    var imagePickerDelegate : ImagePickerManagerDelegate?
    
    private let rootVCManager = RootVCManager.standard
    
    typealias getImageHandle = (_ image:UIImage)->Void
    
    enum imageType {
        case picture
        case photo
    }
    // MARK: - Show Image Alert
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
                    self.showSettingAuthAlert(with: "Wanning", Message: "是否跳轉到設定頁面，同意相機權限")
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
                    self.showSettingAuthAlert(with: "Wanning", Message: "是否跳轉到設定頁面，同意相簿權限")
                }
            })
        }
        alert.addAction(cancel)
        alert.addAction(picture)
        alert.addAction(photo)
        
        if let rootVc = rootVCManager.getTopViewcontroller() {
            rootVc.present(alert, animated: true, completion: nil)
        }else{
            let rootVC = UIApplication.shared.keyWindow?.rootViewController!
            rootVC?.present(alert, animated: true, completion: nil)
        }
    }
    // MARK: - 詢問權限要求
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
        
        // 取得最上層的 View Controller
        if let rootVc = rootVCManager.getTopViewcontroller() {
            rootVc.present(alert, animated: true, completion: nil)
        }else{
            let rootVC = UIApplication.shared.keyWindow?.rootViewController!
            rootVC?.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - 使用 ImagePickerController 做 相片取得
    
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
        
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: {
            NSLog("imagePicker did show")
        })
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let type = info[UIImagePickerControllerMediaType] as? String else {
            NSLog("info error")
            return
        }
        if type != (kUTTypeImage as String) {
            NSLog("不是相片")
            return
        }
        let originalImg = info[UIImagePickerControllerOriginalImage] as? UIImage
        let resizeImg = info[UIImagePickerControllerEditedImage] as? UIImage
        let savedImg =  resizeImg != nil ? resizeImg! : originalImg!
        
        if let imagePath = info[UIImagePickerControllerImageURL] as? NSURL {
            if let imageName = imagePath.lastPathComponent {
                NSLog("選到的圖片名:\(imageName)")
            }
        }else{
            if picker.sourceType == .camera{
                NSLog("相機照片")
            }else{
                NSLog("不知道圖片名")
            }
        }
        
        // 結束後 關閉
        picker.dismiss(animated: true) {
            // 將圖片經由 Delegate 傳送出去
            self.imagePickerDelegate?.imagePickerGetImage(image: savedImg)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
