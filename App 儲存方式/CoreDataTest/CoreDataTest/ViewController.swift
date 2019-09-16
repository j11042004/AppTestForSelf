//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Uran on 2018/1/24.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContent : NSManagedObjectContext!
    var allUserData : Array<[String:String]> = [[String : String]]()
    
    var editNow : Bool = false
    
    var dataManager : CoreDataManager<UserData> = CoreDataManager(model: "FriendInfo", dbFileName: "userData.sqlite", dbPathURL: nil, sortKey: "name", entityName: "UserData")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // 設定 navigation 左邊的 barButton 為 UI ViewController 中的  editButtonItem
        // 並覆寫他的方法
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let results : [UserData]? = dataManager.search(atField: "name", forKeyWord: "q") as? [UserData]
        guard let itemResults = results else {
            return
        }
        for item in itemResults {
            guard let id = item.id else{
                continue
            }
            guard let name = item.name else{
                continue
            }
            NSLog("search item id :\(id),item name:\(name)")
        }
    }
    @IBAction func addNewData(_ sender: UIBarButtonItem) {
        self.editWithItem(item: nil) { success, item in
            if success{
                self.dataManager.saveContext(completion: { success in
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: editing)
        tableView.setEditing(editing, animated: editing)
    }
    
    //  Closure， 製作一個 editing function 儲存 alert 完成時的狀態在進行下一步
    typealias EditItemCompletion = (_ success:Bool , _ result:UserData?) -> Void
    func editWithItem(item:UserData? , completion:@escaping EditItemCompletion){
        let alert = UIAlertController(title: "", message: "請輸入使用者 id 與 Name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "id"
            textField.text = item?.id
        }
        alert.addTextField { textField in
            textField.placeholder = "name"
            textField.text = item?.name
        }
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            var finalItem = item
            if finalItem == nil{
                finalItem = self.dataManager.createItem()
            }
            finalItem?.id = alert.textFields?[0].text
            finalItem?.name = alert.textFields?[1].text
            completion(true, finalItem)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            completion(false,nil)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.count()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = dataManager.item(with: indexPath.row)
        cell.textLabel?.text = item.id
        cell.detailTextLabel?.text = item.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataManager.item(with: indexPath.row)
        self.editWithItem(item: data) { (success, item) in
            if success {
                self.dataManager.saveContext(completion: { (success) in
                    if success{
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    // 是否可編輯
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = dataManager.item(with: indexPath.row)
            dataManager.deleteItem(item)
            dataManager.saveContext(completion: { success in
                if success{
                    self.tableView.reloadData()
                }
            })
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
}

