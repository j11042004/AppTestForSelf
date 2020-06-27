//
//  PhotoInfoViewController.swift
//  HelloLivePhoto
//
//  Created by Uran on 2019/8/14.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import Photos
class PhotoInfoViewController: UIViewController {
    public var photoInfo : AlbumItemInfo?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let photoAsset = photoInfo?.asset {
            let options = PHImageRequestOptions()
            options.isSynchronous = false
            options.deliveryMode = .highQualityFormat
            PHImageManager.default().requestImage(for: photoAsset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options)
            { (image, info) in
                DispatchQueue.main.async {
                    guard let showImg = image else {
                        let photoInfoImg = self.photoInfo?.image
                        NSLog("size : \(photoInfoImg?.size)")
                        self.imageView.image = self.photoInfo?.image
                        return
                    }
                    NSLog("show image : \(showImg)")
                    self.imageView.image = showImg
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
