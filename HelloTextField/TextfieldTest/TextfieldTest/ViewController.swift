//
//  ViewController.swift
//  TextfieldTest
//
//  Created by Uran on 2018/4/30.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var keyboardLabel: UILabel!
    @IBOutlet var keyboardToolBar: UIToolbar!
    @IBOutlet weak var prefixCenterYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var changeFontTextField: UITextField!
    @IBOutlet weak var limitTextField: UITextField!
    @IBOutlet weak var prefixTextField: UITextField!
    @IBOutlet weak var prefixLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 更換字體大小
        changeFontTextField.addTarget(self, action: #selector(fontTextFieldEditingChange(_:)), for: .editingChanged)
        // 限制字數
        limitTextField.delegate = self
        
        // 只出現前五個字
        prefixTextField.addTarget(self, action: #selector(prefixTextFieldValueEdit(_:)), for: .editingChanged)
        // 去除掉建議區塊
        prefixTextField.autocorrectionType = .no
        prefixTextField.inputAccessoryView = keyboardToolBar
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func fontTextFieldEditingChange(_ sender : UITextField){
        sender.changeFontSizeWhenOverFrame(sender)
    }
    
    @objc func prefixTextFieldValueEdit(_ sender : UITextField){
        if let text = sender.text {
            let finalText  = String(text.prefix(5))
            self.prefixLabel.text = finalText
            self.keyboardLabel.text = finalText
        }
    }
}

extension ViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // string : 要增加的字元
        // range : { 字數，判斷是否是取代 }
        let countOfWords = string.count +  textField.text!.count - range.length
        if textField.isEqual(self.limitTextField) && countOfWords > 10{
            return false
        }
        return true
    }
    
    
}
