//
//  DownloadView.swift
//  DownloadSDK
//
//  Created by Uran on 2018/3/26.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

public class DownloadView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var subHeadlineLabel: UILabel!
    
    let nibName = "DownloadView"
    var contentView : UIView!
    var timer : Timer?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.selfInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.selfInit()
    }
    
    private func selfInit(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        // 將 產生的 nibView 加到 自己的 View 上
        self.addSubview(self.contentView)
        
        self.contentView.center = self.center
        self.contentView.autoresizingMask = []
        // 決定是否要重新定義 size 隨者 Constraints 的改變
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        self.contentView.alpha = 0.0
        self.headlineLabel.text = ""
        self.subHeadlineLabel.text = ""
        // image 的 Bundle 要用 Bundle(for: type(of: self))
        // self 是指向當前的 Class
        let image = UIImage(named: "download.png", in: bundle, compatibleWith: nil)
        if image == nil {
            NSLog("download.png is nil")
        }
        self.imageView.image = image
    }
    
    public func set(headline text:String){
        self.headlineLabel.text = text
    }
    public func set(subHeadline text:String){
        self.subHeadlineLabel.text = text
    }
    
    public override func layoutSubviews() {
        // 將 contentView 轉成圓角
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 10
        self.contentView.clipsToBounds = true
    }
    // 將自己顯示出來
    public override func didMoveToSuperview() {
        self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.alpha = 1.0
            self.contentView.transform = CGAffineTransform.identity
        }) { _ in
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(3.0), target: self, selector: #selector(self.removeSelf), userInfo: nil, repeats: false)
        }
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeSelf()
        self.timer?.invalidate()
    }
    // 移除 自身
    @objc private func removeSelf() {
        // Animate removal of view
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.contentView.alpha = 0.0
        }) { _ in
            self.timer?.invalidate()
            self.removeFromSuperview()
        }
    }
}
