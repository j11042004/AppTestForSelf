//
//  TripleDes.swift
//  Hello3DES
//
//  Created by Uran on 2018/6/6.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class TripleDes: NSObject {
    static public let sharedInstance = TripleDes()
    /// password String 是從 randomStringArray中選出
    private var randomStringArray : [Character] = {
        var randomArray = [Character]()
        let randomString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        for char in randomString {
            randomArray.append(char)
        }
        return randomArray
    }()
    
    
    /// 取得指定長度由 a~z A~Z 0~9 隨機組成的password String
    ///
    /// - Parameter length: 指定的長度
    /// - Returns: 隨機組成的String
    public func createRandomKey(_ length:Int) -> String {
        var string = ""
        for _ in (1...length) {
            string.append(randomStringArray[Int(arc4random_uniform(
                UInt32(randomStringArray.count) - 1))])
        }
        return string
    }
    
    
    /// 對 String 3DES 進行加密
    ///
    /// - Parameters:
    ///   - encryptStr: 要加密的字串
    ///   - secretKey: 加密用的密碼
    /// - Returns: 加密完成後的 Data
    public func encryptTo3DES(encryptStr:String , WithKey secretKey : String) -> Data?{
        // 將要加密的字串轉為 Data
        let inputData : Data = encryptStr.data(using: String.Encoding.utf8)!
        // 將要加密的密碼轉為 Data
        let keyData: Data = secretKey.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let keyBytes = UnsafeMutableRawPointer(mutating: (keyData as NSData).bytes)
        let keyLength = size_t(kCCKeySize3DES)
        // 取得 Data 的 長度
        let dataLength = Int(inputData.count)
        let dataBytes = UnsafeRawPointer((inputData as NSData).bytes)
        // 加密後的檔案
        let bufferData = NSMutableData(length: Int(dataLength) + kCCBlockSize3DES)!
        let bufferPointer = UnsafeMutableRawPointer(bufferData.mutableBytes)
        let bufferLength = size_t(bufferData.length)
        var bytesDecrypted = Int(0)
        // 加密後的狀態
        let cryptStatus = CCCrypt(UInt32(kCCEncrypt),
                                  UInt32(kCCAlgorithm3DES),
                                  UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding),
                                  keyBytes,
                                  keyLength,
                                  nil,
                                  dataBytes,
                                  dataLength,
                                  bufferPointer,
                                  bufferLength,
                                  &bytesDecrypted)
        if Int32(cryptStatus) == Int32(kCCSuccess) {
            bufferData.length = bytesDecrypted
            return bufferData as Data
        } else {
            print("加密过程出错: \(cryptStatus)")
            return nil
        }
    }
    
    /// 對 Data 進行 3DES 加密
    ///
    /// - Parameters:
    ///   - encryptData: 要加密的 Data
    ///   - secretKey: 加密用的密碼
    /// - Returns: 加密完成後的 Data
    public func encryptTo3DES(encryptData:Data, WithKey secretKey : String) -> Data?{
        // 將要加密的字串轉為 Data
        let inputData : Data = encryptData
        // 將要加密的密碼轉為 Data
        let keyData: Data = secretKey.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let keyBytes = UnsafeMutableRawPointer(mutating: (keyData as NSData).bytes)
        let keyLength = size_t(kCCKeySize3DES)
        // 取得 Data 的 長度
        let dataLength = Int(inputData.count)
        let dataBytes = UnsafeRawPointer((inputData as NSData).bytes)
        // 加密後的檔案
        let bufferData = NSMutableData(length: Int(dataLength) + kCCBlockSize3DES)!
        let bufferPointer = UnsafeMutableRawPointer(bufferData.mutableBytes)
        let bufferLength = size_t(bufferData.length)
        var bytesDecrypted = Int(0)
        // 加密後的狀態
        let cryptStatus = CCCrypt(UInt32(kCCEncrypt),
                                  UInt32(kCCAlgorithm3DES),
                                  UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding),
                                  keyBytes,
                                  keyLength,
                                  nil,
                                  dataBytes,
                                  dataLength,
                                  bufferPointer,
                                  bufferLength,
                                  &bytesDecrypted)
        if Int32(cryptStatus) == Int32(kCCSuccess) {
            bufferData.length = bytesDecrypted
            return bufferData as Data
        } else {
            print("加密过程出错: \(cryptStatus)")
            return nil
        }
    }
    
    
    /// 進行解密
    ///
    /// - Parameter inputData: 要解密的 Data
    
    
    /// 進行 3DES 解密
    ///
    /// - Parameters:
    ///   - inputData: 要解密的 Data
    ///   - secretKey: 解密用的密碼，要與 加密時的密碼相同
    /// - Returns: 解密完成的 Data?
    public func decrypt3DES(inputData : Data ,WithKey secretKey : String) -> Data?{
        let keyData: Data = secretKey.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let keyBytes = UnsafeMutableRawPointer(mutating: (keyData as NSData).bytes)
        let keyLength = size_t(kCCKeySize3DES)
        let dataLength = Int(inputData.count)
        let dataBytes = UnsafeRawPointer((inputData as NSData).bytes)
        
        // 解密的檔案
        let bufferData = NSMutableData(length: Int(dataLength) + kCCBlockSize3DES)!
        let bufferPointer = UnsafeMutableRawPointer(bufferData.mutableBytes)
        let bufferLength = size_t(bufferData.length)
        var bytesDecrypted = Int(0)
        
        let cryptStatus = CCCrypt(UInt32(kCCDecrypt),
                                  UInt32(kCCAlgorithm3DES),
                                  UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding),
                                  keyBytes,keyLength,
                                  nil,
                                  dataBytes,
                                  dataLength,
                                  bufferPointer,
                                  bufferLength,
                                  &bytesDecrypted)
        
        if Int32(cryptStatus) == Int32(kCCSuccess) {
            bufferData.length = bytesDecrypted
            let returnData = bufferData as Data
            return returnData
        } else {
            print("解密过程出错: \(cryptStatus)")
            return nil
        }
    }
}
