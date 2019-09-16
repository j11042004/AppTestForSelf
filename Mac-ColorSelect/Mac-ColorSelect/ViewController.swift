//
//  ViewController.swift
//  Mac-ColorSelect
//
//  Created by Uran on 2018/6/28.
//  Copyright © 2018年 Uran. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var redTextField: NSTextField!
    @IBOutlet weak var greenTextField: NSTextField!
    @IBOutlet weak var blueTextField: NSTextField!
    
    @IBOutlet weak var hueTextField: NSTextField!
    @IBOutlet weak var saturationTextField: NSTextField!
    @IBOutlet weak var brightValueTextField: NSTextField!
    
    @IBOutlet weak var colorView: NSView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func rgbColorShow(_ sender: NSButton) {
        var red : CGFloat = 0
        if let redValue = Double(redTextField.stringValue){
            red = CGFloat(redValue)
        }
        var green : CGFloat = 0
        if let greenValue = Double(greenTextField.stringValue){
            green = CGFloat(greenValue)
        }
        var blue : CGFloat = 0
        if let blueValue = Double(blueTextField.stringValue){
            blue = CGFloat(blueValue)
        }
        
        let color = NSColor.rgb(red: red, green: green, blue: blue, alpha: 1).cgColor
        
        colorView.layer?.backgroundColor = color
        
    }
    
    @IBAction func hsvColorShow(_ sender: NSButton) {
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
extension NSColor {
    class func rgb(red : CGFloat , green : CGFloat , blue : CGFloat , alpha : CGFloat) -> NSColor{
        let r = red / 255
        let g = green / 255
        let b = blue / 255
        
        let color = NSColor(red: r, green:g , blue: b, alpha:alpha )
        return color
    }
}
