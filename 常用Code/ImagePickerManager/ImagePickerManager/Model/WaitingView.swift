//
//  WaitingView.swift
//  ImagePickerManager
//
//  Created by Uran on 2018/7/5.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class WaitingView: UIView {
    public var waitView : UIActivityIndicatorView!
    private var coverView : UIView!
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.customerInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customerInit()
    }
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.customerInit()
    }
    private func customerInit(){
        self.backgroundColor = UIColor.clear
        coverView = UIView()
        coverView.backgroundColor = UIColor.lightGray
        coverView.alpha = 0.3
        self.addSubview(coverView)
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        coverView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        coverView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        coverView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        
        
        waitView = UIActivityIndicatorView(style: .whiteLarge)
        waitView.hidesWhenStopped = true
        waitView.startAnimating()
        self.addSubview(waitView)
        waitView.translatesAutoresizingMaskIntoConstraints = false
        
        waitView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        waitView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        waitView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        waitView.heightAnchor.constraint(equalTo: waitView.widthAnchor, multiplier: 1).isActive = true
    }
    
    
    func setCoverConstraint(SuperView superView : UIView){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.topAnchor.constraint(equalTo: superView.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0).isActive = true
        self.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: 0).isActive = true
        self.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: 0).isActive = true
    }
}
