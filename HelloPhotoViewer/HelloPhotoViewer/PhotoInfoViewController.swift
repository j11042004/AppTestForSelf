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

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let photoAsset = photoInfo?.asset {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat
            let targetSize = self.imageView.bounds.size
            
            
            PHImageManager.default().requestImage(for: photoAsset, targetSize: targetSize, contentMode: .aspectFit, options: options)
            { (image, info) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
    }
}
