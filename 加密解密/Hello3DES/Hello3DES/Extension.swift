//
//  Extension.swift
//  Hello3DES
//
//  Created by Uran on 2018/6/6.
//  Copyright © 2018年 Uran. All rights reserved.
//

import Foundation
import UIKit

extension String{
    // 將 16 進位 String 轉成 [UInt8]
    var hexStringToBytes: [UInt8] {
        let hexa = Array(self)
        let bytes = stride(from: 0, to: count, by: 2).compactMap {
            UInt8(String(hexa[$0..<$0.advanced(by: 2)]), radix: 16)
        }
        return bytes
    }
    
    
    var hexAsciiString : String?{
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        let bytes = [UInt8](data)
        // 取得 ASCII 上 數字 0 所代表的 16 進位值 為 48
        let byteNum0 = 48
        var asciiString : String = ""
        
        
        for index in 0..<bytes.count - 1 {
            
        }
        
        return ""
    }
    func uint8ToHex16(With uint8Array : [UInt8]){
        let byteBase48 = 48
        
        var bytH = 0
        var bytL = 0
        
        var asciiString = ""
        
        // 將Ascii 8 進位轉成Ascii 16 進位
        for index in 0...(uint8Array.count-1) {
            //放 Hi-byte
            bytH = Int(uint8Array[index]/16)
            print("bytH[0] / 16 --> \(bytH)")
            if(bytH > 9) {
                bytH = bytH + byteBase48 + 7
            } else {
                bytH = bytH + byteBase48
            }
            // 轉成 Ascii
            asciiString = asciiString + String(Character(UnicodeScalar(bytH)!))
            
            //放 Low-byte
            bytL = Int(uint8Array[index]%16)
            print("bytL[0] % 16 --> \(bytL)")
            if(bytL > 9) {
                bytL = bytL + byteBase48 + 7
            } else {
                bytL = bytL + byteBase48
            }
            asciiString = asciiString + String(Character(UnicodeScalar(bytL)!))
        }
        print("asciiString : \(asciiString)")
        // 將 String 分割然後轉成 [Hex String]
        var num = 0
        var hex = String()
        var hexArray = [String]()
        for char in asciiString{
            if num == 2 {
                hexArray.append(hex)
                hex = ""
                num = 0
            }
            hex.append(char)
            num += 1
        }
        
        print(hexArray)
    }
}

extension UInt8{
    /// 將 UInt8 轉成 Hex String
    var changeToHexString : String {
        get{
            let num = Int(self)
            // 將 num 轉成 16 進位
            var hexStr = String(format:"%2X", num)
            // 判斷是否有 " " 若有就替換成 "0"
            hexStr = hexStr.replacingOccurrences(of: " ", with: "0")
            return hexStr
        }
    }
}

extension Data{
    // 轉成 16 進位的陣列
    var changeToHexArray: [String] {
        get{
            var hexArray = [String]()
            let octonary = [UInt8](self)
            for element in octonary{
                let hexStr = element.changeToHexString
                hexArray.append(hexStr)
            }
            return hexArray
        }
    }
    var changeToHexString: String {
        get{
            var hex = String()
            let octonary = [UInt8](self)
            for element in octonary{
                let hexStr = element.changeToHexString
                hex.append(hexStr)
            }
            return hex
        }
    }
}
