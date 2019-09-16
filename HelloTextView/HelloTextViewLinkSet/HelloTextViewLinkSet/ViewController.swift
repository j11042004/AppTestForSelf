//
//  ViewController.swift
//  HelloTextViewLinkSet
//
//  Created by Uran on 2019/5/13.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var message = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func celear(_ sender: Any) {
        self.textView.text = ""
        self.textView.attributedText = NSAttributedString()
        self.message = ""
    }
    
    @IBAction func addMessage(_ sender: Any) {
        let add = self.message.count % 2 == 0 ? "Hello World " : "Great World "
        self.message.append(add)
        self.handleMessage()
    }
    
    @IBAction func addUrl(_ sender: Any) {
        let add = self.message.count % 2 == 0 ? "https://www.google.com.tw/ " : "https://www.apple.com/tw/ "
        self.message.append(add)
        self.handleMessage()
    }
    func handleMessage(){
        let attributeStr = NSMutableAttributedString(string: self.message)
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor.red]
        let range = NSRange(location: 0, length: self.message.count)
        attributeStr.addAttributes(attributes, range: range)
        
        // 進行正則表達式取出聊天內容中的圖片資訊
        let parten = "https://[a-zA-Z0-9\\../_?=&%-]+"
        let regex = try? NSRegularExpression(pattern: parten, options: .caseInsensitive)
        // 取得符合正則表達式的結果
        let regexResults = regex?.matches(in: self.message, options: NSRegularExpression.MatchingOptions.reportProgress, range: range)
        // 判斷結果是否為 nil 或 count 為 0
        guard var results = regexResults ,
            results.count != 0
            else {
                self.textView.attributedText = attributeStr
                return
        }
        results.reverse()
        
        /// 聊天訊息
        let chatMessage = NSString(string: self.message)
        for result in results{
            let urlRange = result.range
            let urlStr = chatMessage.substring(with: urlRange)
            guard let url = URL(string: urlStr) else {continue}
            attributeStr.addAttributes([NSAttributedString.Key.link : url], range: urlRange)
            
        }
        let linkAttribute : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor.green , NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        self.textView.attributedText = attributeStr
        self.textView.linkTextAttributes = linkAttribute
    }
}

