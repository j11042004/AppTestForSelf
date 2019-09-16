//
//  ViewController.swift
//  ScrollSliderView
//
//  Created by Uran on 2018/7/5.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: CustomScrollView!
    
    
    var colors : [UIColor] = [.blue , .green , .red , . yellow]
    lazy var subViews : [UIView] = {
        var subViews = [UIView]()
        for color in colors{
            let view = UIView()
            view.backgroundColor = color
            subViews.append(view)
        }
        
        return subViews
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ScrollView 新增內部的 View
        scrollView.addContentViews(With: subViews)
        // 關閉兩側顯示的 滑動 Slider
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.showsVerticalScrollIndicator = false
        // 當 ScrollView 碰到邊緣時是否會回彈
        scrollView.bounces = false
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 重新計算 ScollView 的 ContentSize
        scrollView.resizeContentInset()
        
    }

}

