//
//  ViewController.swift
//  HelloSideMenu
//
//  Created by Uran on 2018/6/4.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: SlideMenuController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: type(of: self))
        let mainVC = MainViewController(nibName: "MainViewController", bundle: bundle)
        self.mainViewController = mainVC
        
        let leftVC = LeftViewController(nibName: "LeftViewController", bundle: bundle)
        self.leftViewController = leftVC
        let rightVC = RightViewController(nibName: "RightViewController", bundle: bundle)
        self.rightViewController = rightVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("viewWillAppear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("Main Will Disapear")
    }
    @objc @IBAction private func showLeftMenu(){
        if self.isLeftOpen(){
            self.closeLeft()
        }else{
            self.openLeft()
        }
    }
    
    // MARK: - SlideMenuController Delegate
    override func track(_ trackAction: SlideMenuController.TrackAction) {
        switch trackAction {
        case .leftTapOpen:
            print("左側點擊開啟")
        case .leftTapClose:
            print("左側點擊關閉")
        case .leftFlickOpen:
            print("左側滑動開啟")
        case .leftFlickClose:
            print("左側滑動關閉")
        case .rightTapOpen:
            print("右側點擊開啟")
        case .rightTapClose:
            print("右側點擊關閉")
        case .rightFlickOpen:
            print("右側滑動開啟")
        case .rightFlickClose:
            print("右側滑動關閉")
        }
    }

}

extension ViewController{
    
}
