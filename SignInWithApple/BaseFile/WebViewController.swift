//
//  WebViewController.swift
//  SignInWithApple
//
//  Created by Uran on 2020/3/5.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let signWithAppleHtmlUrl = Bundle.main.url(forResource: "SignWithApple", withExtension: "html")
        else {
            return
        }
        NSLog("signWithAppleHtmlUrl : \(signWithAppleHtmlUrl)")
        let request = URLRequest(url: signWithAppleHtmlUrl)
        self.webView.load(request)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension WebViewController : WKUIDelegate{
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?{
        return nil
    }
    func webViewDidClose(_ webView: WKWebView){
        
    }
    @available(iOS 13.0 , *)
    private func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKContextMenuElementInfo) -> Bool{
        return true
    
    }
    @available(iOS 13.0 , *)
    private func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKContextMenuElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController?{
        return self
    }
    
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController){
        
    }
    func webView(_ webView: WKWebView, contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void){
        completionHandler(.none)
    }

    
    func webView(_ webView: WKWebView, contextMenuWillPresentForElement elementInfo: WKContextMenuElementInfo){
        
    }

    func webView(_ webView: WKWebView, contextMenuForElement elementInfo: WKContextMenuElementInfo, willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating){
        
    }

    
    func webView(_ webView: WKWebView, contextMenuDidEndForElement elementInfo: WKContextMenuElementInfo){
        
    }
    //MARK: Javascript
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void){
        completionHandler()
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void){
        completionHandler(true)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void){
        completionHandler("Hello world")
    }
}
extension WebViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        NSLog("didFail error : \(error.localizedDescription)")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        NSLog("didFailProvisionalNavigation : \(error.localizedDescription)")
    }
}
