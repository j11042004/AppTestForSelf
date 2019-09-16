//
//  CusTableViewCell.swift
//  SwiftXiB
//
//  Created by Uran on 2018/2/27.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class CusTableViewCell: UITableViewCell {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
