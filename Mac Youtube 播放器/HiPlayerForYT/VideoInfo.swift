//
//  VideoInfo.swift
//  HiPlayerForYT
//
//  Created by Uran on 2019/5/16.
//  Copyright © 2019 Uran. All rights reserved.
//

import Foundation
struct VideoInfo {
    let id : String
    let title : String
    let totalSec : TimeInterval
    let thunbnailUrl : URL?
    let streamUrls : [URL]
}
