//
//  ViewController.swift
//  HelloGameCenter
//
//  Created by Uran on 2017/12/25.
//  Copyright © 2017年 Uran. All rights reserved.
//  排行榜未做

import UIKit
import GameKit
class ViewController: UIViewController,GKGameCenterControllerDelegate {
    
    
    var numLabel : UILabel = UILabel()
    var addBtn : UIButton = UIButton()
    var gamerBtn : UIButton = UIButton()
    var leaderBoardBtn : UIButton = UIButton()
    var playerInfoTextView : UITextView = UITextView()
    var waitingView : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var backGroundView : UIView = UIView()
    
    
    let userDefaults = UserDefaults.standard
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        count = userDefaults.integer(forKey: "count")
        
        let highScore = userDefaults.integer(forKey: "count")
        
        numLabel = UILabel(frame: CGRect(x: (self.view.frame.width-self.view.frame.width/2)/2, y: 50, width: self.view.frame.width/2, height: 50))
        numLabel.backgroundColor = UIColor.green
        numLabel.textAlignment = NSTextAlignment.center
        numLabel.text = "\(highScore)"
        
        addBtn = UIButton(frame: CGRect(x: (self.view.frame.width-self.view.frame.width/2)/2, y: 125, width: self.view.frame.width/2, height: 50))
        addBtn.setTitle("add", for: .normal)
        addBtn.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        
        gamerBtn = UIButton(frame: CGRect(x: (self.view.frame.width-self.view.frame.width/2)/2, y: 250, width: self.view.frame.width/2, height: 50))
        gamerBtn.setTitle("game Center", for: .normal)
        gamerBtn.addTarget(self, action: #selector(gamerBtnAction), for: .touchUpInside)
        
        leaderBoardBtn = UIButton(frame: CGRect(x: (self.view.frame.width-self.view.frame.width/2)/2, y: 325, width: self.view.frame.width/2, height: 50))
        leaderBoardBtn.setTitle("排行榜資訊", for: .normal)
        leaderBoardBtn.addTarget(self, action: #selector(getUserLeadBoardInfo), for: .touchUpInside)
        
        playerInfoTextView = UITextView.init(frame: CGRect(x: 10, y: leaderBoardBtn.frame.maxY+10, width: self.view.frame.width-20, height: (self.view.frame.size.height - leaderBoardBtn.frame.maxY-30)))
        playerInfoTextView.backgroundColor = UIColor.gray
        playerInfoTextView.isEditable = false
        playerInfoTextView.isSelectable = true
        playerInfoTextView.font = UIFont.systemFont(ofSize: 16)
        
        self.view.addSubview(numLabel)
        self.view.addSubview(addBtn)
        self.view.addSubview(gamerBtn)
        self.view.addSubview(leaderBoardBtn)
        self.view.addSubview(playerInfoTextView)
        
        
        self.addActiveView()
        self.authPlayer()
        
        
        
    }
    
    @objc func addBtnAction(){
        count += 1
        userDefaults.set(count, forKey: "count")
        userDefaults.synchronize()
        numLabel.text = "\(count)"
    }
    
    @objc func gamerBtnAction(){
        let defaultsScore = userDefaults.integer(forKey: "count")
        self.sendHighScore(number: defaultsScore)
        self.showGameCenterLeaderBoard()
    }
    
    func authPlayer(){
        self.showActiveView(show: true)
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (view,error)in
            
            if let view = view {
                self.present(view, animated: true, completion: nil)
                return
            }
            
            print("localPlayer auth: \(localPlayer.isAuthenticated)")
            
            DispatchQueue.main.async {
                self.showActiveView(show: false)
                // 取得各個排行榜資料
                self.getUserLeadBoardInfo()
                self.getLeaderBoardInfo()
            }
        }
    }
    func sendHighScore(number: Int){
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
                // 取得各個排行榜資料
                self.getUserLeadBoardInfo()
            })
            
        }
    }
    func getLeaderBoardInfo(){
        let leadBoardRequest = GKLeaderboard()
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
            allPlayer.removeAll()
            if playerScores.count != 0 {
                for player in playerScores{
                    
                    var playerInfo = [Dictionary<String, Any>()]
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
    func changeToJson(value:Any){
        if !JSONSerialization.isValidJSONObject(value) {
            return
        }
        var jsonData = Data()
        do{
            jsonData = try JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions.prettyPrinted)
        }catch {
            NSLog("error")
            
        }
        
        
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
    
    
    @objc func getUserLeadBoardInfo(){
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
                let playerInfo = leaderBoard.localPlayerScore
                var infoStr = String()
                if let playerId = playerInfo?.player?.playerID {
                    
                    infoStr.append("玩家 id：\(playerId)")
                }
                if let playerNickName = playerInfo?.player?.alias{
                    infoStr.append("\n玩家名字：\(playerNickName)")
                }
                if let playerRank = playerInfo?.rank{
                    infoStr.append("\n玩家排名：\(playerRank)")
                }
                if let playerValue = playerInfo?.value{
                    infoStr.append("\n玩家次數：\(playerValue)")
                }
                if let formattedValue = playerInfo?.formattedValue{
                    infoStr.append("\n玩家次數：\(formattedValue)")
                }
                DispatchQueue.main.async {
                    NSLog("info:\(infoStr)")
                    self.playerInfoTextView.text = infoStr
                }
            }else{
                NSLog("scores element is 0")
            }
        }
    }
    func showGameCenterLeaderBoard(){
       
        let viewVC = self.view.window?.rootViewController
        let gameCenterVC = GKGameCenterViewController()
        gameCenterVC.gameCenterDelegate = self;
        
        viewVC?.present(gameCenterVC, animated: true, completion: nil)
    }
    // MARK: GKGameCenterControllerDelegate function
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true) {
            NSLog("back from gameCenterViewController")
        }
    }
    
    func addActiveView() {
        waitingView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        let waitingViewFrame = CGRect(x:(self.view.frame.width-50)/2, y: (self.view.frame.height-50)/2, width: 50, height: 50)
        waitingView.frame = waitingViewFrame
        waitingView.startAnimating()
        backGroundView = UIView(frame: self.view.frame)
        backGroundView.backgroundColor = UIColor.gray
        backGroundView.alpha = 0.5
        
        backGroundView.addSubview(waitingView)
        self.view.addSubview(backGroundView)
    }
    
    func showActiveView(show: Bool){
        
        backGroundView.isHidden = !show
        waitingView.isHidden = !show
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

