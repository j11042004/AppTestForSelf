//
//  TokenInfo.swift
//  HelloKKBox
//
//  Created by Uran on 2020/1/21.
//  Copyright © 2020 Uran. All rights reserved.
//

import Foundation
struct TokenInfo : Codable {
    let token : String
    let type : String
    let expires : Int
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case type = "token_type"
        case expires = "expires_in"
    }
}
