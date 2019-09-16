//
//  RootVCManager.swift
//  HelloSqlite
//
//  Created by Uran on 2018/2/26.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class RootVCManager: NSObject {
    public static let standard = RootVCManager()

    /// 取得最上層的 ViewController
    ///
    /// - Returns: 最上層的 View controller
    public func getTopViewcontroller()->UIViewController?{
        var rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC = self.getTopViewController(rootVC: rootVC)
        return rootVC
    }
    private func getTopViewController(rootVC : UIViewController?) -> UIViewController? {
        if let navSave = rootVC?.isKind(of: UINavigationController.self) {
            if navSave {
                let navigateVc = rootVC as! UINavigationController
                NSLog("nav Return")
                return self.getTopViewController(rootVC:navigateVc.viewControllers.last)
            }
        }
        if let tabSave = rootVC?.isKind(of: UITabBarController.self) {
            if tabSave {
                let tabBarVc = rootVC as! UITabBarController
                return self.getTopViewController(rootVC:tabBarVc.selectedViewController)
            }
        }
        if rootVC?.presentationController != nil{
            // 判斷下個要顯示 VC 的 presented VC 是否為 nil，若是就直接回傳 presented VC
            if rootVC?.presentedViewController?.presentedViewController == nil{
                return rootVC?.presentedViewController
            }else{
                return self.getTopViewController(rootVC:rootVC?.presentedViewController)
            }
        }
        return rootVC
    }
}


