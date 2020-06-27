//
//  InterfaceController.swift
//  HelloWatch WatchKit Extension
//
//  Created by Uran on 2019/11/21.
//  Copyright © 2019 Uran. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation

class InterfaceController: WKInterfaceController {
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let totalWidth = contentFrame.width
        let totalHeight = contentFrame.height
        let width = totalWidth/4 - 2
        let height = (totalHeight-20)/6.5
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
// MARK: - Private Function
extension InterfaceController {
    
}
