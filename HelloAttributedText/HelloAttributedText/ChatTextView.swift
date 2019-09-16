//
//  ChatTextView.swift
//  HelloAttributedText
//
//  Created by Uran on 2019/3/12.
//  Copyright © 2019 WalkGame. All rights reserved.
//

import UIKit

class ChatTextView: UITextView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event)
        // 判斷點擊到的地方是否為 link，若不是就 return Cell
        let charaterIndex = self.layoutManager.characterIndex(for: point, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if let _ = self.textStorage.attribute(NSAttributedString.Key.link, at: charaterIndex, effectiveRange: nil){
            return self
        }
        return nil
    }
}
