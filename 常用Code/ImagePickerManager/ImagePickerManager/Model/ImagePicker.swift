//
//  ImagePicker.swift
//  ImagePickerManager
//
//  Created by Uran on 2018/7/5.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import MobileCoreServices


@objc protocol ImagePickerDelegate {
    @objc optional func imagePickerGotImage(image : UIImage? , imageName : String?)
    @objc optional func imagePickerStartRequestAuth()
    @objc optional func imagePickerFinishRequestAuth()
}
class ImagePicker: NSObject {
    typealias Compleation = (_ image : UIImage) -> Void
    enum imageType {
        /// 要取用相簿
        case album
        /// 要取用相機
        case camera
    }
    
    static let sharedInstance : ImagePicker = ImagePicker()
    var pickerDelegate : ImagePickerDelegate?
    private let rootVCManager = RootVCManager.standard
    private var pickerController : UIImagePickerController!
    
    /// 詢問取的 Image 來源的 Alert
    public func askImageAlert(){
        let alert = UIAlertController(title: nil, message: "請選擇圖片來源", preferredStyle: UIAlertController.Style.alert)
        let camera = UIAlertAction(title: "相機", style: UIAlertAction.Style.default) { (_) in
            self.getImage(From: .camera)
        }
        let album = UIAlertAction(title: "相簿", style: UIAlertAction.Style.default) { (_) in
            self.getImage(From: .album)
        }
        let cancel = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(camera)
        alert.addAction(album)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    /// 將照片存到相簿
    ///
    /// - Parameter image: 要存到相簿的相片
    public func savedInPhotoAlbum(With image:UIImage){
        // 去詢問權限
        self.checkImageAuth(imageType: .album) { [weak self](allowed) in
            // 告知已要求完權限
            DispatchQueue.main.async {
                self?.pickerDelegate?.imagePickerFinishRequestAuth?()
            }
            // 儲存照片到相簿中
            self?.saveImageInPhoto(With: image, completion: { (success, imageName) in
                guard let name = imageName else{
                    return
                }
                print("saved Image name : \(name)")
            })
        }
    }
    
    /// 根據來源開始取的照片
    ///
    /// - Parameter imageType: .camera 或是 .photo
    public func getImage(From imageType : imageType){
        var pickerSourceType : UIImagePickerController.SourceType
        switch imageType {
        case .camera:
            pickerSourceType = .camera
            break
        case .album:
            pickerSourceType = .photoLibrary
            break
        }
        
        self.checkImageAuth(imageType: imageType, checkCompletion: { (allowed) in
            if allowed{
                // 若同意就開始取得圖片
                self.launchImagePicker(SourceType: pickerSourceType)
            }else{
                self.askSettingAlert(With: "Warning", Message: "是否跳轉到設定頁面，同意相機權限")
            }
            // 告知已問完
            DispatchQueue.main.async {
                self.pickerDelegate?.imagePickerFinishRequestAuth?()
            }
        })
        
        
        
    }
    
    /// 詢問是否允許的相簿或相機的要求
    ///
    /// - Parameter imageType: 要取用的 image 種類
    private func checkImageAuth(imageType : imageType , checkCompletion : @escaping(_ success : Bool)->Void){
        self.pickerDelegate?.imagePickerStartRequestAuth?()
        switch imageType {
        case .album:
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized :
                    NSLog("允許")
                    checkCompletion(true)
                    break
                case .notDetermined :
                    NSLog("未決定")
                    break
                case .denied:
                    NSLog("拒絕")
                    checkCompletion(false)
                    break
                case .restricted :
                    NSLog("有限制")
                    break
                default:
                    break
                }
            }
            break
        case .camera:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (allowed) in
                if allowed {
                    checkCompletion(true)
                }else{
                    checkCompletion(false)
                }
            }
            
            break
        }
    }
    
    
    /// 製作 PickerView 並開始要求相簿或相機
    private func launchImagePicker(SourceType type : UIImagePickerController.SourceType){
        let typeaAllowed = UIImagePickerController.isSourceTypeAvailable(type)
        if !typeaAllowed {
            // MARK : Fix 跳出一些指令
            self.dismissPickerControllerAlert(Title: "錯誤！！", Message: "請檢查相機或選擇的來源是否有錯！！")
            return
        }
        pickerController = UIImagePickerController()
        pickerController.sourceType = type
        
        // 設定可支援 影片和圖片要 import MobileCoreServices
        pickerController.mediaTypes = [kUTTypeImage ,kUTTypeMovie] as [String]
        // 允許圖片做切割，在 ipad 上 實作時，只會出現左上角的 bug
//        pickerController.allowsEditing = true
        pickerController.delegate = self
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(self.pickerController, animated: true, completion: nil)
        }
    }
    
    
}

extension ImagePicker{
    
    /// 詢問是否要前往 設定頁面 Alert
    func askSettingAlert(With title : String? , Message message : String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (_) in
            if let settingUrl = URL(string: UIApplication.openSettingsURLString){
                // 開啟設定
                if #available(iOS 10.0, *){
                    UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
                }else{
                    UIApplication.shared.openURL(settingUrl)
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
    }
    /// 將 PickerController 關閉
    private func dismissPickerControllerAlert(Title title : String? , Message message : String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "確定", style: .cancel) { (action) in
            self.pickerController.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.rootVCManager.topViewcontroller()?.present(alert, animated: true, completion: nil)
        }
    }
    
    
    /// 將照片存到相簿中
    ///
    /// - Parameters:
    ///   - image: 要存的相片
    ///   - completion: 完成後會取的相片名以及有無成功
    func saveImageInPhoto(With image : UIImage , completion: @escaping (_ saveSuccess : Bool , _ imgName : String?)-> Void){
        DispatchQueue.global().async {
            // 儲存後的結果 ID
            var localID : String?
            PHPhotoLibrary.shared().performChanges({
                let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let placeHolder = result.placeholderForCreatedAsset
                localID = placeHolder?.localIdentifier
            })
            { (success, error) in
                if let error = error{
                    print("儲存圖片 Error : \(error.localizedDescription)")
                    completion(false , nil)
                    return
                }
                guard let localID = localID else{                completion(false , nil)
                    return
                }
                // 根據存入的 id 取得結果
                let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
                let asset = assetResult[0]
                
                let options = PHContentEditingInputRequestOptions()
                options.canHandleAdjustmentData = {
                    (adjustmeta) -> Bool in
                    return true
                }
                asset.requestContentEditingInput(with: options, completionHandler: { (editingInput, info) in
                    guard let inputUrlStr = editingInput?.fullSizeImageURL?.absoluteString else{
                        completion(true , nil)
                        return
                    }
                    let urlStrings = inputUrlStr.components(separatedBy: "/")
                    completion(true , urlStrings.last)
                })
            }
        }
    }
    
}

extension ImagePicker : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let type = info[.mediaType] as? String else {
            NSLog("info error")
            return
        }
        if type == String(kUTTypeMovie){
            print("是影片，要做錯誤處理")
        }
        if type != String(kUTTypeImage) {
            self.dismissPickerControllerAlert(Title: "錯誤！！！", Message: "選擇或拍攝的對象不是圖片格式")
            return
        }
        let originalImg = info[.originalImage] as? UIImage
        let resizeImg = info[.editedImage] as? UIImage
        let sendImg = resizeImg != nil ? resizeImg! : originalImg!
        
        var imgName : String? = nil
        if #available(iOS 11.0 , *) {
            if let imagePath = info[.imageURL] as? NSURL {
                imgName = imagePath.lastPathComponent
            }else{
                if picker.sourceType == .camera{
                    NSLog("是相機照片")
                    imgName = "相機照片"
                }else{
                    NSLog("未知圖片")
                    imgName = "未知圖片"
                }
            }
        }
        // 結束後 關閉
        picker.dismiss(animated: true){
            // 將圖片經由 Delegate 傳送出去
            self.pickerDelegate?.imagePickerGotImage?(image: sendImg, imageName: imgName)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true){
            self.pickerDelegate?.imagePickerGotImage?(image: nil, imageName: nil)
        }
    }
}
