//
//  ChatTableCell.swift
//  HelloAttributedText
//
//  Created by Uran on 2019/3/12.
//  Copyright © 2019 WalkGame. All rights reserved.
//

import UIKit

class ChatTableCell: UITableViewCell {

    @IBOutlet weak var textView: ChatTextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(message : NSAttributedString , linkAttributes : [NSAttributedString.Key : Any]?){
        self.backgroundColor = .black
        self.contentView.backgroundColor = .black
        self.textView.attributedText = message
        if let linkAttributeStr = linkAttributes {
            self.textView.linkTextAttributes = linkAttributeStr
        }
    }
}
extension ChatTableCell : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:]) { (_) in
            
        }
        return false
    }
}
