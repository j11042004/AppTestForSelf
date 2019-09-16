//
//  ExtencionUI.swift
//  SongDecoder
//
//  Created by Uran on 2018/11/19.
//  Copyright © 2018 Uran. All rights reserved.
//

import Foundation
import UIKit
extension NSObject{
    func getImageFromUrl(with urlStr : String) -> UIImage?{
        guard let url = URL(string: urlStr) else{
            return nil
        }
        guard let data = try? Data(contentsOf: url) else{
            return nil
        }
        let img = UIImage(data: data)
        return img
    }
    func getImageFromUrl(with url : URL) -> UIImage?{
        guard let data = try? Data(contentsOf: url) else{
            return nil
        }
        let img = UIImage(data: data)
        
        return img
    }
    
    
    
}
