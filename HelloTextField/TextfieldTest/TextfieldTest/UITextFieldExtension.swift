//
//  UITextField+ChangeFont.swift
//  TextfieldTest
//
//  Created by Uran on 2018/4/30.
//  Copyright © 2018年 Uran. All rights reserved.
//

import Foundation
import UIKit

public typealias KeyboardComplete = (_ keyboardSize:CGSize)->Void
extension UITextField{
    /// 隨者文字輸入多寡更換字體大小
    ///
    /// - Parameter sender: TextField
    @objc public func changeFontSizeWhenOverFrame(_ sender : UITextField){
        guard let text = self.text as NSString? else {
            return
        }
        guard let font = self.font else {
            return
        }
        // 計算字串 Size
        var wordSize = self.calculatorWordsSize(With: text, font: font)
        let width = self.frame.size.width
        // 若是字串寬大於 TextField 寬，縮小字型
        while wordSize.width > width {
            guard let changedfont = self.font else {
                break
            }
            let fontSize = changedfont.pointSize - 0.5
            if fontSize < 10 {
                break
            }
            // 重新計算字串 Size
            self.font = UIFont(name: font.fontName, size: fontSize)
            wordSize = self.calculatorWordsSize(With: text, font: self.font!)
        }
        // 若是字串寬小於 TextField 寬，放大字型
        while wordSize.width < width {
            guard let changedfont = self.font else {
                break
            }
            let fontSize = changedfont.pointSize + 0.5
            if fontSize > 14 {
                break
            }
            // 重新設定字體大小
            self.font = UIFont(name: font.fontName, size: fontSize)
            // 重新計算字串 Size
            wordSize = self.calculatorWordsSize(With: text, font: self.font!)
        }
    }
    /// 計算字串的長寬
    ///
    /// - Parameters:
    ///   - text: 字串，NSString
    ///   - font: 字型，UIFont
    /// - Returns: Size
    private func calculatorWordsSize(With text : NSString , font : UIFont) -> CGSize{
        let attributes : [NSAttributedStringKey : Any] = [NSAttributedStringKey.font : font]
        let size = text.size(withAttributes: attributes)
        return size
    }
    
    /// 通知 keyboard 將要出現
    ///
    /// - Parameter Complete: 通知後要做的事情
    public func notificationKeyboardWillShow(Complete:@escaping KeyboardComplete){
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo else{
                return
            }
            // 取得鍵盤 Value
            guard let keyboardValue =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else{
                return
            }
            let keyboardFrame = keyboardValue.size
            DispatchQueue.main.async {
                Complete(keyboardFrame)
            }
        }
    }
    
    /// 通知 keyboard 將要消失
    ///
    /// - Parameter Complete: 通知後要做的事情
    public func notificationKeyboardWillHide(Complete:@escaping KeyboardComplete){
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
            let zeroSize = CGSize.zero
            DispatchQueue.main.async {
                Complete(zeroSize)
            }
        }
        
    }
}

