//
//  ViewController.swift
//  HelloWkWebView
//
//  Created by Uran on 2018/11/16.
//  Copyright © 2018 Uran. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        self.webView.navigationDelegate = self
        let urlStr = "https://www.google.com.tw/"
        let url : URL = URL(string: urlStr)!
        let request = URLRequest(url: url)
        self.webView.load(request)
    }


}
extension ViewController : WKUIDelegate{
    
}
extension ViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        //1
        NSLog("decidePolicyFor navigationAction : \(navigationAction.request.url?.absoluteString)")
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        //2 開始 Loding 網頁內容
        NSLog("開始 Loding 網頁內容 : \(webView.url?.absoluteString)")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void){
        //4 接收到網頁的回應後 決定是否要繼續加載
        NSLog("決定是否要繼續加載 url : \(navigationResponse.response.url)")
        guard let urlResponse = navigationResponse.response as? HTTPURLResponse else {
            decisionHandler(WKNavigationResponsePolicy.allow)
            return
        }
        if navigationResponse.response.url?.absoluteString != "https://www.google.com.tw/" {
            decisionHandler(WKNavigationResponsePolicy.cancel)
            return
        }
        NSLog("decidePolicyFor navigationResponse")
        let responsePolicy : WKNavigationResponsePolicy = urlResponse.statusCode == 200 ? .allow : .cancel
        decisionHandler(responsePolicy)
    }
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!){
        NSLog("didReceiveServerRedirectForProvisionalNavigation")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        NSLog("didFailProvisionalNavigation navigation error : \(error.localizedDescription)")
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        //5
        NSLog("didCommit navigation")
    }
    // 確認 Https 的許可證
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        //3
        //7
        NSLog("didReceive challenge")
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if challenge.previousFailureCount == 0 {
                NSLog("Https 憑證確認且未發現 Failure")
                completionHandler(URLSession.AuthChallengeDisposition.useCredential,nil)
            }else {
                NSLog("Https 憑證確認但發現 Failure 的次數 ：\(challenge.previousFailureCount)")
                completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge,nil)
            }
        }else {
            NSLog("Https 憑證不被確認")
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge , nil)
        }
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        NSLog("webViewWebContentProcessDidTerminate")
    }
    //MARK: 網頁加載 Result
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        // 6
        NSLog("Web 成功顯示")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        NSLog("Web 無法成功顯示取得 Error : \(error.localizedDescription)")
    }
}
