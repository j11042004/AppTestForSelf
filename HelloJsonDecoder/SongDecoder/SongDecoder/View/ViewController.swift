//
//  ViewController.swift
//  SongDecoder
//
//  Created by Uran on 2018/11/19.
//  Copyright © 2018 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let songCellId = "SongInfoTableCell"
    let songInfoUrlStr = "https://itunes.apple.com/search?term=Mayday&media=music"
    
    let songTableModel = SongTableModle()
    @IBOutlet weak var songTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.songTableView.delegate = self
        self.songTableView.dataSource = self
        self.songTableModel.alertClosure = {
            
        }
        self.songTableModel.reloadTableClosure = {
            DispatchQueue.main.async {
                self.songTableView.reloadData()
            }
        }
        self.songTableModel.waitingClosure = {
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.songTableModel.updateInfo(With: self.songInfoUrlStr)
    }


}

extension ViewController : UITableViewDelegate{
    
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songTableModel.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.songCellId, for: indexPath) as! SongInfoTableCell
        guard let cellModel = self.songTableModel.getSongCellModel(for: indexPath.row) else {
            return cell
        }
       
        cell.songNameLabel.text = cellModel.name
        cell.singerLabel.text = cellModel.singer
        cell.songImgView.image = cellModel.image
        
        return cell
    }
    
    
}
