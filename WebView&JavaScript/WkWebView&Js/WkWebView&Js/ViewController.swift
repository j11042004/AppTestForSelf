//
//  ViewController.swift
//  WkWebView&Js
//
//  Created by Uran on 2018/2/21.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var wkWebView: WKWebView!
    
    private let scriptHandle = "AppModel"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wkWebView.uiDelegate = self
        self.wkWebView.navigationDelegate = self
        
        
        let preference = WKPreferences()
        preference.minimumFontSize = 10
        // 可以使用 javaScript
        preference.javaScriptEnabled = true
        // 設定無法經由 javaScript 打開 Window 需由 ios 交互才可開啟
        preference.javaScriptCanOpenWindowsAutomatically = false
        self.wkWebView.configuration.preferences = preference
        
        // 讓 .html 使用 ios 中定義的 JavaScript 方法
        let iosScript = WKUserScript(source: "function showAlert(){ alert('載入時 通過 swift 加入的 Java Script  方法') }", injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        self.wkWebView.configuration.userContentController.addUserScript(iosScript)
        
        // 讓 JavaScript 傳送值到 Ios 方法，並定義一個方法名
        self.wkWebView.configuration.userContentController.add(self, name: self.scriptHandle)
        
        // 讀取 URL
        guard let url = Bundle.main.url(forResource: "test", withExtension: "html") else {
            NSLog("test.html is nil")
            return
        }
        let request = URLRequest(url: url)
        self.wkWebView.load(request)
        
        // 讓 wkWebView ScrollView 無法被滑動
        self.wkWebView.scrollView.isScrollEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    
    }
    
    
    @IBAction func btnCallJS(_ sender: UIButton) {
        NSLog("按鈕呼叫 java script")
        //  取得 Html 中 name 為 showInput 的 Value
        let inputValueJS = "document.getElementsByName('showInput')[0].attributes['value'].value"
        self.wkWebView.evaluateJavaScript(inputValueJS) { (result, error) in
            if let error = error {
                NSLog("get error : \(error.localizedDescription)")
                return
            }
            if let resultStr = result as? String{
                NSLog("run javascript result :\(resultStr)")
            }
        }

        
        
//
//        // 設定 javaScript 在網頁上顯示 "response"
//        let setInputValue = "document.getElementById('jsParamFuncSpan').innerHTML = 'response';"
//        self.wkWebView.evaluateJavaScript(setInputValue) { (result, error) in
//            if let error = error {
//                NSLog("get error : \(error.localizedDescription)")
//                return
//            }
//            if let resultStr = result as? String{
//                NSLog("result :\(resultStr)")
//            }
//        }

    }
    
    
    // MARK: - WKWebView Delegate
    // 準備 Load
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    // 開始 Load
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // Load 完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    // Load 失敗
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        NSLog("Load 失敗 : \(error.localizedDescription)")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        NSLog("Load 失敗 : \(error.localizedDescription)")
    }
    
    // MARK: - WKWebView UIDelegate
    // 攔截 JavaScript 的 Alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default){ ( _ ) in
            // 一定要用 completionHandler 回傳否則會 Crash
            completionHandler()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ ( _ ) in
            // 壹定要用 completionHandler 回傳否則會 Crash
            completionHandler()
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    // 攔截 JavaScript 的 輸入Alert
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        let ok = UIAlertAction(title: "Ok", style: .default) { (_) in
            guard let text = alert.textFields?.first?.text else{
                completionHandler(nil)
                return
            }
            guard let defaultText = defaultText else{
                completionHandler(nil)
                return
            }
            if text == defaultText {
                completionHandler(defaultText)
            }else{
                completionHandler(text)
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            // 壹定要用 completionHandler 回傳否則會 Crash
            completionHandler(nil)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    // 攔截 JavaScript 的 確定Alert
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default) { (_) in
            // 壹定要用 completionHandler 回傳否則會 Crash
            completionHandler(true)
            
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: {
                })
            }
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        NSLog("message name : \(message.name)")
        NSLog("message body : \(message.body)")
        NSLog("message info : \(message.frameInfo)")
    }
}

