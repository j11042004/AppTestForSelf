//
//  ScrollViewController.swift
//  HelloViewAnimation
//
//  Created by Uran on 2018/7/3.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {

    @IBOutlet weak var scrollView: CustomScrollView!
    var colors : [UIColor] = [.blue , .green , .red , . yellow]
    lazy var subViews : [UIView] = {
        var subViews = [UIView]()
        for color in colors{
            let view = UIView()
            view.backgroundColor = color
            subViews.append(view)
        }
        let xibView = AnimateView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        subViews.append(xibView)
        return subViews
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let childVC = self.storyboard?.instantiateViewController(withIdentifier: "TransformButtonViewController") as? TransformButtonViewController {
            self.addChildViewController(childVC)
            for addedChildVC in self.childViewControllers{
                self.subViews.append(addedChildVC.view)
            }
            for childViewController in self.childViewControllers{
                childViewController.removeFromParentViewController()
            }
        }
        
        // ScrollView 新增內部的 View
        scrollView.addContentViews(With: subViews)
        // 關閉兩側顯示的 滑動 Slider
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        // 當 ScrollView 碰到邊緣時是否會回彈
        scrollView.bounces = false
        scrollView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 開始自動輪播
        self.scrollView.startAutoSlideShow(With: 1)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 移除自動輪播
        self.scrollView.stopAutoSlideShow()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 重新計算 ScollView 的 ContentSize
        scrollView.resizeContentSize()
        UIView.animate(withDuration: 0.2) {
            let indexX = self.scrollView.frame.width * self.scrollView.index
            let point = CGPoint(x: indexX, y: 0)
            self.scrollView.contentOffset = point
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ScrollViewController : UIScrollViewDelegate{
    // 當 停止減速時 會呼叫
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 取得現在所在的 index
        let nowPoint = scrollView.contentOffset
        let index = CGFloat(Int(nowPoint.x / scrollView.frame.width))
        self.scrollView.index = index
    }
    
}
