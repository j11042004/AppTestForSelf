//
//  ViewController.swift
//  HelloBarItemWithBadgeNum
//
//  Created by Uran on 2018/11/29.
//  Copyright © 2018 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpBadgeCountAndBarButton()
    }
    @objc func customerAction(){
        NSLog("hi")
    }
    @objc func iconAction(){
        NSLog("icon")
    }
    @objc func youtubeHighlightAction(){
        NSLog("youtubeHighlightAction")
    }
    @objc func noticeAction(){
        NSLog("noticeAction")
    }
    func setUpBadgeCountAndBarButton() {
        let badgeBarItem = BadgeBarItem(frame: CGRect(x: 0, y: 0, width: 44 , height: 44))
        badgeBarItem.setImage(for: "nav_channel_normal")
        badgeBarItem.setBadge(Hide: false, Num: 20, Color: .green)
        let xibItem = UIBarButtonItem(customView: badgeBarItem)
        navigationItem.rightBarButtonItems = [xibItem ]
    }
}

