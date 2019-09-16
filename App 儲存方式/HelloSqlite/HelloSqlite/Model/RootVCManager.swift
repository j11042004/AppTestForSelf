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
    class func getTopViewcontroller()->UIViewController?{
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        return rootVC
    }
    public func getTopViewcontroller()->UIViewController?{
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        return rootVC
    }
    private func getTopViewController(rootVC : UIViewController?) -> UIViewController? {
        if (rootVC?.isKind(of: UINavigationController.self))! {
            let naviVc = rootVC as! UINavigationController
            
            return self.getTopViewController(rootVC:naviVc.viewControllers.last)
        }
        if (rootVC?.isKind(of: UITabBarController.self))! {
            let tabBarVc = rootVC as! UITabBarController
            return self.getTopViewController(rootVC:tabBarVc.selectedViewController)
        }
        if rootVC?.presentationController != nil{
            return self.getTopViewController(rootVC:rootVC?.presentedViewController)
        }
        return rootVC
    }
}


