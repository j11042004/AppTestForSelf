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
enum GetAlbumType {
    case audio
    case video
    case image
    case all
}
enum Result<T>{
    case success(T)
    case fail(Error)
}
class AlbumItemInfo : NSObject {
    let createTime : Date
    public let videoUrl : URL?
    public let audioUrl : URL?
    public let mediaType : AlbumType
    public let data : Data?
    public private(set) var image : UIImage?
    public let asset : PHAsset
    init(createTime : Date, asset : PHAsset, video : URL? = nil, audioUrl : URL? = nil, image : UIImage? = nil, data : Data? = nil ,  mediaType : AlbumType) {
        self.createTime = createTime
        self.videoUrl = video
        self.audioUrl = audioUrl
        self.mediaType = mediaType
        self.image = image
        self.asset = asset
        self.data = data
    }
}

class PhotoLibraryMananger: NSObject {
    static let shared = PhotoLibraryMananger()
    var authed : Bool = false
    public func checkAuth(completion:@escaping (Bool) -> Void){
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized :
                self.authed = true
                completion(true)
                return
            default :
                self.authed = false
                completion(false)
                return
            }
        }
    }
    public func getAlbumInfos(type : GetAlbumType = .all ,  completion : @escaping ((Result<[AlbumItemInfo]>) -> Void)){
        self.checkAuth { (success) in
            if !success {
                let error = NSError(domain: "Can't get auth", code: 0, userInfo: nil)
                completion(Result.fail(error))
                return
            }
            NSLog("開始取得 Library infos ")
            
            let group = DispatchGroup()
            let groupQueue = DispatchQueue(label: "GroupQueue", qos: .background)
            
            let manager = PHImageManager.default()
            
            let imageOptions = PHImageRequestOptions()
            imageOptions.isSynchronous = false
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
            
            var unknownCount = 0
            var imageCount = 0
            for index in 0..<assets.count{
                let asset = assets.object(at: index)
                guard let createTime = asset.creationDate else {
                    continue
                }
                switch asset.mediaType{
                case .audio :
//                    if !(type == .audio || type == .all) { continue }
                    group.enter()
                    groupQueue.async(group: group)
                    {
                        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: imageOptions)
                        { (image , infos) in
                            manager.requestAVAsset(forVideo: asset, options: videoOptions)
                            { (avAsset, audioMix, info) in
                                if let avAsset = avAsset ,
                                    let urlAsset = avAsset as? AVURLAsset
                                {
                                    let audioInfo = AlbumItemInfo(createTime: createTime, asset: asset, video:urlAsset.url , image: image, mediaType: .audio)
                                    albumInfos.append(audioInfo)
                                }
                                group.leave()
                            }
                        }
                    }
                    break
                case .image:
//                    if !(type == .image || type == .all) {continue}
                    imageCount += 1
                    group.enter()
                    groupQueue.async(group: group)
                    {
                        
                        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: imageOptions)
                        { (image , infos) in
                            if let image = image
                            {
                                NSLog("取得的 image Size : \(image.size)")
                                let imageInfo = AlbumItemInfo(createTime: createTime, asset: asset, image: image, mediaType: .image)
                                albumInfos.append(imageInfo)
                            }
                            group.leave()
                        }
                    }
                    break
                case .video:
//                    if !(type == .video || type == .all) {continue}
                    group.enter()
                    groupQueue.async(group: group)
                    {
                        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: imageOptions)
                        { (image , infos) in
                            manager.requestAVAsset(forVideo: asset, options: videoOptions)
                            { (avAsset, audioMix, info) in
                                if let avAsset = avAsset ,
                                    let urlAsset = avAsset as? AVURLAsset
                                {
                                    let videoInfo = AlbumItemInfo(createTime: createTime, asset: asset, video:urlAsset.url , image: image, mediaType: .video)
                                    albumInfos.append(videoInfo)
                                    NSLog("add video")
                                }
                                group.leave()
                            }
                        }
                    }
                    break
                default:
                    unknownCount += 1
                    break
                }
            }
            group.notify(queue: .main) {
                NSLog("Data 取得成功 : \(albumInfos.count) , \(assets.count) , \(unknownCount)")
                completion(Result.success(albumInfos))
            }
        }
    }
}
