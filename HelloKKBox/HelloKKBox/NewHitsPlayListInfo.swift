//
//  NewHitsPlayListInfo.swift
//  HelloKKBox
//
//  Created by Uran on 2020/1/21.
//  Copyright © 2020 Uran. All rights reserved.
//

import Foundation
import UIKit
struct NewHitsPlayListInfo : Codable {
    let data : [PlayListInfo]
    let paging : PageInfo
    let summary : Summary
}
struct PlayListInfo : Codable {
    let `id` : String
    let title : String
    let description : String
    let url : String
    let images : [ImageInfo]
    let updated_at : String
}
struct ImageInfo : Codable {
    let height : CGFloat
    let width : CGFloat
    let url : String
}
struct OwnerInfo : Codable {
    let `id` : String
    let url : String
    let name : String
    let description : String
    let images : [ImageInfo]
}

struct PageInfo : Codable {
    let offset : Int
    let limit : Int
    let previous : String?
    let next : String?
}
struct Summary : Codable {
    let total : Int
}
