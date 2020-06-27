//
//  KeychaninManager.swift
//  SignInWithApple
//
//  Created by Uran on 2019/10/3.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
import Foundation
enum KeychainError: String, Error {
    case noSavedInfo = "noSavedInfo"
    case unexpectedSavedInfoData = "unexpectedSavedInfoData"
    case unexpectedItemData = "unexpectedItemData"
    case unhandledError = "unhandledError"
}

struct KeychainItem {
    /// 要儲存的對象 App
    let service : String
    let accessGroup : String?
    /// 要儲存的 Key
    private(set) var account : String
    
    //MARK:- Init
    init(service : String , account : String , accessGroup : String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
}
extension KeychainItem {
    /// 讀取 Item
    public func readItem() throws -> Data{
        var query = self.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        var queryResult : AnyObject?
        // 將 取得的 Keychain Data Pointer 放入 queryResult 的 Pointer (c 的 Pointer 概念)
        let status = withUnsafeMutablePointer(to: &queryResult) {
            // 從 Keychain 中取得該 Query 所指向的 Data
            // UnsafeMutablePointer : Data 的 Pointer
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        guard status != errSecItemNotFound else {
            throw KeychainError.noSavedInfo
        }
        guard status == noErr else {
            throw KeychainError.unhandledError
        }
        guard
            let exitingItem = queryResult as? [String : AnyObject],
            let resultData = exitingItem[kSecValueData as String] as? Data
        else {
            throw KeychainError.unexpectedSavedInfoData
        }
        return resultData
    }
    public func saveItem(_ itemData : Data) throws {
        do {
            let _ = try readItem()
            // 要更新的 Query items
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = itemData as AnyObject?
            // 已有儲存的 Query items
            let query = self.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            // 將要儲存的 Data 更新到 Keychain
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch  {
            var newQuery = self.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newQuery[kSecValueData as String] = itemData as AnyObject?
            // Key chain 新增 Query
            let status = SecItemAdd(newQuery as CFDictionary, nil)
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }
    /// 刪除指定的 Keychain Query
    func deleteItem() throws {
        let query = self.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
    }
}
extension KeychainItem {
    private func keychainQuery(withService service : String , account : String? = nil , accessGroup : String? = nil) -> [String : AnyObject]{
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        return query
    }
}
