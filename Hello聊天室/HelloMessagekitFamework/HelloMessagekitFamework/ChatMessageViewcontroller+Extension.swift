//
//  ChatMessageViewcontroller+Extension.swift
//  HelloMessagekitFamework
//
//  Created by Uran on 2018/6/22.
//  Copyright © 2018年 Uran. All rights reserved.
//

import Foundation
import MessageKit
import CoreLocation
import MapKit
import UIKit
extension ChatMessageViewController{
    typealias TouchAction =  (_ item : InputBarButtonItem) -> Void
    // MARK: - Keyboard Style
    func customerMessageBar(){
        self.defaultStyle()
        
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.isTranslucent = false
        messageInputBar.inputTextView.backgroundColor = .red
        messageInputBar.inputTextView.layer.borderWidth = 0
        
        
        // 設定 SendButton 的各個狀態下的情況
        let cameraItem = makeMessageBarItem(with: "相機", imageName: nil) { (item) in
            NSLog("相機")
            let image : UIImage = UIImage(named: "sakura.jpg")!
            let data = MessageData.photo(image)
            
            let sender = Sender(id: "gggggg", displayName: "HelloMan")
            let message = Message(sender: sender, date: Date(), messageID: "2", data: data)
            self.messages.append(message)
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom()
        }
        let tagItem = makeMessageBarItem(with: "Tag", imageName: nil) { (item) in
            NSLog("tag")
            
        }
        let photoItem = makeMessageBarItem(with: "相簿", imageName: nil) { (item) in
            NSLog("相簿")
        }
        let atItem = makeMessageBarItem(with: "在哪", imageName: nil) { (item) in
            NSLog("在哪")
            let location101 = CLLocation(latitude:25.033671 , longitude:121.564427)
            let locationData = MessageData.location(location101)
            
            let sender = Sender(id: "gggggg", displayName: "HelloMan")
            let message = Message(sender: sender, date: Date(), messageID: "2", data: locationData)
            self.messages.append(message)
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom()
        }
        // 設定要新建到 StackView 的 Item
        let items : [InputBarButtonItem] = [
            cameraItem ,
            tagItem,
            atItem,
            InputBarButtonItem.flexibleSpace, // item 間的空白
            photoItem,
        ]
        
        // 送出訊息的 Button 設定
        messageInputBar.sendButton
            .configure { (item) in
                // sendButton 一開始設定
                item.layer.cornerRadius = 8
                item.layer.borderWidth = 1.5
                item.layer.borderColor = item.titleColor(for: .disabled)?.cgColor
                item.setTitleColor(.white, for: .normal)
                item.setTitleColor(.white, for: .highlighted)
                
                item.setSize(CGSize(width: 52, height: 30), animated: true)
            }
            .onDisabled { (item) in // 不可按下的情況
                item.layer.borderColor = item.titleColor(for: .disabled)?.cgColor
                item.backgroundColor = .white
            }
            .onEnabled { (item) in // 可按下的情況
                item.backgroundColor = UIColor.green
                item.layer.borderColor = UIColor.clear.cgColor
            }
            .onSelected { (item) in // 被選擇的情況
                // item 放大 1.2 倍
                item.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            .onDeselected { (item) in // 不被選擇的情況
                // item 變回原本倍率
                item.transform = CGAffineTransform.identity
        }
        
        //
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        
        
        // 因為 Send Item 被移動到 StackView 所以 MessapgeInput bar 要把右邊的 Constraint 設為 0
//        messageInputBar.setRightStackViewWidthConstant(to: 0, animated: true)
       
        // 設定 Item 到 Message Bar 上
        messageInputBar.setStackViewItems(items, forStack: InputStackView.Position.bottom, animated: true)
    }
    
    
    
    /// 原始預設的 MessageBar
    func defaultStyle() {
        let newMessageInputBar = MessageInputBar()
        newMessageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        newMessageInputBar.delegate = self
        messageInputBar = newMessageInputBar
        reloadInputViews()
    }
    
    /// 製作一個 messageBar Item
    ///
    /// - Parameters:
    ///   - name: Item 的 name
    ///   - imageName: Item 的 圖片名
    ///   - touchAction: Item 被按下後會做的事
    /// - Returns: MessageBarItem
    private func makeMessageBarItem(with name: String? ,
                                    imageName : String?,
                                    touchAction : @escaping TouchAction ) -> InputBarButtonItem{
        let item = InputBarButtonItem(type: .custom)
            .configure{ item in
                item.spacing = InputBarButtonItem.Spacing.fixed(10)
                if let imgName = imageName ,
                    let image = UIImage(named: imgName){
                    item.image = image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                }else if let name = name{
                    item.title  = name
                }
                item.setSize(CGSize(width: 30, height: 30), animated: true)
            }
            .onSelected { (item) in
                // Item 被選到時的顏色
                item.tintColor = UIColor.red
            }.onDeselected { (item) in
                // Item 未選到時的顏色
                item.tintColor = UIColor.lightGray
            }.onTouchUpInside { (item) in
                // Item 被按下時 的動作
                touchAction(item)
            }.onTextViewDidChange { (item, textView) in
                // 當 TextView 有文字時，就不可被按
                item.isEnabled = textView.text.isEmpty
        }
        
        return item
    }
    
    
    
    // MARK: - Make MessageBar Item
    private  func makeButton(named: String) -> InputBarButtonItem {
        
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 30, height: 30), animated: true)
            }.onSelected {
                $0.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
            }.onDeselected {
                $0.tintColor = UIColor.lightGray
            }.onTouchUpInside { _ in
                print("Item Tapped")
        }
    }

}
