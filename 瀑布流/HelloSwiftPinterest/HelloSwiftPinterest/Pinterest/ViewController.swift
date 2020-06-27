//
//  ViewController.swift
//  HelloSwiftPinterest
//
//  Created by Uran on 2020/2/6.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    let cellId = "Cell"
    @IBOutlet weak var collectionView: UICollectionView!
    var items = [UIImage?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        for _ in 0..<20{
            let index = arc4random_uniform(2500) % 3 + 1
            let img = UIImage(named: "\(index)")
            items.append(img)
        }
        self.collectionView.reloadData()
    }
}
extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}
extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectCell
        let img = self.items[indexPath.item]
        cell.imgView.image = img
        cell.imgView.contentMode = .scaleAspectFit
        return cell
    }
    
    
}
