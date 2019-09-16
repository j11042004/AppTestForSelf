//
//  IAPManager.swift
//  HelloInAppPurchase
//
//  Created by Uran on 2018/4/25.
//  Copyright © 2018年 Uran. All rights reserved.
//
//  千萬不要在 App 進入背景與進入前景時，分別加入移除觀察者和新增觀察者，
//  否則購買動作會大量延遲


import UIKit
import StoreKit
import MessageUI

@objc protocol IAPManagerDelegate {
    
    /// 購買的商品
    func managerBoughtProduct(With productID : String)
    /// 告知所有商品資訊已取得
    func managerGotAllProduct(With products : [SKProduct])
    /// 是否正在購買中
    @objc optional func managerDidChangeTranscationState(With istranstation:Bool)
}

class IAPManager: NSObject {
    public static let sharedInstance = IAPManager()
    public var delegate : IAPManagerDelegate?
    public var products : [SKProduct] = []
    public var productsID : [String] = []
    
    private var isTransactionInProgress = false
    private var isShowAlert = false
    // 因為是 使用沙盒帳號 所以使用 https://sandbox.itunes.apple.com/verifyReceipt來取的收據
    // 正式環境就使用 https://buy.itunes.apple.com/verifyReceipt
    private let receiptUrlStr = "https://sandbox.itunes.apple.com/verifyReceipt"
    
    private let rootVC = RootVCManager.standard
    //MARK: - 新增交易觀察者
    /// 新增交易觀察者
    public func addNewProductObserver(){
        SKPaymentQueue.default().add(IAPManager.sharedInstance)
    }
    //MARK: - 移除交易觀察者
    /// 移除交易觀察者
    public func removeProductObserver(){
        SKPaymentQueue.default().remove(IAPManager.sharedInstance)
    }
    
    //MARK: - 向 Apple 要求商品資訊
    /// 向 Apple 要求商品資訊
    /// - Parameter productIds: Apple 上的 商品ID 若給的不對會要求不到資料
    public func requestProductFromApple(){
        if SKPaymentQueue.canMakePayments(){
            let productIdSet : Set<String> = NSSet(array: self.productsID) as! Set<String>
            let productRequest = SKProductsRequest(productIdentifiers: productIdSet)
            productRequest.delegate = self
            // 開始向 itunes Connect 要求
            productRequest.start()
        }else{
            self.showSureAlert(Title: "錯誤", Message: "無法取得商品資訊，請與開發者聯絡!")
        }
    }
    //MARK: - 購買商品
    /// 購買商品
    public func buyProduct(With product : SKProduct){
        let msg = "商品名稱：\(product.localizedTitle)\n\(product.localizedDescription)\n價格：\(product.price)元"
        self.showBuyAlert(Product: product, Title: "購買資訊", Message: msg)
    }
    //MARK: - 回復購買商品
    /// 回復購買商品
    public func restoreProduct(){
        let alert = UIAlertController(title: "回復購買！", message: "是否要回覆上次的購買狀態", preferredStyle: .alert)
        let restore = UIAlertAction(title: "回復購買", style: .default) { _ in
//          執行回覆購買裝態
            SKPaymentQueue.default().restoreCompletedTransactions()
            self.nowIsTransaction(Is: true)
            self.isShowAlert = false
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (_) in
            self.isShowAlert = false
            self.nowIsTransaction(Is: false)
        }
        alert.addAction(restore)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            if !self.isShowAlert{
                self.isShowAlert = true
                self.rootVC.getTopViewcontroller()?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - 是否正在交易
    /// 是否正在交易
    private func nowIsTransaction(Is show:Bool) {
        self.isTransactionInProgress = show
        self.delegate?.managerDidChangeTranscationState!(With: show)
    }
    
    //MARK: - 向 Apple 驗證交易的收據
    /// 向 Apple 驗證交易的收據
    private func getPaymentReceipt(_ transactiom:SKPaymentTransaction){
        guard let receiptUrl = Bundle.main.appStoreReceiptURL else{
            NSLog("itunes 驗證 url is nil")
            return
        }
        do {
            // 將收據內的data 轉成 base64
            let receiptData : Data = try Data(contentsOf: receiptUrl)
            let dataStr = receiptData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
            // 建立一個要傳給 Apple 驗證網站的 json，請參考官方收據驗證 pdf 檔
            let receiptDict = ["receipt-data": dataStr]
            do {
                let requestData = try JSONSerialization.data(withJSONObject: receiptDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                // 驗證用的收據網址
                let url = URL(string: self.receiptUrlStr)!
                var request = URLRequest(url: url)
                // 設定 方法為 post
                request.httpMethod = "POST"
                request.httpBody = requestData
                let configue = URLSessionConfiguration.default
                let session = URLSession(configuration: configue)
                let data = session.dataTask(with: request) { (data, response, error) in
                    if let error = error{
                        NSLog("驗證收據失敗 ：\(error.localizedDescription)")
                    }
                    if let data = data {
                        do{
                            // 將 Data 轉為 json
                            guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else{
                                return
                            }
                            // 取得交易的 JSon Dictionary
                            print("jsonData : \n\(jsonDict)")
                        }catch{
                            print("change to json is nil : \(error.localizedDescription)")
                        }
                    }
                }
                data.resume()
            } catch  {
                print("jsonData error :\(error.localizedDescription)")
            }
        } catch  {
            NSLog("Url can't change to data error:\(error.localizedDescription)")
        }
    }
}

//MARK: - SKProduct Delegate and SKPaymentTransactionObserver Function
extension IAPManager : SKProductsRequestDelegate,SKPaymentTransactionObserver{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        // 判斷是否有商品
        if response.products.count == 0{
            self.showSureAlert(Title: "錯誤", Message: "無法取得商品資訊，請與開發者聯絡!")
            return
        }
        // 所有不再被販售的商品資訊
        for invalidProduct in response.invalidProductIdentifiers {
            NSLog("不再被販售的商品：\(invalidProduct.description) ,id:\(invalidProduct)")
        }
        // 先移除所有的商品項目，否則重複更新會一直累加
        self.products.removeAll()
        // 將可販售的商品與商品 id 放入 陣列中
        for product in response.products {
            self.products.append(product)
        }
        
        // 通知更新商品完畢
        self.delegate?.managerGotAllProduct(With: self.products)
        
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        NSLog("request Product error : \(error.localizedDescription)")
    }
    //MARK: - 重要 交易觀察者Delegate 觀察交易
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState{
            case .purchased:
                print("商品已付款，交易完成")
                // 完成交易
                SKPaymentQueue.default().finishTransaction(transaction)
                let paymentProID = transaction.payment.productIdentifier
                self.nowIsTransaction(Is: false)
                // 傳送取得的商品id
                self.delegate?.managerBoughtProduct(With: paymentProID)
                // 取得交易成功的唯一的 id
                print("交易 id:\(transaction.transactionIdentifier)")
                // 驗證收據
                self.getPaymentReceipt(transaction)
                break
            case .purchasing:
                print("商品付款中")
                break
            case .restored:
                // 續訂型商品，或 非消耗性項目 就需要回覆購買
                print("商品回覆購買")
                print("\(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
                
                self.showSureAlert(Title: nil, Message: "已回覆自己購買的商品")
                //MARK: 當回覆成功時 做一些事
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey: transaction.payment.productIdentifier)
                
                
                self.nowIsTransaction(Is: false)
                break
            case .failed :
                print("交易失敗")
                if let error = transaction.error {
                    print(error)
                    print("最終原因：\(error.localizedDescription)")
                }else{
                    print("不明原因")
                }
                // 結束交易
                SKPaymentQueue.default().finishTransaction(transaction)
                self.nowIsTransaction(Is: false)
                self.showSureAlert(Title: "交易失敗", Message: "請確認網路狀態或聯繫開發者")
                break
            case .deferred:
                print("商品購買狀態未確定")
                break
            }
            
        }
    }
    // 根據購買的項目從 Appstore 上 下載相關的內容
    func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        for download in downloads {
            print("下載項目內容的ID :\(download.contentIdentifier)")
            print(download.transaction.payment.productIdentifier)
        }
    }
    // 回復商品狀態完成
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        let transactions = queue.transactions
        for transaction in transactions{
            print("要回復商品的ID ：\(transaction.payment.productIdentifier)")
        }
    }
    // 一些會導致回覆商品失敗的情況,ex 取消登入 itunes 帳號
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print(error.localizedDescription)
        self.nowIsTransaction(Is: false)
        if let skError = error as? SKError{
            switch skError.code {
            case .clientInvalid :
                print("client 無效")
                break
            case .paymentCancelled :
                print("訂單取消")
                break
            case .paymentInvalid :
                print("訂單無效")
                break
            case .paymentNotAllowed :
                print("訂單不被允許")
                break
            case .unknown :
                print("未知原因")
                break
            case .cloudServiceNetworkConnectionFailed :
                print("連結到雲端 server 失敗")
                break
            case .cloudServicePermissionDenied :
                print("雲端 Server 許可未決定")
                break
            case .cloudServiceRevoked :
                print("雲端 Server 被廢棄")
                break
            case .storeProductNotAvailable :
                print("商品不是有效的")
                break
            }
        }
        
    }
    
    
}

//MARK: - MessageUI mail Delegate
extension IAPManager:MFMailComposeViewControllerDelegate {
    // MARK: - 寄送 mail Alert
    /// 寄送 mail
    func showConnectDeveloperAlert(){
        let alert = UIAlertController(title: "重大錯誤", message: "發生重大錯誤，請立即聯絡 Apple 或開發者", preferredStyle: .alert)
        let connect = UIAlertAction(title: "聯絡開發者", style: .default) { (action) in
            self.sendMail()
            self.isShowAlert = false
            self.nowIsTransaction(Is: false)
        }
        let cancel = UIAlertAction(title: "確定", style: .cancel) { (_) in
            self.isShowAlert = false
            self.nowIsTransaction(Is: false)
        }
        alert.addAction(connect)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            if !self.isShowAlert{
                self.isShowAlert = true
                self.rootVC.getTopViewcontroller()?.present(alert, animated: true, completion: nil)
            }
        }
    }
    /// 寄送郵件
    func sendMail(){
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            DispatchQueue.main.async {
                self.rootVC.getTopViewcontroller()?.present(mailComposeViewController, animated: true, completion: nil)
            }
            
        } else {
            NSLog("無法寄送信件")
        }
    }
    // 建立寄送 Email 的 Alert
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        //更換email
        mailComposerVC.setToRecipients(["xxxx@gmail.com"])
        mailComposerVC.setSubject("儲值錯誤")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
}

// MARK: - Alert Function
extension IAPManager{
    /// 顯示只有確定的 Alert
    private func showSureAlert(Title title : String? , Message message:String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "確定", style: .cancel) { (_) in
            self.isShowAlert = false
            self.nowIsTransaction(Is: false)
        }
        alert.addAction(cancel)
        DispatchQueue.main.async {
            // 跳出 Alert
            if !self.isShowAlert{
                self.isShowAlert = true
                self.rootVC.getTopViewcontroller()?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /// 購買確認 Alert
    ///
    /// - Parameters:
    ///   - title: 訊息 Title
    ///   - message: 商品資訊
    private func showBuyAlert(Product product : SKProduct, Title title: String? , Message message:String?){
        if self.isTransactionInProgress {
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let buy = UIAlertAction(title: "購買", style: .default) { (action) in
            // 取得商品訂單
            // 兩種 Payment 建立方式
//            let payment = SKPayment(product: self.productsArray[self.selectProductIndex])
            let payment = SKMutablePayment(product: product)
            payment.applicationUsername = "buy coin now "
            
            // 加入付款佇列以便啟動交易，交易觀察者會持續使用它的 Delegate 方法告知交易的各個狀態
            SKPaymentQueue.default().add(payment)
            self.nowIsTransaction(Is: true)
            self.isShowAlert = false
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (_) in
            self.isShowAlert = false
            self.nowIsTransaction(Is: false)
        }
        
        alert.addAction(buy)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            if !self.isShowAlert {
                self.isShowAlert = true
                self.rootVC.getTopViewcontroller()?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
