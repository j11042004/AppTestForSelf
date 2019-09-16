//
//  ViewController.swift
//  HelloSqlite
//
//  Created by Uran on 2018/2/23.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import SQLite3
class ViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    private var results : Array<[String:Any?]> =  Array<[String:Any?]>()
    
    private let showCellID = "ShowTableViewCell"
    private let sqlManager = SqlManager.standard
    private let imagePicker = ImagePickerManager.standard
    private let refreshControl : UIRefreshControl = UIRefreshControl()
    private var insertStr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let showCellNib = UINib(nibName: "ShowTableViewCell", bundle: nil)
        self.tableview.register(showCellNib, forCellReuseIdentifier: showCellID)
        tableview.delegate = self
        tableview.dataSource = self
        
        // 下拉更新選項
        let attributedStr = NSAttributedString(string: "更新中")
        self.refreshControl.attributedTitle = attributedStr
        self.refreshControl.addTarget(self, action: #selector(ViewController.refreshTheData), for: UIControlEvents.valueChanged)
        self.tableview.refreshControl = self.refreshControl
        // 開啟 資料庫
        sqlManager.openDB()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imagePicker.imagePickerDelegate = self
        self.searchAllDB()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// 尋找 Sql
    func searchAllDB(){
        sqlManager.searchDB(showAll: true, id: nil) { (success, results) in
            if success{
                self.results = results
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }else{
                for result in results{
                    for dictionary in result{
                        print(dictionary.key)
                        print(dictionary.value as Any)
                    }
                }
            }
        }
    }
    
    // MARK : TableView refreshControl 觸發的方法
    @objc func refreshTheData(){
        self.searchAllDB()
        self.tableview.refreshControl?.endRefreshing()
    }
    
    // MARK: 新增資料
    @IBAction func insertDB(_ sender: UIBarButtonItem) {
        self.insertAlet(image: nil)
    }
    func insertAlet (image:UIImage?){
        let alert = UIAlertController(title: "Insert", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "姓名"
            if self.insertStr?.count != 0{
                textField.text = self.insertStr
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let insert = UIAlertAction(title: "新增", style: .default) { (action) in
            let name = alert.textFields?.first?.text
            self.sqlManager.insertDB(cname: name, image: image, complete: { (success, errMsg) in
                self.insertStr = ""
                self.searchAllDB()
            })
        }
        let chooseImg = UIAlertAction(title: "選擇相片", style: .default) { (action) in
            DispatchQueue.main.async {
                self.insertStr = alert.textFields?.first?.text
                self.imagePicker.showImageAlert()
            }
        }
        
        if let image = image {
            alert.addImage(image: image)
        }
        alert.addAction(insert)
        alert.addAction(cancel)
        alert.addAction(chooseImg)
        
        
        let rootVc = RootVCManager.standard.getTopViewcontroller()
        rootVc?.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: 尋找資料庫中的資料
    @IBAction func searchDB(_ sender: UIBarButtonItem) {
        self.searchAllDB()
    }
}
// MARK:- UITableViewDelegate,UITableViewDataSource
extension ViewController:UITableViewDelegate,UITableViewDataSource {
    // MARK: Table View DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: showCellID, for: indexPath)
        guard let showCell = cell as? ShowTableViewCell else{
            return cell
        }
        let result = results[indexPath.row]
        if let id = result["iid"] as? String{
            showCell.idLabel.text = "ID : \(id)"
        }
        if let name = result["cname"] as? String{
            showCell.nameLabel.text = "Name : \(name)"
        }
        if let image = result["image"] as? UIImage{
            showCell.showImageView.image = image
        }
        return showCell
    }
    
    // MARK: TableViewController Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        let result = results[indexPath.row]
        if let iid = result["iid"] as? String{
            detailVc.idText = iid
        }
        if let cname = result["cname"] as? String{
            detailVc.nameText = cname
        }
        if let image = result["image"] as? UIImage{
            detailVc.image = image
        }
        
        if (self.navigationController != nil) {
            self.navigationController?.pushViewController(detailVc, animated: true)
        }else{
            self.present(detailVc, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let result = self.results[indexPath.row]
        guard let id = result["iid"] as? String else{
            NSLog("id is nil")
            return
        }
        if editingStyle == UITableViewCellEditingStyle.delete {
            // 刪除資料
            sqlManager.deleteData(id: id, complete: { (success, errMsg) in
                if success{
                    self.searchAllDB()
                }else{
                    guard let errMsg = errMsg else{
                        NSLog("Error Message : 刪除失敗")
                        return
                    }
                    NSLog("Error Message : \(errMsg)")
                }
            })
        }
    }
}
// MARK:- ImagePickerManagerDelegate
extension ViewController : ImagePickerManagerDelegate{
    // 在這收到。image 後在次進行Alert 詢問
    func imagePickerGetImage(image: UIImage?) {
        self.insertAlet(image: image)
    }
}
