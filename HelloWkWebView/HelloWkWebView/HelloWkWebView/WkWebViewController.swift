//
//  WkWebViewController.swift
//  HelloWkWebView
//
//  Created by Uran on 2018/11/16.
//  Copyright © 2018 Uran. All rights reserved.
//

import UIKit
import WebKit

class WkWebViewController: UIViewController {

    @IBOutlet weak var wkWebView: WKWebView!
    typealias AlerActionHandle = ((_ action : UIAlertAction) -> Void)
    
    let jsCancelAlertHtml = "<!DOCTYPE html><html><body><p>Click the button to display an alert box.</p><button onclick=\"myFunction()\">Try it</button><script>function myFunction() {    alert(\"確定吧!雜種!\");}</script></body></html>"
    let jsConfirmAlertHtml = "<!DOCTYPE html><html><body><p>Click the button to display a confirm box.</p><button onclick=\"myFunction()\">Try it</button><script>function myFunction() {    confirm(\"選擇吧!雜種!\");}</script></body></html>"
    
    let jsTextFieldAlertHtml = "<!DOCTYPE html><html><body><h2>JavaScript Prompt</h2><button onclick=\"myFunction()\">Try it</button><p id=\"demo\"></p><script>function myFunction() {    var txt;    var person = prompt(\"Please enter your name:\", \"Harry Potter\");    if (person == null || person == \"\") {        txt = \"User cancelled the prompt.\";    } else {        txt = \"Hello \" + person + \"! How are you today?\";    }    document.getElementById(\"demo\").innerHTML = txt;}</script></body></html>"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wkWebView.navigationDelegate = self
        self.wkWebView.uiDelegate = self
        
        if self.navigationController != nil {
            let reloadItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: #selector(self.reloadWkWebView(_:)))
            self.navigationItem.rightBarButtonItems = [reloadItem]
            self.reloadWkWebView(reloadItem)
        }
        
    }
}
//MARK: - Private Function
extension WkWebViewController{
    
    @objc private func reloadWkWebView(_ sender : UIBarButtonItem){
        let urlStr = "https://www.google.com.tw/"
        let url : URL = URL(string: urlStr)!
        let request = URLRequest(url: url)
        self.wkWebView.load(request)
        
//        self.wkWebView.loadHTMLString(self.jsTextFieldAlertHtml, baseURL: nil)
        
    }
    private func showAlert(Title title : String? ,
                            Message message:String? ,
                                  Sure sure:String? = nil,
                             Cancel cancel : String = "取消" ,
                     SureHandle sureHandle : AlerActionHandle? = nil ,
                 CancelHandle cancelHandle : AlerActionHandle? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: cancel, style: .cancel, handler: cancelHandle)
        if let sure = sure {
            let sure = UIAlertAction(title: sure, style: .default, handler: sureHandle)
            alert.addAction(sure)
        }
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    private func showAlert(Title title : String? ,
                           Message message:String? ,
                           InputTextFieldNum num: Int ,
                           HolderArray holders : String...,
                           Sure sure:String? = nil,
                           Cancel cancel : String = "取消" ,
                           SureHandle sureHandle : AlerActionHandle? = nil ,
                           CancelHandle cancelHandle : AlerActionHandle? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: cancel, style: .cancel, handler: cancelHandle)
        let runRange = 0..<num
        for index in runRange {
            alert.addTextField { (textField) in
                if index >= holders.count {
                    return
                }
                textField.placeholder = holders[index]
            }
        }
        if let sure = sure {
            let sure = UIAlertAction(title: sure, style: .default, handler: sureHandle)
            alert.addAction(sure)
        }
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

extension WkWebViewController : WKUIDelegate{
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?{
/* 自製 Configuration 設定 WkwebView 屬性
        let webConfigure = WKWebViewConfiguration()
        if #available(iOS 10.0, *){
            webConfigure.dataDetectorTypes = .all
        }
        // 允許在線播放
        webConfigure.allowsInlineMediaPlayback = true
        // 允許使用 JS
        webConfigure.preferences.javaScriptEnabled = true
        // 允許 JS 打開窗口
        webConfigure.preferences.javaScriptCanOpenWindowsAutomatically = true
 */
        let configureWeb = WKWebView(frame: self.wkWebView.bounds, configuration: configuration)
        return configureWeb
    }
    
    @available(iOS 9.0, *)
    func webViewDidClose(_ webView: WKWebView){
        NSLog("close WebView")
    }
    // 顯示 javascript 的 Alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void){
        
        NSLog("javascript Alert message : \(message)")
        self.showAlert(Title: nil, Message: message)
        
        completionHandler()
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void){
        NSLog("javascript Confirm message : \(message)")
        self.showAlert(Title: nil, Message: message, Sure: "開始", Cancel: "取消", SureHandle: nil, CancelHandle: nil)
        completionHandler(true)
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void){
        NSLog("TextField Alert input Str : \(prompt) , defaultText : \(defaultText)")
        let placeHolder = defaultText == nil ? "" : defaultText!
        self.showAlert(Title: nil, Message: prompt, InputTextFieldNum: 1, HolderArray: placeHolder, Sure: nil, Cancel: "OK")
        completionHandler("")
    }
    @available(iOS 10.0 , *)
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool{
        return true
    }
    @available(iOS 10.0 , *)
    func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController?{
        return self;
    }
    @available(iOS 10.0 , *)
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController){
        
    }
}
extension WkWebViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        NSLog("decidePolicyFor navigationAction")
        guard let urlStr = navigationAction.request.url?.absoluteString else{
            decisionHandler(WKNavigationActionPolicy.allow)
            return
        }
        NSLog("will action url : \(urlStr)")
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void){
        NSLog("decidePolicyFor navigationResponse")
        guard let urlStr = navigationResponse.response.url?.absoluteString else{
            decisionHandler(WKNavigationResponsePolicy.allow)
            return
        }
        NSLog("will response url : \(urlStr)")
        
        decisionHandler(WKNavigationResponsePolicy.cancel)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        NSLog("didStartProvisionalNavigation navigation")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!){
        NSLog("didReceiveServerRedirectForProvisionalNavigation")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        NSLog("didFailProvisionalNavigation navigation")
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        NSLog("didCommit navigation")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        NSLog("didFinish navigation")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        NSLog("didFail navigation")
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        NSLog("didReceive challenge")
        completionHandler(URLSession.AuthChallengeDisposition.useCredential , nil)
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        NSLog("webViewWebContentProcessDidTerminate")
    }
    
}
