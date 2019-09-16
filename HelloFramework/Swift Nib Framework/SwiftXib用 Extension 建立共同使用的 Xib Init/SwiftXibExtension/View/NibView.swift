//
//  NibView.swift
//  SwiftXibExtension
//
//  Created by Uran on 2018/6/4.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class NibView: UIView {
    
    @IBOutlet weak var imageview: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSLog("aDecoder")
    }
}
