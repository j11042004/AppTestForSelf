//
//  PhotoLibraryMananger.swift
//  HelloLivePhoto
//
//  Created by Uran on 2019/8/12.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

enum AlbumType {
    case audio
    case video
    case image
}
class AlbumItemInfo : NSObject {
    let createTime : Date
    public let videoUrl : URL?
    public let audioUrl : URL?
    public let mediaType : AlbumType
    public private(set) var image : UIImage?
    public let asset : PHAsset
    init(createTime : Date, asset : PHAsset, video : URL? = nil, audioUrl : URL? = nil, image : UIImage? = nil, mediaType : AlbumType) {
        self.createTime = createTime
        self.videoUrl = video
        self.audioUrl = audioUrl
        self.mediaType = mediaType
        self.image = image
        self.asset = asset
    }
}

class PhotoLibraryMananger: NSObject {
    static let shared = PhotoLibraryMananger()
    var authed : Bool = false
    public func checkAuth(completion:@escaping () -> Void){
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .authorized:
            authed = true
            completion()
            break
        default:
            PHPhotoLibrary.requestAuthorization
                { (status) in
                self.checkAuth(completion: completion)
            }
            break
        }
    }
    public func getPhotos(completion:@escaping ([UIImage]?)->Void){
        if !authed {
            completion(nil)
            return
        }
        NSLog("開始取得 images")
        DispatchQueue(label: "GetPhotosQurur", qos: .background).async {
            let group = DispatchGroup()
            let groupQueue = DispatchQueue(label: "GroupQueue", qos: .background)
            
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let fetchResults = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            var images = [UIImage]()
            for index in 0..<fetchResults.count{
                let result = fetchResults.object(at: index)
                group.enter()
                groupQueue.async(group: group, execute: {
                    manager.requestImage(for: result, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill, options: options, resultHandler: { (image, infos) in
                        if let image = image {
                            images.append(image)
                        }
                        group.leave()
                    })
                })
            }
            group.notify(queue: .main, execute: {
                NSLog("取得 images 完成")
                completion(images)
            })
        }
    }
    
    public func getPhotoInfos(completion:@escaping ([AlbumItemInfo]?)->Void){
        if !authed {
            completion(nil)
            return
        }
        NSLog("開始取得 Library infos ")
        
        DispatchQueue(label: "GetPhotosQurur", qos: .background).async {
            let group = DispatchGroup()
            let groupQueue = DispatchQueue(label: "GroupQueue", qos: .background)
            
            let manager = PHImageManager.default()
            
            let imageOptions = PHImageRequestOptions()
            imageOptions.isSynchronous = true
            imageOptions.deliveryMode = .highQualityFormat
            
            let videoOptions = PHVideoRequestOptions()
            videoOptions.version = .original
            videoOptions.deliveryMode = .automatic
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let assets = PHAsset.fetchAssets(with:fetchOptions)
            NSLog("取得的相簿資訊:\(assets.count)")
            var albumInfos = [AlbumItemInfo]()
            
            let targetSize = CGSize(width: 300, height: 300)
            
            for index in 0..<assets.count{
                let asset = assets.object(at: index)
                guard let createTime = asset.creationDate else {
                    continue
                }
                switch asset.mediaType{
                case .audio :
                    group.enter()
                    groupQueue.async(group: group)
                    {
                        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: imageOptions)
                        { (image , infos) in
                            manager.requestAVAsset(forVideo: asset, options: videoOptions)
                            { (avAsset, audioMix, info) in
                                if let avAsset = avAsset ,
                                    let urlAsset = avAsset as? AVURLAsset{
                                    let audioInfo = AlbumItemInfo(createTime: createTime, asset: asset, video:urlAsset.url , image: image, mediaType: .audio)
                                    albumInfos.append(audioInfo)
                                }
                            }
                            group.leave()
                        }
                    }
                    break
                case .image:
                    group.enter()
                    groupQueue.async(group: group)
                    {
                        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: imageOptions)
                        { (image , infos) in
                            if let image = image {
                                NSLog("取得的 image Size : \(image.size)")
                                let imageInfo = AlbumItemInfo(createTime: createTime, asset: asset, image: image, mediaType: .image)
                                albumInfos.append(imageInfo)
                            }
                            group.leave()
                        }
                    }
                    break
                case .video:
                    group.enter()
                    groupQueue.async(group: group)
                    {
                        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: imageOptions)
                        { (image , infos) in
                            manager.requestAVAsset(forVideo: asset, options: videoOptions)
                            { (avAsset, audioMix, info) in
                                if let avAsset = avAsset ,
                                    let urlAsset = avAsset as? AVURLAsset{
                                    let videoInfo = AlbumItemInfo(createTime: createTime, asset: asset, video:urlAsset.url , image: image, mediaType: .video)
                                    albumInfos.append(videoInfo)
                                }
                            }
                            group.leave()
                        }
                    }
                    break
                default:
                    break
                }
            }
            group.notify(queue: .main, execute: {
                NSLog("Data 取得成功")
                completion(albumInfos)
            })
        }
    }
}
