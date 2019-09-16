//
//  ViewController.swift
//  JKSQMessage
//
//  Created by Uran on 2017/11/21.
//  Copyright © 2017年 Uran. All rights reserved.
//  若出現 collectionView 出現 datasource 方法要回傳 cell 時，把那個方法刪除，否則畫面不會顯是對話框
//  indexPath.中，item 建議用在 collectionView，row 建議用在 TableView

import UIKit
import JSQMessagesViewController

class JSQChatViewController: JSQMessagesViewController,UIActionSheetDelegate{
    let bubbleFactory = JSQMessagesBubbleImageFactory()
    var incomingBubble : JSQMessagesBubbleImage?
    var outgoingBubble : JSQMessagesBubbleImage?
    var userOutgoingAvatar : JSQMessagesAvatarImage?
    var chatterIncomingAvatar : JSQMessagesAvatarImage?
    var messages : [JSQMessage?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 設定ID 與 使用者名字
        self.senderId = "aaa"
        self.senderDisplayName = "fgfgf"
        
        
        // 設定接收與發送訊息的泡泡
        incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleRed())
        outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        // 給予對話者一個頭像
        chatterIncomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "設定.png"), diameter: 64)
        userOutgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "car.png"), diameter: 64)
        // 設定navigationBar上的title
//        self.title = "chat"
        // 隱藏 tabBar 避免擋到輸入框
//        self.tabBarController?.tabBar.isHidden = true
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
/*
        // 新增滑動手勢
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(showGameResult))
        // 設定滑動的起始位址（即由左往右滑）
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.left
        self.collectionView.addGestureRecognizer(swipeRightGesture)
*/
    }
    override func viewDidAppear(_ animated: Bool) {
        // 必須再呼叫一次父類別中的方法，輸入框才會隨者鍵盤移動，否則不會
        super.viewDidAppear(true)
    }
    @objc func showGameResult(){
        NSLog("showGameResult")
    }
    //MARK: 模擬接收訊息
    func receiveAutoMessage() {
        //觸發一秒後發送訊息模擬是對方發送
        let laterOneSec = DispatchTime.now()+1
        DispatchQueue.main.asyncAfter(deadline: laterOneSec) {
            self.didFinishMessageTimer()
        }
    }
    // 接收訊息與發送訊息的方法
    @objc func didFinishMessageTimer(){
        // 播放收到訊息的效果音
        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
        // 建立要回傳訊息的資訊
        let sendBackMsg = JSQMessage(senderId: "TestBackID",
                                     displayName: "TestBackName",
                                     text: "TestBackName receive and send back.")
        messages.append(sendBackMsg)
        //處理完接收訊息後必須呼叫該方法，該方法會做一些畫面處理及更新資料，填入的參數是用來決定將畫面移動到最下面是否要動畫
        self.finishReceivingMessage(animated: true)
    }
}
// MARK: - JSQmessage 必要的 Function
extension JSQChatViewController {
    //點擊發送訊息鈕時，會觸發該方法
    override func didPressSend(_ button: UIButton,
                               withMessageText text: String,
                               senderId: String,
                               senderDisplayName: String,
                               date: Date) {
        for _ in 0..<500{
            //發送訊息時使用預設音(選用)
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
            
            //將必要資訊包裝成一個訊息物件
            let message = JSQMessage(senderId: self.senderId,
                                     senderDisplayName: self.senderDisplayName,
                                     date: Date(),
                                     text: text)
            
            messages.append(message)
            //處理完發送訊息後必須呼叫該方法，該方法會做一些畫面處理及更新資料，填入的參數是用來決定將畫面移動到最下面是否要動畫
            self.finishSendingMessage(animated: true)
            //以下方法跟上面相同，差別是將畫面移動到最下面是有動畫的
            //self.finishSendingMessage()
            
            self.view.endEditing(true)
            
            //模擬收到訊息用
            receiveAutoMessage()
        }
    }
    //下方功能鍵
    override func didPressAccessoryButton(_ sender: UIButton!) {
        self.inputToolbar.contentView.textView.resignFirstResponder()
        let sheetAlert = UIAlertController(title: "Media messages",
                                           message: nil,
                                           preferredStyle: UIAlertControllerStyle.actionSheet)
        let sendPhoto = UIAlertAction(title: "傳送圖片",
                                      style: UIAlertActionStyle.default) { (action) in
                                            NSLog("傳送圖片")
        }
        let cancel = UIAlertAction(title: "cancel",
                                   style: UIAlertActionStyle.cancel,
                                   handler: nil)
        sheetAlert.addAction(sendPhoto)
        sheetAlert.addAction(cancel)
        
        // sheet alert 在ipad 上要避免的問題，不加這行下兩行會當
        sheetAlert.popoverPresentationController?.sourceView = self.view
        sheetAlert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: self.view.frame.maxY, width: 100, height: 100)
        
        self.present(sheetAlert, animated: true, completion: nil)
    }
// MARK: - JSQMessagesViewController DataSource Function
/*
    func senderDisplayName() -> String? {
        return ""
    }
*/
/*
    func senderId() -> String? {
        return ""
    }
*/
//  JSQCollectionView 內訊息 Cell 的數目
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView?,
                                 messageDataForItemAt indexPath: IndexPath) -> JSQMessageData? {
        return messages[indexPath.item]
    }
    
/*
    // 刪除message
    override func collectionView(_ collectionView: JSQMessagesCollectionView?,
                                 didDeleteMessageAt indexPath: IndexPath) {

    }
*/
//  回傳與告知對話框的顏色
    //Q: 若出錯，回傳值可考慮改成JSQMessageBubbleImageDataSource，不在可回傳nil
    override func collectionView(_ collectionView: JSQMessagesCollectionView,
                                 messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource? {
        let message = messages[indexPath.item]
        guard let sendId = message?.senderId else {
            return nil
        }
        if sendId == self.senderId {
            return outgoingBubble
        }
        return incomingBubble
    }
    
//  使用者與聊天者的頭像
    //Q: 若出錯，回傳值可考慮改成JSQMessageAvatarImageDataSource，不在可回傳nil
    override func collectionView(_ collectionView: JSQMessagesCollectionView?,
                                 avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = messages[indexPath.row]
        guard let sendId = message?.senderId else {
            return nil
        }
        if sendId == self.senderId {
            return userOutgoingAvatar
        }
        return chatterIncomingAvatar
    }
}
extension JSQChatViewController {
//  顯示時間戳
    override func collectionView(_ collectionView: JSQMessagesCollectionView?,
                                 attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.row % 3 == 0{
            guard let message = messages[indexPath.row] else{
                return nil
            }
            /**
             *  設定條件顯示時間戳，此例是以每三次就顯示一條時間戳
             *  不想顯示則return nil
             */
            let time = JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
            return time
        }
        return nil
    }
//  chat bubble 上方 label(Cell上) 的高度，一般與時間戳配合
    override func collectionView(_ collectionView: JSQMessagesCollectionView,
                                 layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout,
                                 heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  不想顯示高度填0
         */
//        if indexPath.item % 3 == 0 {
//            return kJSQMessagesCollectionViewCellLabelHeightDefault
//        }
        return 0.0
    }
    
//  顯示發訊息者的名字
    override func collectionView(_ collectionView: JSQMessagesCollectionView,
                                 attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        guard let message = messages[indexPath.item] else {
            return nil
        }
        // 拿到發訊息者的名字
        let senderName = NSAttributedString(string: message.senderDisplayName)
        
        // 判斷訊息的Id 是否為使用者的Id
        if message.senderId == self.senderId {
//            return nil
            return senderName
        }
        return senderName
    }
    
//  決定名字 UILabel (bubble上Label)的高度
    override func collectionView(_ collectionView: JSQMessagesCollectionView,
                                 layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout,
                                 heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  不想顯示高度填0
         */
        guard let message = messages[indexPath.item] else {
            return 0.0
        }
        guard let sendId = message.senderId else {
            return 0.0
        }
        if sendId == self.senderId {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}

// 泡泡框附近 Label 空間的設定
extension JSQChatViewController {
//  泡泡框下面還有一塊UILabel空間，這個方法是決定那塊UILabel要顯示什麼
    override func collectionView(_ collectionView: JSQMessagesCollectionView,
                                 attributedTextForCellBottomLabelAt indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
// 泡泡框下方的Label 的高度
    func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleBottomLabelAt indexPath: IndexPath) -> CGFloat {
        return 0.0
    }

}

extension JSQChatViewController {
//MARK: - 一些觸碰到畫面的方法
    override func collectionView(_ collectionView: JSQMessagesCollectionView, header headerView: JSQMessagesLoadEarlierHeaderView, didTapLoadEarlierMessagesButton sender: UIButton) {
        NSLog("讀取較早的訊息")
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView, didTapAvatarImageView avatarImageView: UIImageView, at indexPath: IndexPath) {
        NSLog("點擊頭像時要做的事")
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView, didTapMessageBubbleAt indexPath: IndexPath) {
        NSLog("點到對話框時的方法")
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView, didTapCellAt indexPath: IndexPath, touchLocation: CGPoint) {
        self.view.endEditing(true)
        NSLog("現在觸碰到 \(indexPath.item) Cell，\(touchLocation) 座標")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

    

// MARK: - 適配 IphoneX 的畫面
extension JSQMessagesInputToolbar {
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if self.window?.safeAreaLayoutGuide != nil {
                self.bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow((self.window?.safeAreaLayoutGuide.bottomAnchor)!, multiplier: 1.0).isActive = true
            }
        }
    }
}

