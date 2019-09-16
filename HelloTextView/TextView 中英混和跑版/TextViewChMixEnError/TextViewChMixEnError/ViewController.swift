//
//  ViewController.swift
//  TextViewChMixEnError
//
//  Created by Uran on 2018/12/24.
//  Copyright © 2018 WalkGame. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
    }
}

extension ViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        // 避免 中文 注音殘留
        if let selectRange = textView.markedTextRange ,
            let newText = textView.text(in: selectRange) ,
            newText.count > 0{
            return
        }
        // 不讓 英文會因為 留下的文字空間不夠而換行
        guard let text = textView.text else {
            return
        }
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        // 設定 以每個 字元為單位顯示 在 TextView
        paragraphStyle.lineBreakMode = .byCharWrapping
        let attributes : [NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: 14) , .paragraphStyle : paragraphStyle]
        
        textView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
