//
//  NewMessageViewController.swift
//  HelloFirebaseChat
//
//  Created by Uran on 2018/4/17.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import Firebase
class NewMessageViewController: UIViewController {
    private let cellID = "Cell"
    var users : [User] = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newMsgNavigationBar: UINavigationBar!
    @IBOutlet weak var newMsgNavigationItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newMsgNavigationItem.title = "New Message"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let cancelItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handelCancle))
        
        self.newMsgNavigationItem.leftBarButtonItems = [cancelItem]
        self.fetchUsers()
    }
    @objc func handelCancle(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// 監聽 FirDatabase 去取得所有的使用者
    func fetchUsers(){
        // 觀察 Database
        Database.database().reference().child(DefaultClass.infoUsersKey).observe(.childAdded, with: { (snapshot) in
            
            // 將 User 資料放進 User Class 在存到陣列
            guard let snapDict = snapshot.value as? [String : String] else{
                print("snapshot.value is not dictionary")
                return
            }
            let user = User()
            user.name = snapDict[DefaultClass.infoNameKey]
            user.email = snapDict[DefaultClass.infoEmailKey]
            user.profileimage = snapDict[DefaultClass.infoProfileImageKey]
            self.users.append(user)
            
            self.tableView.reloadData()
        }) { (error) in
            print("Value Added Cancel : \(error.localizedDescription)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension NewMessageViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! UserViewCell
        let user = self.users[indexPath.row]
        cell.titleLabel.text = user.name
        cell.subTitleLabel.text = user.email
        cell.profileImageView.image = UIImage(named: "sakura.jpg")
        guard let imgUrlStr = user.profileimage else {
            return cell
        }
        cell.profileImageView.loadImageCachWithUrlString(urlStr: imgUrlStr)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


