//
//  ViewController.swift
//  HelloGif
//
//  Created by Uran on 2018/3/1.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var gifImg : UIImage?
    
    private let cellID = "Cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gifImg = UIImage.gif(name: "eggMouse")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! GifCell
//        gifImg = UIImage.gif(name: "eggMouse")
        cell.gifImageView.image = gifImg
        return cell
    }
}




class GifCell: UITableViewCell {
    @IBOutlet weak var gifImageView: UIImageView!
    
}
