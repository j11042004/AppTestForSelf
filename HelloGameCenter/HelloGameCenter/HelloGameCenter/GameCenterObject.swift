//
//  GameCenterObject.swift
//  HelloGameCenter
//
//  Created by Uran on 2017/12/27.
//  Copyright © 2017年 Uran. All rights reserved.
//

import UIKit
import GameKit
protocol GCODelegate {
    func showAuthViewController(_ willshowViewController:UIViewController)
    func getUserGameCenterInfo(_ gameCenterInfo:[[String:Any]])
    func gameCenterVCDidFinished(_ viewController:UINavigationController)
}
class GameCenterObject: NSObject,GKGameCenterControllerDelegate {
    
    
    // singleton
    private static var instance:GameCenterObject?
    static func sharedInstance() -> GameCenterObject {
        if instance == nil {
            instance = GameCenterObject()
        }
        return instance!
    }
    var delegate : GCODelegate?
    
    // 取得 gameCenter 的要求
    func getGameCenterAuthorize(){
        let localPlayer = GKLocalPlayer.localPlayer()
        // 照者 authenticateHandler 的 block type 把它展開
        localPlayer.authenticateHandler = {
            (viewController , error) in
            if let error = error{
                NSLog("Auth error : \(error.localizedDescription)")
            }
            if let viewController = viewController {
                DispatchQueue.main.async {
                    self.delegate?.showAuthViewController(viewController)
                }
            }
            print("localPlayer auth: \(localPlayer.isAuthenticated)")
        }
    }
    // 傳送 分數
    func sendScoreToGameCenter(number: Int){
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreRepoter = GKScore(leaderboardIdentifier: "iOS.best.score")
            scoreRepoter.value = Int64(number)
            let scoreArray : [GKScore] = [scoreRepoter]
            GKScore.report(scoreArray, withCompletionHandler: { (error) in
                if let error = error{
                    NSLog("report error:\(error.localizedDescription)")
                    return
                }
                NSLog("report success")
                
                self.getUserLeadBoardInfo()
            })
            
        }
    }
    // 取得排行榜所有成員資料
    func getLeaderBoardInfo(){
        let leadBoardRequest = GKLeaderboard()
        // 排行榜資料設定： id，玩家範圍，時間，rank 範圍
        leadBoardRequest.identifier = "iOS.best.score"
        leadBoardRequest.playerScope = GKLeaderboardPlayerScope.global
        leadBoardRequest.timeScope = GKLeaderboardTimeScope.allTime
        leadBoardRequest.range = NSRange(location: 1,length: 10)
        leadBoardRequest.loadScores { (scores, error) in
            if let error = error{
                NSLog("error :\(error.localizedDescription)")
                return
            }
            guard let playerScores = scores else{
                NSLog("scores is nil")
                return
            }
            var allPlayer = [[Dictionary<String, Any>]()]
            // 避免預設的[:]
            allPlayer.removeAll()
            if playerScores.count != 0 {
                // 取得所有玩家的資料
                for player in playerScores{
                    
                    var playerInfo = [Dictionary<String, Any>()]
                    // 避免預設的[:]
                    playerInfo.removeAll()
                    
                    if let playerID = player.player?.playerID {
                        playerInfo.append(["playerID":playerID])
                    }
                    if let playerNickName = player.player?.alias{
                        playerInfo.append(["playerNickName":playerNickName])
                    }
                    let playerRank = player.rank
                    playerInfo.append(["playerRank":playerRank])
                    let playerValue = player.value
                    playerInfo.append(["playerValue":playerValue])
                    if let formattedValue = player.formattedValue{
                        playerInfo.append(["formattedValue":"\(formattedValue)"])
                    }
                    allPlayer.append(playerInfo)
                    
                }
                // 將 dictionary 轉成 json
                self.changeToJson(value: allPlayer)
                
            }else{
                NSLog("not have member")
            }
            
        }
        
    }
    // 轉成 json
    func changeToJson(value:Any){
        // 判斷是否能轉
        if !JSONSerialization.isValidJSONObject(value) {
            return
        }
        // 轉成 data
        var jsonData = Data()
        do{
            jsonData = try JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions.prettyPrinted)
        }catch {
            NSLog("error")
            
        }
        
        // 轉成 dictionary [[[String:Any]]]
        do {
            let result = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
            guard let dictResult = result as? [[[String:Any]]] else {
                NSLog("change fail")
                return
            }
            print("result:\(dictResult)")
        } catch {
            NSLog("change error")
        }
        
    }
    // 取得自己在gameCenter 上的排行榜資料
    func getUserLeadBoardInfo(){
        let leaderBoard : GKLeaderboard = GKLeaderboard()
        leaderBoard.identifier = "iOS.best.score"
        leaderBoard.loadScores { (scores, error) in
            if let error = error{
                NSLog("leaderBoard load error : \(error.localizedDescription)")
                return
            }
            guard let scores = scores else{
                return
            }
            
            if scores.count > 0 {
                // 把資訊加入 [[String:Any]]再回傳
                var playerInfo = [[String:Any]]()
                // 避免預設的[:]
                playerInfo.removeAll()
                let localPlayer = leaderBoard.localPlayerScore
                if let playerID = localPlayer?.player?.playerID {
                    playerInfo.append(["playerID":playerID])
                }
                if let playerNickName = localPlayer?.player?.alias{
                    playerInfo.append(["playerNickName":playerNickName])
                }
                if let playerRank = localPlayer?.rank{
                    playerInfo.append(["playerRank":playerRank])
                }
                if let playerValue = localPlayer?.value {
                    playerInfo.append(["playerValue":playerValue])
                }
                if let formattedValue = localPlayer?.formattedValue{
                    playerInfo.append(["formattedValue":"\(formattedValue)"])
                }
                
                DispatchQueue.main.async {
                    NSLog("info:\(playerInfo)")
                    self.delegate?.getUserGameCenterInfo(playerInfo)
                }
            }else{
                NSLog("scores element is 0")
            }
        }
    }
    func showGameCenterVC(){
        let nowVC = UIApplication.shared.keyWindow?.rootViewController
        let gameCenterVC = GKGameCenterViewController()
        gameCenterVC.gameCenterDelegate = self;
        
        nowVC?.present(gameCenterVC, animated: true, completion: nil)
    }
    // GKGameCenterViewController
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        delegate?.gameCenterVCDidFinished(gameCenterViewController)
    }
}
