//
//  UserViewCell.swift
//  HelloFirebaseChat
//
//  Created by Uran on 2018/4/17.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class UserViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.layer.cornerRadius = 20
        self.profileImageView.layer.masksToBounds = true
        
    }
    
    override func layoutSubviews() {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension UIImageView{
    

    func loadImageCachWithUrlString(urlStr:String){
        
        
        guard let imgURL = URL(string: urlStr) else{
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: imgURL) { (data, response, error) in
            if let error = error {
                print("downloadError : \(error.localizedDescription)")
                return
            }
            guard let data = data else{
                return
            }
            guard let image = UIImage(data: data) else{
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
            
        }
        dataTask.resume()
    }
}
