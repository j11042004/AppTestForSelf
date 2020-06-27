//
//  ViewController.swift
//  HelloMultiPeerConnect
//
//  Created by Uran on 2020/3/30.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    let peerConnecter = PeerConnecter.shared
    let reload = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    var browsingItem : UIBarButtonItem!
    var browseStopItem : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        browsingItem = UIBarButtonItem(title: "搜尋用戶", style: .done, target: self, action: #selector(startStopBrowse))
        browseStopItem = UIBarButtonItem(title: "停止搜尋", style: .done, target: self, action: #selector(startStopBrowse))
        
        self.peerConnecter.delegate = self
        self.setNavigationItem()
    }
    @objc func startStopBrowse() {
        if self.peerConnecter.isBrowsing {
            self.peerConnecter.stopBrowsing()
            self.peerConnecter.stopAdvertise()
            self.setNavigationItem()
            return
        }
        let alert = UIAlertController(title: nil, message: "請輸入暱稱", preferredStyle: .alert)
        alert.addTextField { (textFiled) in
            textFiled.placeholder = "暱稱"
        }
        let sure = UIAlertAction(title: "連線", style: .default) { (_) in
            guard let textField = alert.textFields?.first ,
                let name = textField.text ,
                name.count > 0
            else {return}
            self.peerConnecter.set(name: name)
            self.peerConnecter.startBrowsing()
            self.peerConnecter.startAdvertise()
            self.setNavigationItem()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(sure)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
//MARK:- Private function
extension ViewController {
    private func setNavigationItem(){
        DispatchQueue.main.async {
            var barItems = [UIBarButtonItem]()
            let browseItem : UIBarButtonItem = self.peerConnecter.isBrowsing ? self.browseStopItem : self.browsingItem
            
            barItems.append(browseItem)
            self.navigationItem.rightBarButtonItems = barItems
        }
    }
}
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let peer = self.peerConnecter.findPeers[indexPath.row]
        self.peerConnecter.invite(peer: peer, with: nil)
    }
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peerConnecter.findPeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(self.peerConnecter.findPeers[indexPath.row].displayName)"
        return cell
    }
}
extension ViewController : PeerConnecterDelegate{
    func peerConnecterFoundNewPeer() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func peerConnecterLostPeer() {
        NSLog("一位連線者已斷線")
        self.peerConnecter.sessionDisconnect()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func peerConnecterInvittationReceived(peer: MCPeerID, for session: MCSession?, receiveHandler: @escaping SessionCompletion<MCSession>) {
        let alert = UIAlertController(title: "有新的邀請！！！", message: "\(peer.displayName) 傳送了一個邀請給您", preferredStyle: .alert)
        let accept = UIAlertAction(title: "接受 ", style: .default) { (_) in
            receiveHandler(true , session)
        }
        let cancel = UIAlertAction(title: "不接受", style: .cancel) { (_) in
            receiveHandler(false , nil)
        }
        alert.addAction(accept)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    func peerConnecterConnectdWith(peer peerId: MCPeerID) {
        DispatchQueue.main.async
        {
            NSLog("與 \(peerId.displayName) 連線上了")
            guard let chatVC = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else { return }
            chatVC.connectPeer = peerId
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
        
    }
}
