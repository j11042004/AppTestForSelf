//
//  AnimateView.swift
//  HelloViewAnimation
//
//  Created by Uran on 2018/7/4.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class AnimateView: UIView {
    
    @IBOutlet weak var showImgView: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    private weak var view : UIView!
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
        view.frame = self.bounds
        return view
    }
    
    @IBAction func sayHello(_ sender: UIButton) {
        print("天線寶寶說你好！！！")
    }
}
