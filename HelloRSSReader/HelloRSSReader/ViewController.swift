//
//  ViewController.swift
//  HelloRSSReader
//
//  Created by Uran on 2018/6/29.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
z
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var rssReach : Reachability?
    var rssItems : [RssItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let rssParser = RssParser()
        // 更新按鈕
        let refreshItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(ViewController.downloadRss(_:)))
        self.navigationItem.rightBarButtonItems = [refreshItem]
        
        rssParser.parserFeed(feedUrl: "https://udn.com/rssfeed/news/2/6638?ch=news") { (items) in
            guard let items = items else {
                return
            }
            self.rssItems = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    @objc func downloadRss(_ sender : UIBarButtonItem){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rssItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = rssItems[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.description
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
}
