//
//  ProfileViewController.swift
//  HelloLoin
//
//  Created by Uran on 2019/11/26.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let cellId = "Cell"
    private var infos : [String] = [String]()
    
    @IBOutlet weak var snapshotView: UIImageView!
    
    public var lineInfo : LineInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imgUrl = lineInfo?.pictureUrl ,
            let imgData = try? Data(contentsOf: imgUrl){
            let image = UIImage(data: imgData)
            snapshotView.image = image
        }
        if let name = lineInfo?.name {
            infos.append("姓名：\(name)")
        }
        if let accessToken = lineInfo?.accessToken {
            infos.append("accessToken：\(accessToken)")
        }
        if let userId = lineInfo?.userId {
            infos.append("userId：\(userId)")
        }
        if let statusMessage = lineInfo?.statusMessage {
            infos.append("statusMessage：\(statusMessage)")
        }
        if let email = lineInfo?.email {
            infos.append("email : \(email)")
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}

extension ProfileViewController : UITableViewDelegate {
    
}
extension ProfileViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let info = infos[indexPath.row]
        NSLog("cell info : \(info)")
        cell.textLabel?.text = info
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
