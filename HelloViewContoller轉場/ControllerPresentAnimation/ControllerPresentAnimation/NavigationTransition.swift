//
//  NavigationTransition.swift
//  ControllerPresentAnimation
//
//  Created by Uran on 2018/12/6.
//  Copyright © 2018 Uran. All rights reserved.
//

import UIKit

class NavigationTransition: NSObject , UIViewControllerAnimatedTransitioning {
    /// 動畫時間
    var duration : TimeInterval = 0.5
    var originFrame : CGRect = CGRect.zero
    override init() {
        super.init()
        let screenFrame = UIScreen.main.bounds
        self.originFrame = CGRect(x: screenFrame.width, y: 0, width: screenFrame.width, height: screenFrame.height)
    }
    init(duration : TimeInterval , originFrame : CGRect) {
        super.init()
        self.originFrame = originFrame
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // fromVC：將要被 dismiss 的 VC
        // toVC：將要被 顯示 的 VC
        guard let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view ,
            let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view
        else {
            // 一定要使用這個來清理 容器
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        
        // 動畫時間，從 transitionDuration 取得
        let duration = self.transitionDuration(using: transitionContext)
        // 轉場動畫用的 容器 view
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        
        let screenFrame = UIScreen.main.bounds
        let toFrame = toView.frame
        let fromFrame = fromView.frame
        // 下個 ViewController 的 起始 Frame
        toView.frame = CGRect(x: -screenFrame.width, y: 0, width: screenFrame.width, height: screenFrame.height)
        
        UIView.animate(withDuration: duration, animations: {
            fromView.frame = CGRect(x: screenFrame.width, y: 0, width: screenFrame.width, height: screenFrame.height)
            toView.frame = CGRect(x:0, y: 0, width: toFrame.width, height: toFrame.height)
        }) { (_) in
            // 一定要使用這個來清理 容器
            fromView.frame = CGRect(x: 0, y: 0, width: fromFrame.width, height: fromFrame.height)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    

}
