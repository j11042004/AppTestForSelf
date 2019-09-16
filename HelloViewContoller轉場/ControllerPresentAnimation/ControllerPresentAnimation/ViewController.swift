//
//  ViewController.swift
//  ControllerPresentAnimation
//
//  Created by Uran on 2018/12/6.
//  Copyright © 2018 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var collectionItemFrame : CGRect = .zero
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }


    
}
extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let sizeW =  (width - 20)/3
        return CGSize(width: sizeW, height: sizeW)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let blue : CGFloat = CGFloat(arc4random_uniform(256))/255
        let red : CGFloat = CGFloat(arc4random_uniform(256))/255
        let green : CGFloat = CGFloat(arc4random_uniform(256))/255
        cell.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as! NextViewController
        if let cell = collectionView.cellForItem(at: indexPath) ,
            let itemFrame = collectionView.getItemFrame(indexPath: indexPath){
            nextVC.view.backgroundColor = cell.backgroundColor
            
            self.collectionItemFrame =  itemFrame
        }
        if let _ = self.navigationController{
            navigationController?.pushViewController(nextVC, animated: true)
            return
        }
        self.present(nextVC, animated: true, completion: nil)
    }
}

extension ViewController : UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .none:
            return nil
        case .pop:
            return NavigationTransition()
        case .push:
            return NavigationTransition()
        }
        
    }
    
}
