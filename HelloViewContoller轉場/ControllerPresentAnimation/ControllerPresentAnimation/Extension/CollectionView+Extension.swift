//
//  CollectionView+Extension.swift
//  ControllerPresentAnimation
//
//  Created by Uran on 2018/12/7.
//  Copyright © 2018 Uran. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView{
    /// CollectionView Item 在畫面(View)上的 Frame
    func getItemFrame(indexPath : IndexPath) -> CGRect? {
        var frame : CGRect? = nil
        guard let cellLayoutAttribute = self.layoutAttributesForItem(at: indexPath) else {
            return frame
        }
        frame = self.convert(cellLayoutAttribute.frame, to: self.superview)
        return frame
    }
}
