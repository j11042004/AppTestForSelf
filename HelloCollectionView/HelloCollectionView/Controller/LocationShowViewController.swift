//
//  LocationShowViewController.swift
//  HelloCollectionView
//
//  Created by Uran on 2020/2/12.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit

class LocationShowViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let cellId = "LocationCell"
    var colors = [UIColor]()
    var maxCount : CGFloat = 3
    var space : CGFloat = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<15 {
            let red =  CGFloat(Int(arc4random_uniform(255))) / 255
            let blue =  CGFloat(Int(arc4random_uniform(255))) / 255
            let green =  CGFloat(Int(arc4random_uniform(255))) / 255
            colors.append(UIColor(red: red, green: green, blue: blue, alpha: 1.0))
        }
        self.tabBarController?.tabBar.isTranslucent = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}
extension LocationShowViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / maxCount - 2*space
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: space, left: space/2, bottom: space, right: space/2)
    }
}
extension LocationShowViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = colors[indexPath.item]
        cell.contentView.backgroundColor = colors[indexPath.item]
        return cell
    }
}
