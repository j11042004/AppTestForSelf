//
//  WaitingView.swift
//  HelloGoogleMap
//
//  Created by Uran on 2018/5/4.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class WaitingView: UIView {
    private var view : UIView!
    
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
        // 出錯 還要再修正
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func customerInit(){
        view = self.loadViewfromNib()
        self.addSubview(view)
    }
    
    func loadViewfromNib() -> UIView {
        let xibStr = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: xibStr, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.frame
        return view
    }

}
