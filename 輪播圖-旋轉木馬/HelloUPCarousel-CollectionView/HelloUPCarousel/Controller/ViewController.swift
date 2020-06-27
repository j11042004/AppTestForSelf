//
//  ViewController.swift
//  HelloUPCarousel
//
//  Created by Uran on 2020/2/5.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var carouselCollectLayout: UPCarouselFlowLayout!
    let cellId = "CharacterCell"
    var characters = [Character]()
    fileprivate var currentPage : Int = 0
    fileprivate let cellSize = CGSize(width: 200, height: 200)
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    // 每個 cell 的邊距 Size
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = cellSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        carouselCollectLayout.spacingMode = .overlap(visibleOffset: 30)
        carouselCollectLayout.itemSize = cellSize
        self.characters = creatItems()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rotationDidChange()
    }
    fileprivate func creatItems() -> [Character]{
        let characters = [
            Character(imageName: "wall-e", name: "Wall-E", movie: "Wall-E"),
            Character(imageName: "nemo", name: "Nemo", movie: "Finding Nemo"),
            Character(imageName: "ratatouille", name: "Remy", movie: "Ratatouille"),
            Character(imageName: "buzz", name: "Buzz Lightyear", movie: "Toy Story"),
            Character(imageName: "monsters", name: "Mike & Sullivan", movie: "Monsters Inc."),
            Character(imageName: "brave", name: "Merida", movie: "Brave")
        ]
        return characters
    }
    @objc fileprivate func rotationDidChange() {
        let cells = collectionView.visibleCells
        // 判斷 手機方向是否為平躺
        guard !orientation.isFlat else { return }
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var direction : UICollectionView.ScrollDirection
        var scrollPosition : UICollectionView.ScrollPosition
        switch orientation {
        case .landscapeLeft , .landscapeRight:
            direction = .vertical
            scrollPosition = .centeredVertically
            break
        default:
            direction = .horizontal
            scrollPosition = .centeredHorizontally
            break
        }
        layout.scrollDirection = direction
        
        if currentPage > 0 {
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
        }
    }
    
}
extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        NSLog("will display indexPath : \(indexPath)")
    }
}
extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CharacterCollectCell
        let character = characters[indexPath.item]
        cell.imgView.image = UIImage(named: character.imageName)
        return cell
    }
}
extension ViewController : UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide) / pageSide) + 1)
        NSLog("current page : \(currentPage)")
    }

}
