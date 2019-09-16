//
//  ViewController.swift
//  IAPTest
//
//  Created by Uran on 2017/12/12.
//  Copyright © 2017年 Uran. All rights reserved.

import UIKit
import StoreKit

enum Product {
    case consumable
    case nonConsumable
    case restore
}
class ViewController: UIViewController,IAPPurchaseDelegate {
    
    
    
    var userDefaults : UserDefaults = UserDefaults.standard
    
    var coinLabel : UILabel = UILabel()
    var showProdcBtn : UIButton = UIButton()
    var fullBtn : UIButton = UIButton()
    
    var coinNum : Int = 0
    var fullViewBool : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let viewWidth = self.view.frame.size.width
        
        
        
        
        // 顯示金幣 Label
        coinLabel = UILabel.init(frame: CGRect.init(x: (viewWidth-200)/2, y: 100, width: 200, height: 50))
        coinLabel.text = "現在金幣數：\(coinNum)"
        coinLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(coinLabel)
        
        // 顯示商城按鈕
        showProdcBtn = UIButton.init(frame: CGRect.init(x: (viewWidth-200)/2, y: 300, width: 200, height: 40))
        showProdcBtn.setTitle("前往商城", for: UIControlState.normal)
        showProdcBtn.addTarget(self, action: #selector(goToProducdtsView), for: UIControlEvents.touchUpInside)
        showProdcBtn.backgroundColor = UIColor.blue
        self.view.addSubview(showProdcBtn)
        
        // 若購買會出現
        fullBtn = UIButton.init(frame: CGRect.init(x: (self.view.frame.size.width - 200)/2, y: 500, width: 200, height: 200))
        fullBtn.setTitle("全部", for: UIControlState.normal)
        fullBtn.addTarget(self, action: #selector(showFullViewAction), for: UIControlEvents.touchUpInside)
        fullBtn.backgroundColor = UIColor.red
        self.view.addSubview(fullBtn)
        self.showFullView(showBool: fullViewBool)
        
        
        
        
        // get userDefaults value
        coinNum = self.userDefaults.integer(forKey: "coinsForUserDefaults")
        fullViewBool = self.userDefaults.bool(forKey: "fullViewForUserDefaults")
        NSLog("\(self.userDefaults.bool(forKey: "fullViewForUserDefaults"))")
        NSLog("\(coinNum),\(fullViewBool)")
        self.buyFuncAction(coinNum: coinNum, showAll: fullViewBool)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        coinNum = self.userDefaults.integer(forKey: "coinsForUserDefaults")
        fullViewBool = self.userDefaults.bool(forKey: "fullViewForUserDefaults")
        NSLog("\(coinNum),\(fullViewBool)")
    }
    @objc func goToProducdtsView() {
        guard let nextPage = storyboard?.instantiateViewController(withIdentifier: "ProductsTableViewController") as? ProductsTableViewController else {
            return
        }
        // 簽訂delegate
        nextPage.delegate = self
        self.navigationController?.pushViewController(nextPage, animated: true)
    }
    @objc func showFullViewAction(){
        //do something
    }
    // 通知金幣價格改變
    func buyFuncAction(coinNum : Int,showAll : Bool){
        coinLabel.text = "現在金幣數：\(coinNum)"
        showFullView(showBool: showAll)
    }
    func showFullView(showBool:Bool) {
        
        fullBtn.isHidden = !showBool
    }
    
    
    // IAP delegate Func
    func didBuySomething(_ viewcontroller: ProductsTableViewController, _ product: Product) {
        switch product {
        // 判斷傳回來的是哪種商品，再做相應的動作
        case .nonConsumable:
            let nowCoin = self.userDefaults.integer(forKey: "coinsForUserDefaults")
            let newTotalCoins = nowCoin + 100
            
            self.userDefaults.set(newTotalCoins, forKey: "coinsForUserDefaults")
            self.userDefaults.synchronize()
            break
        case .consumable:
            self.userDefaults.set(true, forKey: "fullViewForUserDefaults")
            self.userDefaults.synchronize()
            break
        case .restore:
            break
        }
        coinNum = self.userDefaults.integer(forKey: "coinsForUserDefaults")
        fullViewBool = self.userDefaults.bool(forKey: "fullViewForUserDefaults")
        self.buyFuncAction(coinNum: coinNum, showAll: fullViewBool)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

