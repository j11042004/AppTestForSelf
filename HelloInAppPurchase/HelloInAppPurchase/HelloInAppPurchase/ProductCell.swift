//
//  ProductCell.swift
//  HelloInAppPurchase
//
//  Created by Uran on 2018/4/27.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.numberOfLines = 0
        self.title.sizeToFit()
        self.productDescription.numberOfLines = 0
        self.productDescription.sizeToFit()
        self.price.numberOfLines = 0
        self.price.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
