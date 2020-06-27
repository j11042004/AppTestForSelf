//
//  ChatViewController.swift
//  HelloMultiPeerConnect
//
//  Created by Uran on 2020/4/8.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let peerConnecter = PeerConnecter.shared
    
    var messages : [[String : String]] = [[String : String]]()
    var connectPeer : MCPeerID?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillClose(note:)), name: UIApplication.keyboardWillHideNotification, object: nil)
        peerConnecter.receiveMsgHandle = {
            data , peerId in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let msgJson = json as? [String : String],
                    let newMessage = msgJson["msg"]
                {
                    self.messages.append(["\(peerId.displayName)" : newMessage])
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch  {
                NSLog("get json error : \(error.localizedDescription)")
            }
        }
        
        guard let peer = self.connectPeer else { return }
        let mesDict : [String : Any] = ["msg" : "\(peer.displayName) 上線了" ]
        self.peerConnecter.sendMessage(dataDict: mesDict, to: peer)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.peerConnecter.sessionDisconnect()
    }
    @IBAction func sendMessage(_ sender: Any) {
        guard let message = self.textField.text ,
            let peer = self.connectPeer
        else {
            return
        }
        self.messages.append(["\(self.peerConnecter.peer!.displayName)" : message])
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.peerConnecter.sendMessage(dataDict: ["msg" : message ], to: peer)
        self.textField.text = nil
        self.view.endEditing(true)
    }
}
//MARK:- ObjC function
extension ChatViewController{
    @objc func keyboardWillShow(note : Notification){
        guard
            let infoDict = note.userInfo ,
            let duration = infoDict[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let frame = infoDict[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        self.bottomConstraint.constant = frame.height
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillClose(note : Notification){
        guard
            let infoDict = note.userInfo ,
            let duration = infoDict[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else {
            return
        }
        NSLog("hide duration : \(duration)")
        self.bottomConstraint.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatViewController : UITableViewDelegate{
    
}
extension ChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let message = messages[indexPath.row]
        cell.textLabel?.text = message[message.keys.first!]
        cell.detailTextLabel?.text = message.keys.first
        return cell
    }
}
