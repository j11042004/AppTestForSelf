//
//  CharacterCollectCell.swift
//  HelloUPCarousel
//
//  Created by Uran on 2020/2/5.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit

class CharacterCollectCell: UICollectionViewCell {
    @IBOutlet weak var imgView : UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = max(self.frame.size.width, self.frame.size.height) / 2
        self.layer.borderWidth = 10
        self.layer.borderColor = UIColor(red: 110.0/255.0, green: 80.0/255.0, blue: 140.0/255.0, alpha: 1.0).cgColor
    }
}
