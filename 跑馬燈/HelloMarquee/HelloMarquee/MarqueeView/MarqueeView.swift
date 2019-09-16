//
//  MarqueeView.swift
//  HelloMarquee
//
//  Created by Uran on 2019/4/15.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit

class MarqueeView: UIView {
    @IBOutlet fileprivate weak var marqueeLabel: UILabel!
    @IBOutlet fileprivate weak var marqueeLeading: NSLayoutConstraint!
    /// 將要顯示的跑馬燈資訊
    fileprivate var marqueeStrs : [NSAttributedString] = [NSAttributedString]()
    /// 是否正在執行中
    fileprivate var isRunning = false
    
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
    fileprivate func customerInit(){
        let xibStr = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: xibStr, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        // 不讓 超出 view frame 的 SubView 畫面還可以被顯示
        view.clipsToBounds = true
        self.addSubview(view)
        
        // 不讓 超出 view frame 的 SubView 畫面還可以被顯示
        self.clipsToBounds = true
    }
    
    /// 清空所有的 marquee info
    public func clearAllMarqueeStr(){
        self.marqueeStrs.removeAll()
        self.resetAllInfo()
    }
    /// 新增將要顯示的 marquee InfoStr
    public func insertNew(Marquee infoStr : NSAttributedString){
        self.marqueeStrs.append(infoStr)
        DispatchQueue.main.async {
            self.runMarquee()
        }
    }
    /// 執行 marqueeString
    public func runMarquee(){
        guard isRunning != true,
            let willShowMarquee = self.marqueeStrs.first
        else {
            return
        }
        self.isRunning = true
        self.marqueeStrs.removeFirst()
        
        // 將 Label 移到起始位置
        self.marqueeLeading.constant = self.frame.width
        self.marqueeLabel.attributedText = willShowMarquee
        // 使用 label size to fit 容易有跑版的問題，
        // 因此用 layoutIfNeeded 去重新取的 label size
        self.layoutIfNeeded()
        
        self.marqueeLeading.constant = -self.marqueeLabel.frame.width
        // 要執行動畫的時間
        let timeSpace : Double = UIScreen.main.bounds.width > UIScreen.main.bounds.height ? 70 : 30
        let duration : TimeInterval = TimeInterval((self.marqueeLabel.frame.width + self.frame.width)) / timeSpace
        // 開始執行動畫
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            self.checkToRunMarquee()
        }
    }
    /// 確認是否還有 marquee 要顯示
    fileprivate func checkToRunMarquee(){
        self.resetAllInfo()
        self.isRunning = false
        guard self.marqueeStrs.count > 0 else {
            return
        }
        DispatchQueue.main.async {
            self.runMarquee()
        }
    }
    /// 重設所有的資訊
    fileprivate func resetAllInfo(){
        // 清除所有的 animateions
        self.marqueeLabel.layer.removeAllAnimations()
        
        // 清空 label 內容，並 將 Label 移到起始位置
        self.marqueeLabel.attributedText = nil
        self.marqueeLabel.text = nil
        self.marqueeLeading.constant = self.frame.width
        
        // 會一併把剩下的 animations 一同清乾淨
        self.layoutIfNeeded()
    }
}
