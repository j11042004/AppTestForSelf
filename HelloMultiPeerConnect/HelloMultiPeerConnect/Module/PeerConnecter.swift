//
//  PeerConnecter.swift
//  HelloMultiPeerConnect
//
//  Created by Uran on 2020/3/30.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit
import MultipeerConnectivity
enum Result<T> {
    case success(T)
    case fail(Error)
}
typealias SessionCompletion<T> = (Bool , T?) -> Void

protocol PeerConnecterDelegate : AnyObject {
    func peerConnecterFoundNewPeer()
    func peerConnecterLostPeer()
    func peerConnecterInvittationReceived(peer : MCPeerID, for session : MCSession?, receiveHandler : @escaping SessionCompletion<MCSession>)
    func peerConnecterConnectdWith(peer peerId : MCPeerID)
}

class PeerConnecter: NSObject {
    static let shared = PeerConnecter()
    public weak var delegate : PeerConnecterDelegate?
    
    private var session : MCSession?
    public private(set) var peer : MCPeerID?
    private var browser : MCNearbyServiceBrowser?
    private var advertiser : MCNearbyServiceAdvertiser?
    public private(set) var findPeers : [MCPeerID] = [MCPeerID]()
    
    public private(set) var isAdvertising : Bool = false
    public private(set) var isBrowsing : Bool = false
    public var invitationHandler : SessionCompletion<MCSession>?
    var receiveMsgHandle : ((Data , MCPeerID) -> Void)?
    
    // 最常只能 15 個字
    let serviceType = "peer-chat"
    override init() {
        super.init()
    }
    public func set(name : String){
        // 顯示的使用者名稱
        peer = MCPeerID(displayName: name)
        session = MCSession(peer: peer!)
        session?.delegate = self
        // serviceType : 識別此 App 回應的 Type
        browser = MCNearbyServiceBrowser(peer: peer!, serviceType: serviceType)
        browser?.delegate = self
        // discoveryInfo：在探索其他裝置並連上時，給他人的資訊
        advertiser = MCNearbyServiceAdvertiser(peer: peer!, discoveryInfo: nil, serviceType: serviceType)
        advertiser?.delegate = self
    }
    
    // 瀏覽與停止瀏覽其他 Peers
    public func startBrowsing(){
        self.browser?.startBrowsingForPeers()
        self.isBrowsing = true
    }
    public func stopBrowsing(){
        self.browser?.stopBrowsingForPeers()
        self.isBrowsing = false
    }
    
    // 發佈狀態
    /// 讓其餘的使用者可以搜尋到你的狀態
    public func startAdvertise(){
        self.advertiser?.startAdvertisingPeer()
        self.isAdvertising = true
    }
    /// 停止讓其餘的使用者可以搜尋到你的狀態
    public func stopAdvertise(){
        self.advertiser?.stopAdvertisingPeer()
        self.isAdvertising = false
    }
    
    
    /// 邀請附近的 Peer
    /// - Parameters:
    ///   - peer: 要邀請的 Peer
    ///   - info: 邀請時附帶的訊息
    public func invite(peer : MCPeerID , with info : Data?){
        guard self.session != nil
        else {
            return
        }
        self.browser?.invitePeer(peer, to: session!, withContext: info, timeout: 20)
    }
    
    // session Disconnect
    public func sessionDisconnect(){
        self.session?.disconnect()
    }
    public func sendMessage(dataDict : [String : Any], to peer : MCPeerID){
        do {
            let sendData = try  JSONSerialization.data(withJSONObject: dataDict, options: .fragmentsAllowed)
            try session?.send(sendData, toPeers: [peer], with: .reliable)
        } catch  {
            
        }
    }
}

extension PeerConnecter : MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            self.delegate?.peerConnecterConnectdWith(peer: peerID)
            break
        case .connecting:
            NSLog("正在連線中")
            break
        case .notConnected:
            NSLog("未連線中")
            break
        default :
            NSLog("其他連線狀態")
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.receiveMsgHandle?(data , peerID)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}
extension PeerConnecter : MCNearbyServiceBrowserDelegate {
    // 尋找到其他的 Peer
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        self.findPeers.append(peerID)
        delegate?.peerConnecterFoundNewPeer()
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index , peer) in findPeers.enumerated(){
            if peer == peerID {
                findPeers.remove(at: index)
                break
            }
        }
        delegate?.peerConnecterLostPeer()
    }
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("為瀏覽到其餘 Peer error : \(error.localizedDescription)")
    }
}
extension PeerConnecter : MCNearbyServiceAdvertiserDelegate{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        if let inviteData = context {
            
        }
        self.delegate?.peerConnecterInvittationReceived(peer: peerID, for: self.session, receiveHandler: invitationHandler)
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("邀請時遇到的 error : \(error.localizedDescription)")
    }
    
}
