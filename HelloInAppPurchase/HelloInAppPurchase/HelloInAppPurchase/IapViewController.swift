//
//  IapViewController.swift
//  HelloInAppPurchase
//
//  Created by Uran on 2018/4/23.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import StoreKit

@objc protocol IapVCDelegate{
    /// 購買金幣成功
    func didBuyCoin(_ coinNumber:Int)
}


class IapViewController: UIViewController  {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var waitingActiviteView: UIActivityIndicatorView!
    
    var iapDelegate : IapVCDelegate?
        // 要先設定 productIDs 才可以取得 商品資訊
        var productIDs : [String] = ["ios.coin.100","ios.coin.200","ios.house.house","ios.car.car"]
        let manager : IAPManager = IAPManager.sharedInstance
        var productsArray = IAPManager.sharedInstance.products
    
    var selectProductIndex : Int!
    /// 是否在交易中
    var isTransactionInProgress = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.bringSubviewToFront(self.waitingView)
        self.waitingView.bringSubviewToFront(self.waitingActiviteView)
        
        self.manager.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        // 避免商品資訊還未取得，使用者就跳到這一頁
        if self.productsArray.count != 0 {
            self.waitingView.isHidden = true
            self.waitingActiviteView.isHidden = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backLastViewController(_ sender: UIBarButtonItem) {
        // 轉場動畫效果
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func restoreProduct(_ sender: UIBarButtonItem) {
        manager.restoreProduct()
    }
    

}
// MARK: - Tableview Delegate DateSource
extension IapViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductCell
        let product = self.productsArray[indexPath.row]
        cell.title.text = product.localizedTitle
        cell.productDescription.text = product.localizedDescription
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectProductIndex = indexPath.row
        // 讓被點選的商品不再被點選
        tableView.cellForRow(at: indexPath)?.isSelected = false
        let product = self.productsArray[indexPath.row]
        
        manager.buyProduct(With: product)
    }
    
}
extension IapViewController : IAPManagerDelegate{
    func managerSendBoughtCoin(With value: Int) {
        self.iapDelegate?.didBuyCoin(value)
    }
    func managerBoughtProduct(With productID: String) {
        let compantArray = productID.components(separatedBy: ".")
        if compantArray.count < 3 {
            return
        }
        let typeStr = compantArray[1]
        let value = compantArray.last!
        if typeStr == "coin"{
            if let coinNum = Int(value){
                self.iapDelegate?.didBuyCoin(coinNum)
            }else{
                
            }
        }else{
            UserDefaults.standard.set(true, forKey: productID)
        }
    }
    func managerGotAllProduct(With products: [SKProduct]) {
        // 若是使用者太快跳到此頁 或是 重新要求商品時會觸發這個方法
        self.productsArray = products
        self.tableView.reloadData()
        self.waitingView.isHidden = true
        self.waitingActiviteView.isHidden = true
    }
    
    func managerDidChangeTranscationState(With istranstation: Bool) {
        self.waitingView.isHidden = !istranstation
        self.waitingActiviteView.isHidden = !istranstation
        
    }
    
}
