//
//  AlbumViewController.swift
//  HelloPhotoViewer
//
//  Created by Uran on 2019/9/16.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import MobileCoreServices

class AlbumViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var infos : [AlbumItemInfo] = [AlbumItemInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getAlbumPhotos(_ sender: UIBarButtonItem) {
        PhotoLibraryMananger.shared.checkAuth {
            PhotoLibraryMananger.shared.getPhotoInfos()
                { ( itemInfos) in
                    NSLog("get infos")
                    guard let infos = itemInfos else {return}
                    for info in infos{
                        if self.infos.contains(info) {continue}
                        self.infos.append(info)
                        self.infos.sort(by: { (info1, info2) -> Bool in
                            return info1.createTime > info2.createTime
                        })
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
            }
        }
    }
    

}

extension AlbumViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.frame.width
        width = width/3-10
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 2.5, bottom: 2.5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info = self.infos[indexPath.item]
        let infoStoryBoard = UIStoryboard(name: "PhotoInfo", bundle: nil)
        var willShowVC : UIViewController = UIViewController()
        switch info.mediaType {
        case .image:
            if let infoVC = infoStoryBoard.instantiateViewController(withIdentifier: "PhotoInfoViewController") as? PhotoInfoViewController{
                infoVC.photoInfo = info
                willShowVC = infoVC
                
            }
            break
        default:
            if let mediaVC = infoStoryBoard.instantiateViewController(withIdentifier: "PhotoMediaViewController") as? PhotoMediaViewController{
                mediaVC.mediaInfo = info
                willShowVC = mediaVC
            }
            break
        }
        self.navigationController?.pushViewController(willShowVC, animated: true)
        
    }
}
extension AlbumViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.infos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectCell
        let info = self.infos[indexPath.item]
        let color : UIColor = info.mediaType == .image ? .blue : .red
        cell.backgroundColor = color
        if let image = info.image {
            cell.imageView.image = image
        }
        return cell
    }
}
