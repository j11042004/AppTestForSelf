//
//  BadgeBarItem.swift
//  HelloBarItemWithBadgeNum
//
//  Created by Uran on 2018/12/3.
//  Copyright © 2018 Uran. All rights reserved.
//

import UIKit

class BadgeBarItem: UIButton {
    let badgeNumLabel: UILabel = UILabel()
    
    
    convenience init(){
        self.init(frame: CGRect.zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customerInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customerInit()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        NSLog("Hello View awake")
    }
    fileprivate func customerInit(){
        // 設定 badgeLabel
        self.badgeNumLabel.frame = CGRect(x: 25, y: -3, width: 25, height: 25)
        self.badgeNumLabel.layer.borderColor = UIColor.clear.cgColor
        self.badgeNumLabel.layer.borderWidth = 2
        self.badgeNumLabel.layer.cornerRadius = self.badgeNumLabel.bounds.size.height / 2
        self.badgeNumLabel.textAlignment = .center
        self.badgeNumLabel.layer.masksToBounds = true
        self.badgeNumLabel.textColor = .white
        self.badgeNumLabel.font = UIFont.systemFont(ofSize: 12)
        
        self.addSubview(self.badgeNumLabel)
        self.setBadge()
        self.backgroundColor = .blue
    }
    private func setConstraint(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.badgeNumLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    /// 設定 BadgeNum 的資訊
    ///
    /// - Parameters:
    ///   - hidden: 是否隱藏
    ///   - num: 要顯示 number 數量
    ///   - color: 要顯示的顏色
    public func setBadge(Hide hidden : Bool = true ,Num num : Int = 0 , Color color : UIColor = UIColor.clear){
        self.badgeNumLabel.backgroundColor = color
        var textNum = num <= 0 ? "" : "\(num)"
        textNum = num > 9 ? "9+" : textNum
        self.badgeNumLabel.text = textNum
        self.badgeNumLabel.isHidden = hidden
    }
    /// 設定 Image
    ///
    /// - Parameter name: Image
    public func setImage(for image : UIImage? ){
        
        let icon = image?.resizeImage(targetSize: CGSize(width: 44, height: 44))
        
        self.setImage(icon, for: .normal)
    }
    /// 設定 Image
    ///
    /// - Parameter name: 圖片名
    public func setImage(for name : String ){
        var icon = UIImage(named: name)
        icon = icon?.resizeImage(targetSize: CGSize(width: 44 , height: 44))
        self.setImage(icon, for: .normal)
    }
}
