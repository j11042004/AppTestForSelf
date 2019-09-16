//
//  GameViewController.swift
//  HelloGameCenter
//
//  Created by Uran on 2017/12/27.
//  Copyright © 2017年 Uran. All rights reserved.
//

import UIKit

class GameViewController: UIViewController,GCODelegate {
    
    
    let gcObject = GameCenterObject.sharedInstance()
    
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

        gcObject.delegate = self
        self.setUI()
    }
    func setUI(){
        
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
    }
    // ui Action function
    @objc func addBtnAction(){
        count += 1
        userDefaults.set(count, forKey: "count")
        userDefaults.synchronize()
        numLabel.text = "\(count)"
    }
    @objc func gamerBtnAction(){
        
    }
    @objc func getUserLeadBoardInfo(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // GCODelegateFunc
    func showAuthViewController(_ willshowViewController: UIViewController) {
        self.present(willshowViewController, animated: true, completion: nil)
    }
    
    func getUserGameCenterInfo(_ gameCenterInfo: [[String : Any]]) {
        NSLog("user info :\(gameCenterInfo)")
    }
    
    func gameCenterVCDidFinished(_ viewController: UINavigationController) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
