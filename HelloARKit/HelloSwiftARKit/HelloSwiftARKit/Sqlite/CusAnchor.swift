//
//  ARAnchor+SqlData.swift
//  HelloSwiftARKit
//
//  Created by Uran on 2018/3/12.
//  Copyright © 2018年 Uran. All rights reserved.
//

import Foundation
import ARKit

class CusAnchor: ARAnchor {
    var dataID : Int!
    override init(transform: matrix_float4x4) {
        super.init(transform: transform)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
