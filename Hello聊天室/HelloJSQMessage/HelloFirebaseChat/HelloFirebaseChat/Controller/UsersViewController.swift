//
//  UsersViewController.swift
//  HelloFirebaseChat
//
//  Created by Uran on 2018/4/11.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    private let chatCellID = "ChannelCell"
    private let createCellID = "CreateChannelCell"
    
    private var channelRefHandle : DatabaseHandle?
    
    // 若是要在一開始就宣告要加入 lazy
    // 否則 FireBase 會報錯要求加入 FirebaseApp.configure()，即使你有加入
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        
        let logoutItem = UIBarButtonItem(title: "登出", style: .done, target: self, action: #selector(handleLogOut))
        self.navigationItem.leftBarButtonItems = [logoutItem]
        let writeItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        self.navigationItem.rightBarButtonItems = [writeItem]
        self.checkUserLogedIn()
        
    }
    
    @objc func handleLogOut(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
        let bundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "SigninStoryboard", bundle: bundle)
        let signVC = storyboard.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        self.present(signVC, animated: true, completion: nil)
    }
    
    @objc func handleNewMessage(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let newMessageVC = mainStoryBoard.instantiateViewController(withIdentifier: "NewMessageViewController") as! NewMessageViewController
        self.present(newMessageVC, animated: true, completion: nil)
    }
    /// 確認使用者是否有登入
    func checkUserLogedIn(){
        guard let id = Auth.auth().currentUser?.uid else{
            performSelector(onMainThread: #selector(handleLogOut), with: nil, waitUntilDone: false)
            return
        }
        // 觀察 firebase 是否有此 id
        Database.database().reference().child(DefaultClass.infoUsersKey).child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            print("id snapshot : \(snapshot)")
            guard let userInfo = snapshot.value as? [String : Any] else{
                return
            }
            self.navigationItem.title = userInfo[DefaultClass.infoNameKey] as? String
            
        }, withCancel: { (error) in
            print("Cancel Error : \(error.localizedDescription)")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.tableview.endEditing(true)
        
    }

}

extension UsersViewController : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.chatCellID, for: indexPath)
        // 設定 Cell 背景顏色
        cell.backgroundColor = UIColor.white
        cell.contentView.backgroundColor = UIColor.white
        
        cell.imageView?.image = UIImage(named: "sakura.jpg")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
