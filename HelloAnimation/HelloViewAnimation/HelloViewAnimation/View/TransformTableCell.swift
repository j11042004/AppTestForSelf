//
//  TransformTableCell.swift
//  HelloViewAnimation
//
//  Created by Uran on 2018/7/3.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class TransformTableCell: UITableViewCell {
    var degree : CGFloat = 180
    var select = false
    
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func transformPress(_ sender: UIButton) {
        let radius = degree * CGFloat.pi / 180
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform(rotationAngle: radius)
        }
        degree = degree == 180 ? 0 : 180
        select = !select
    }
    
    func showMore(){
        let radius = degree * CGFloat.pi / 180
        UIView.animate(withDuration: 0.2) {
            self.moreButton.transform = CGAffineTransform(rotationAngle: radius)
        }
        degree = degree == 180 ? 0 : 180
        select = !select
    }
    
}
