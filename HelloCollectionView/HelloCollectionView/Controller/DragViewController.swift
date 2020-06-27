//
//  DragViewController.swift
//  HelloCollectionView
//
//  Created by Uran on 2019/12/5.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit

class DragViewController: UIViewController {
    let cellId = "Cell"
    var infos = [String]()
    var maxCount : CGFloat = 3
    var space : CGFloat = 5
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        view.backgroundColor = .black
        
        for index in 0..<51{
            infos.append("\(index)")
        }
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    @objc func handleLongGesture(_ gesture : UILongPressGestureRecognizer){
        NSLog("UILongPressGestureRecognizer")
        let locationPoint = gesture.location(in: collectionView)
        switch gesture.state {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: locationPoint) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: indexPath)
            break
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(locationPoint)
            break
        case .ended :
            collectionView.endInteractiveMovement()
            break
        default:
            collectionView.cancelInteractiveMovement()
            break
        }
    }
}
//MARK: - UICollectionViewDelegate
extension DragViewController{
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let selectInfo = infos[sourceIndexPath.item]
        infos.remove(at: sourceIndexPath.item)
        infos.insert(selectInfo, at: destinationIndexPath.item)
    }
}
extension DragViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / maxCount - 2*space
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: space, left: space/2, bottom: space, right: space/2)
    }
    /*
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
     return space
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
     return space
     }
     */
}
extension DragViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InfoCollectionCell
        let red =  CGFloat(Int(arc4random_uniform(255))) / 255
        let blue =  CGFloat(Int(arc4random_uniform(255))) / 255
        let green =  CGFloat(Int(arc4random_uniform(255))) / 255
        cell.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        cell.textLabel.text = "\(infos[indexPath.item])"
        cell.textLabel.textAlignment = .center
        return cell
    }
}


