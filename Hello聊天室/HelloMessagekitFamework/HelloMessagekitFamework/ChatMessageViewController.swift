//
//  ViewController.swift
//  HelloMessagekitFamework
//
//  Created by Uran on 2018/6/22.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import MessageKit
import CoreLocation
import MapKit
class ChatMessageViewController: MessagesViewController {
    
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 設定 messageInputBar 的類型
        self.customerMessageBar()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
// MARK: - MessagesDataSource
// 處理 訊息數量 與 User
extension ChatMessageViewController : MessagesDataSource{
    func currentSender() -> Sender {
        let sender : Sender = Sender(id: "1111111", displayName: "HelloMan")
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    // 要重寫 MessageCollectionView 中的 numberOfItemsInSection 與 numberOfSections 才可以使用 CollectionView Reload
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return messages.count
    }
    
    // 在 Cell 的上方顯示文字
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        let attributeDict = [
            NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)
        ]
        return NSAttributedString(string: name, attributes: attributeDict)
    }
    // 在 Cell 的下方顯示 文字
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = message.sentDate.string
        let attributeDict = [
            NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)
        ]
        let attributeString = NSAttributedString(string: dateString, attributes: attributeDict)
        return attributeString
    }
    
    
}

// MARK: - MessagesDisplayDelegate
extension ChatMessageViewController : MessagesDisplayDelegate{
    // 文字訊息的顏色
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        // 判斷是否來自 User 傳送決定 訊息顏色
        let fromSender =  isFromCurrentSender(message: message)
        return fromSender ? .white : .black
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedStringKey : Any] {
        return MessageLabel.defaultAttributes
    }
    // 顯示在 Message 上的類型
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date]
    }
    // Message 的背景顏色
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .lightGray : .green
    }
    // 判斷是 Message 是要顯示在左邊還是右邊
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner : MessageStyle.TailCorner = isFromCurrentSender(message: message) ? MessageStyle.TailCorner.bottomRight : MessageStyle.TailCorner.bottomLeft
        
        return MessageStyle.bubbleTail(corner, MessageStyle.TailStyle.curved)
    }
    
    // 顯示 大頭貼照
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatarImage = UIImage(named: "avatar.jpg")
        let avatar = Avatar(image: avatarImage, initials: "name")
        avatarView.set(avatar: avatar)
    }
    
    // MARK: - Location Messages
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
       
        // 把 message data 中的
        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
        
        // 設定大頭針圖片
        let pinImage : UIImage = UIImage(named: "pin.png")!
        annotationView.image = pinImage
        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
        
        return annotationView
    }
    
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
        return { view in
            view.layer.transform = CATransform3DMakeScale(0, 0, 0)
            view.alpha = 0.0
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                view.layer.transform = CATransform3DIdentity
                view.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        
        return LocationMessageSnapshotOptions(showsBuildings: true, showsPointsOfInterest: true, span: MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1), scale: 0.1)
    }
}




// MARK: - MessagesLayoutDelegate
extension ChatMessageViewController: MessagesLayoutDelegate {
    // 顯示 Message location Cell 的高度
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return messagesCollectionView.frame.size.height / 4
    }
    
    
    private func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 {
            return 10
        }
        return 20
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
}

// MARK: - MessageCellDelegate

extension ChatMessageViewController: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
        guard let index = messagesCollectionView.indexPath(for: cell) else{
            return
        }
        let message = messages[index.section]
        
    }
    
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
}

// MARK: - MessageLabelDelegate
// 當一些特殊的被選到時
extension ChatMessageViewController: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
}



// MARK: - MessageInputBarDelegate
extension ChatMessageViewController: MessageInputBarDelegate {
    // 當 messageInputBar Send Button 被按時會觸發
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Each NSTextAttachment that contains an image will count as one empty character in the text: String
        
        for component in inputBar.inputTextView.components {
            
            if let image = component as? UIImage {
                //MARK: Fix: 加到 Messages 中
                messagesCollectionView.reloadData()
            } else if let text = component as? String {
                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
                // 要被送到訊息的 data
                let data = MessageData.attributedText(attributedText)
                
                var sender : Sender!
                if messages.count % 2 == 0{
                    sender = Sender(id: "1111111", displayName: "HelloMan")
                }else{
                    sender = Sender(id: "1111112", displayName: "HelloWoman")
                }
                
                let newMessage = Message(sender: sender, date: Date(), messageID: "1", data: data)
                
                self.messages.append(newMessage)
                // 因 messageCollectionView 是讀取 Section 所以不能用 collectionView reload
                // 除非重新設定 CollectionView numberOfsection 與 numberOfItemInSection
//                messagesCollectionView.insertSections([messages.count - 1])
                messagesCollectionView.reloadData()
            }
        }
        
        inputBar.inputTextView.text = ""
        messagesCollectionView.scrollToBottom()
    }
    
}
