//
//  ProductsTableViewController.swift
//  IAPTest
//
//  Created by Uran on 2017/12/12.
//  Copyright © 2017年 Uran. All rights reserved.
//
//  金幣100 商品 id ：tap.coin.100
//  顯示完整版 商品 id :show.total.view

import UIKit
import StoreKit
class ProductsTableViewController: UITableViewController {
    
    var allProducts = [SKProduct]()
    // 內購 ID
    let coin100Id = "tap.coin.100"
    let fullViewId = "show.total.view"
    
    var delegate : IAPPurchaseDelegate?
    var isProgress: Bool = false // 是否有交易正在進行中
    
    var selectedProductIndex: Int!
    var transactionInProgress = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 將自身定義為訂單觀察者
        SKPaymentQueue.default().add(self)
        // 向 Apple 要求商品訊息
        self.requestProductInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // 移除觀察者
        SKPaymentQueue.default().remove(self)
    }
// MARK: - Normal Func
    // 要求商品訊息
    func requestProductInfo(){
        if !SKPaymentQueue.canMakePayments() {
            NSLog("請確認應用內購買狀態")
            return
        }
        let productsID = [coin100Id,fullViewId]
        guard let productsSKU : Set<String> = NSSet(array: productsID) as? Set<String> else{
            return
        }
        // 傳送商品要求
        let proReq = SKProductsRequest(productIdentifiers: productsSKU)
        NSLog("proReq: \(proReq)")
        proReq.delegate = self
        // 開始請求內購產品
        proReq.start()
    }
    // 出貨
    func deliverProduct(transaction : SKPaymentTransaction){
        let userDefaults = UserDefaults.standard
        // 判斷是購買什麼商品
        if transaction.payment.productIdentifier == coin100Id {
            var totalCoins = 0
            if let nowCoins = userDefaults.object(forKey:"coinsForUserDefaults") as? Int{
                totalCoins = nowCoins+100
                NSLog("totalcoin:\(totalCoins)" )
            }else{
                totalCoins = 100
            }
            NSLog("totalcoin:\(totalCoins)" )
            userDefaults.set(totalCoins, forKey: "coinsForUserDefaults")
            userDefaults.synchronize()
        }else if transaction.payment.productIdentifier == fullViewId {
            userDefaults.set(true, forKey: "fullViewForUserDefaults")
            userDefaults.synchronize()
        }
    }
    
    // 完成交易後的 alert
    func showMessage(_ product: Product) {
        var message: String!
        
        switch product {
        case .consumable:
            message = "購買消耗性商品成功！"
        case .nonConsumable:
            message = "購買非消耗性商品成功！"
        case .restore:
            message = "回復成功！"
        }
        
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "是", style: .default, handler: nil)
        
        alertController.addAction(confirm)
        
        self.present(alertController, animated: true, completion: nil)
    }
// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allProducts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let product = allProducts[indexPath.row]
        
        cell.textLabel?.text = "\(product.localizedTitle) 販售\(product.price.doubleValue) 元"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 點擊到的購買項目
        selectedProductIndex = indexPath.row
        
        showActionSheet(selectedProductIndex == 0 ? Product.consumable : Product.nonConsumable)
        
    }
    
    
    // 詢問是否購買或回復的 Action Sheet
    func showActionSheet(_ product: Product) {
        // 代表有購買項目正在處理中
        if self.isProgress {
            return
        }
        
        var message: String!
        var buyAction: UIAlertAction?
        var restoreAction: UIAlertAction?
        
        switch product {
        case .consumable, .nonConsumable:
            // 購買消耗性、非消耗性產品
            message = "確定購買產品？"
            buyAction = UIAlertAction(title: "購買", style: UIAlertActionStyle.default) { (action) -> Void in
                
                if SKPaymentQueue.canMakePayments() {
                    // 設定交易流程觀察者，會在背景一直檢查交易的狀態，成功與否會透過 protocol 得知
                    SKPaymentQueue.default().add(self)
                    
                    // 取得內購產品
                    let payment = SKPayment(product: self.allProducts[self.selectedProductIndex])
                    
                    // 購買消耗性、非消耗性動作將會開始在背景執行(updatedTransactions delegate 會接收到兩次)
                    SKPaymentQueue.default().add(payment)
                    self.isProgress = true
                    
                    // 開始執行購買產品的動作
                }
            }
        default:
            // 復原購買產品
            message = "是否回復？"
            restoreAction = UIAlertAction(title: "回復", style: UIAlertActionStyle.default) { (action) -> Void in
                if SKPaymentQueue.canMakePayments() {
                    SKPaymentQueue.default().restoreCompletedTransactions()
                    self.isProgress = true
                    
                    // 開始執行回復購買的動作
                }
            }
        }
        
        // 產生 Action Sheet
        let actionSheetController = UIAlertController(title: "測試內購", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        
        actionSheetController.addAction(buyAction != nil ? buyAction! : restoreAction!)
        actionSheetController.addAction(cancelAction)
        
        // 在ipad上要運行popover才可作 .actionSheet 的運作
        actionSheetController.popoverPresentationController?.sourceView = self.view
        actionSheetController.popoverPresentationController?.sourceRect = CGRect.init(x:self.view.frame.minX , y:self.view.frame.minY , width: self.view.frame.width / 4, height: 50)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    

}

extension ProductsTableViewController:SKProductsRequestDelegate,SKPaymentTransactionObserver{
    
    // MARK: - SKProductsRequestDelegate Func
    // 接收到產品請求的回應
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for invaliGoods in response.invalidProductIdentifiers {
            NSLog("無法販售的商品：\(invaliGoods)")
        }
        for product in response.products {
            NSLog("\(product.localizedTitle) 可以販售，金額是：\(product.price.doubleValue) 元")
            allProducts.append(product)
        }
        self.tableView.reloadData()
    }
    // MARK: - SKPaymentTransactionObserver Func
    //處理付款結果，購買、復原成功與否.....
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // 判斷交易的結果
        // 送出購買則會 update 一次，購買成功 server 又會回傳一次 update
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
               NSLog("交易成功")
               // 跟 ViewController 說已完成付款，必須增加金幣
               if self.selectedProductIndex == 1{
                    delegate?.didBuySomething(self, Product.nonConsumable)
               }else{
                    delegate?.didBuySomething(self, Product.consumable)
               }
               // important 告知 apple完成交易
               SKPaymentQueue.default().finishTransaction(transaction)
                break
            case SKPaymentTransactionState.failed:
                NSLog("交易失敗...")
                if let error = transaction.error as? SKError {
                    switch error.code {
                    case .paymentCancelled:
                        // 輸入 Apple ID 密碼時取消
                        NSLog("Transaction Cancelled: \(error.localizedDescription)")
                    case .paymentInvalid:
                        NSLog("Transaction paymentInvalid: \(error.localizedDescription)")
                    case .paymentNotAllowed:
                        NSLog("Transaction paymentNotAllowed: \(error.localizedDescription)")
                    default:
                        NSLog("Transaction: \(error.localizedDescription)")
                    }
                }
                // important 告知 apple 結束交易
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            // 回復至未交易前
            case SKPaymentTransactionState.restored:
                self.deliverProduct(transaction: transaction)
                print("復原成功...")
                // 必要的機制
                SKPaymentQueue.default().finishTransaction(transaction)
                // 跟 ViewController 說已回復動作
                delegate?.didBuySomething(self, Product.restore)
                self.showMessage(.restore)
                break
            default :
                break
            }
        }
    }
    
    // 復原購買失敗
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("復原購買失敗...")
        print(error.localizedDescription)
    }
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("復原購買成功...")
    }
    
}






