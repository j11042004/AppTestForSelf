//
//  DefaultClass.swift
//  HelloFirebaseChat
//
//  Created by Uran on 2018/4/12.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class DefaultClass: NSObject {
    static let databaseURLStr = "https://fir-chat-room-312c1.firebaseio.com/"
    /// 儲存在 Database 中的分類 "users"
    static let infoUsersKey = "users"
    /// 儲存在 users 分類中的 Key，"name"
    static let infoNameKey = "name"
    /// 儲存在 users 分類中的 Key，"email"
    static let infoEmailKey = "email"
    static let infoProfileImageKey = "profileimage"
    
}
