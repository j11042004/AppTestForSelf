//
//  CustomScrollView.swift
//
//  Created by Uran on 2018/7/4.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
class CustomScrollView : UIScrollView , CAAnimationDelegate {
    // 只允許 Public 時取得，但是在 Private 時作設定
    ///
    public private(set) var contentSubViews : [UIView]?
    var index : CGFloat = 0
    private var timer : Timer = Timer()
    private var transition = CATransition()
    
    /// 將指定的 [Views] 加到 ScrollView 中
    func addContentViews(With views : [UIView]){
        var contentViews = [UIView]()
        for index in 0..<views.count{
            let subView = views[index]
            contentViews.append(subView)
            self.addSubview(subView)
            
            // 新增所有的 Constraint
            subView.translatesAutoresizingMaskIntoConstraints = false
            subView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            subView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            // 當 index 為 0時就設定 最左邊的 View 就是 ScrollView ， 設定 left Anchor
            if index-1 < 0{
                subView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            }else{
                subView.leftAnchor.constraint(equalTo: views[index-1].rightAnchor, constant: 0).isActive = true
            }
            
            subView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
            subView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        }
        self.isPagingEnabled = true
        self.contentSubViews = contentViews
        self.resizeContentSize()
    }
    /// 重新計算 ScrollView 的 ContentSize
    /// ## 在 Viewcontroller 的 viewDidLayoutSubviews() 中執行
    func resizeContentSize(){
        guard let subViews = contentSubViews else {
            return
        }
        
        let contentSize = CGSize(width: self.frame.width*CGFloat(subViews.count), height: self.frame.height)
        self.contentInset = UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: contentSize.width)
        // 做出 page 的停留效果
        self.isPagingEnabled = true
    }
    
    /// 開始自動輪播
    /// ## Import ##
    /// * 當 VC 被 will Disappear 時要使用 stopAutoSlideShow() 停下
    /// - Parameter time: 執行的間隔時間，Double
    func startAutoSlideShow(With time : TimeInterval){
        // 用 Timer 計時輪播
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(self.changeScrollSubView(timer:)), userInfo: time, repeats: true)
        }
    }
    
    /// 停止自動輪播
    func stopAutoSlideShow(){
        self.timer.invalidate()
    }
    
    /// 更換要顯示到 Sub View
    @objc func changeScrollSubView(timer : Timer){
        guard
            let subViews = self.contentSubViews ,
            let passTime = timer.userInfo as? Double
        else {
            fatalError("ScrollView 的 contentSubViews 是 nil")
        }
        // 設定動畫時間
        let duration = passTime >= 0.2 ? 0.2 : passTime / 10
        
        // 判斷下個 index 是否小於 Count
        self.index = self.index+1 < CGFloat(subViews.count) ? self.index+1 : 0
        // 若是新的 index 為 0，拉出來要自己做動畫
        if self.index == 0{
            let indexX = self.frame.width * self.index
            let point = CGPoint(x: indexX, y: 0)
            self.contentOffset = point
            // 設定間隔時間與 Delegate
            transition.duration = duration
            transition.delegate = self
            // 動畫的效果，進出同樣速度
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            // 動畫效果
            transition.type = kCATransitionPush
            // 動畫從哪開始
            transition.subtype = kCATransitionFromRight
            // layer 新增動畫
            self.layer.add(transition, forKey: nil)
            return
        }
        
        UIView.animate(withDuration: duration) {
            let indexX = self.frame.width * self.index
            let point = CGPoint(x: indexX, y: 0)
            self.contentOffset = point
        }
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.layer.removeAllAnimations()
    }
}
