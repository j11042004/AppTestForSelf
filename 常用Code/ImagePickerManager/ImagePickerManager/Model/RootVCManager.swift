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

    public func topViewcontroller()->UIViewController?{
        var rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC = self.topViewController(rootVC: rootVC)
        return rootVC
    }
    private func topViewController(rootVC : UIViewController?) -> UIViewController? {
        if let navSave = rootVC?.isKind(of: UINavigationController.self) {
            if navSave {
                let navigateVc = rootVC as! UINavigationController
                NSLog("nav Return")
                return self.topViewController(rootVC:navigateVc.viewControllers.last)
            }
        }
        if let tabSave = rootVC?.isKind(of: UITabBarController.self) {
            if tabSave {
                let tabBarVc = rootVC as! UITabBarController
                return self.topViewController(rootVC:tabBarVc.selectedViewController)
            }
        }
        if rootVC?.presentationController != nil{
            // 判斷下個要顯示 VC 的 presented VC 是否為 nil，若是就直接回傳 presented VC
            if rootVC?.presentedViewController?.presentedViewController == nil{
                return rootVC?.presentedViewController
            }else{
                return self.topViewController(rootVC: rootVC?.presentedViewController)
            }
        }
        return rootVC
    }
}


