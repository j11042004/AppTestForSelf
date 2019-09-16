//
//  SongInfoTableCell.swift
//  SongDecoder
//
//  Created by Uran on 2018/11/19.
//  Copyright © 2018 Uran. All rights reserved.
//

import UIKit

class SongInfoTableCell: UITableViewCell {
    
    @IBOutlet weak var songImgView: UIImageView!{
        didSet{
            self.songImgView.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var songNameLabel: UILabel!{
        didSet{
            self.songNameLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var singerLabel: UILabel!{
        didSet{
            self.singerLabel.numberOfLines = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
