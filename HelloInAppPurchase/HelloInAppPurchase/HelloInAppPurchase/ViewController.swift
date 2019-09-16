//
//  ViewController.swift
//  HelloInAppPurchase
//
//  Created by Uran on 2018/4/23.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import StoreKit
class ViewController: UIViewController {
    
    @IBOutlet weak var barTitle: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var coinLabel: UILabel!
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var houseImageView: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.barTitle.title = ""
        self.coinLabel.text = "\(UserDefaults.standard.integer(forKey: "Coins"))"
        
        self.textField.delegate = self
        self.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        let hasCar = userDefaults.bool(forKey: "ios.car.car")
        let hasHouse = userDefaults.bool(forKey: "ios.house.house")
        self.carImageView.isHidden = !hasCar
        self.houseImageView.isHidden = !hasHouse
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func buyItem(_ sender: UIBarButtonItem) {
        let iapVC = self.storyboard?.instantiateViewController(withIdentifier: "IapViewController") as! IapViewController
        iapVC.iapDelegate = self
        self.present(iapVC, animated: false, completion: nil)
    }
    @objc func textFieldValueChanged(_ sender : UITextField){
        
        let width = sender.frame.width
        sender.resizeText(With: width)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : IapVCDelegate{
    func didBuyCoin(_ coinNumber: Int) {
        NSLog("購買了 \(coinNumber) 元")
        guard let coin = self.coinLabel.text else {
            return
        }
        if let labelCoinNum = Int(coin) {
            self.coinLabel.text = "\(labelCoinNum+coinNumber)"
        }else{
            self.coinLabel.text = "\(coinNumber)"
        }
        UserDefaults.standard.set(Int(self.coinLabel.text!), forKey: "Coins")
    }
}


extension ViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // string : 要增加的字元
        // range : { 字數，判斷是否是取代 }
        let countOfWords = string.count +  textField.text!.count - range.length
        if countOfWords > 10{
            return false
        }
        
        return true
    }
}
extension UITextField{
    public func resizeText(With width:CGFloat){
        guard let text = self.text as NSString? else {
            return
        }
        guard let font = self.font else {
            return
        }
        // 計算字串 Size
        var wordSize = self.calculatorWordsSize(With: text, font: font)
        
        // 若是字串寬大於 TextField 寬，縮小字型
        while wordSize.width > width {
            guard let changedfont = self.font else {
                break
            }
            let fontSize = changedfont.pointSize - 0.5
            if fontSize < 10 {
                break
            }
            // 重新計算字串 Size
            self.font = UIFont(name: font.fontName, size: fontSize)
            wordSize = self.calculatorWordsSize(With: text, font: self.font!)
        }
        // 若是字串寬小於 TextField 寬，放大字型
        while wordSize.width < width {
            guard let changedfont = self.font else {
                break
            }
            let fontSize = changedfont.pointSize + 0.5
            if fontSize > 14 {
                break
            }
            // 重新計算字串 Size
            self.font = UIFont(name: font.fontName, size: fontSize)
            wordSize = self.calculatorWordsSize(With: text, font: self.font!)
        }
    }
    
    /// 計算字串的長寬
    ///
    /// - Parameters:
    ///   - text: 字串，NSString
    ///   - font: 字型，UIFont
    /// - Returns: Size
    private func calculatorWordsSize(With text : NSString , font : UIFont) -> CGSize{
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : font]
        let size = text.size(withAttributes: attributes)
        return size
    }
    
    
}
