//
//  ViewController.swift
//  UIWebViewDemo
//
//  Created by Frank.Chen on 2017/3/28.
//  Copyright © 2017年 Frank.Chen. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol JavaScriptFuncProtocol: JSExport {
    func test(_ value: String)
    func test2(_ value: String, _ num: Int)
    func test3(_ value: String,_  num: Double)
}
// 用於 web3
class JavaScriptFunc : NSObject, JavaScriptFuncProtocol {
    func test(_ value: String) {
        print("value: \(value)")
    }
    func test2(_ value: String, _ num: Int) {
        print("value: \(value), num: \(num)")
    }
    func test3(_ value: String,_  num: Double){
        NSLog("test3 : \(value) total:\(num)")
    }
}

class ViewController: UIViewController, UIWebViewDelegate {
    
    var webView1: UIWebView!
    var webView2: UIWebView!
    var webView3: UIWebView!
    var webView4: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        
        // (一)取得bundle下的.html並顯示在WebView內
        self.web1()
        
        // (二)使用JSContext來執行JavaScript
        self.web2()
        
        // 使用 JSContext 收取自己的 html 或是 request網頁 傳回來的 js 結果
        self.callCalculatehtml()
        // (三)JavaScript call Swfit func
        // 取得bundle的SwiftUseJavaScriptDemo_2.html的內容並顯示在WebView內
        self.web3()
        
        // (四)Swfit call JavaScript func
        self.swiftCallJS()
        
    }
    func web1(){
        // (一)取得bundle下的.html並顯示在WebView內
        let path1 = Bundle.main.path(forResource: "SwiftUseJavaScriptDemo_1", ofType: "html")
        let htmlStr1: String = try! String(contentsOfFile: path1!)
        
        self.webView1 = UIWebView()
        self.webView1.frame = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height/7)
        self.webView1.loadHTMLString(htmlStr1, baseURL: nil)
        self.view.addSubview(self.webView1)
    }
    func web2(){
        // (二)使用JSContext來執行JavaScript
        let context: JSContext = JSContext()
        
        // 定義js變數和函數
        context.evaluateScript("var num1 = 10; var num2 = 20;")
        context.evaluateScript("function add(par1, par2) { return par1 + par2; }")
        
        // 方式1. 直接呼叫js函數
        let result: JSValue = context.evaluateScript("add(num1, num2)")
        print("js code result: \(result)") // 30
        
        // 方式2. 利用下標來獲取js函數並呼叫之
        let result2 = context.objectForKeyedSubscript("add").call(withArguments: [10, 20]).toString()
        print("js code result2: \(result2!)") // 30
    }
    func callCalculatehtml(){
        webView2 = UIWebView.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height/6+10, width: self.view.frame.size.width, height: self.view.frame.size.height/3-40))
        
        
        let testPath = Bundle.main.path(forResource: "test", ofType: "html")
        do {
            let calculateHtmlStr : String = try String(contentsOfFile: testPath!)
            // 讀取內部 html
            let url = Bundle.main.url(forResource: "Calaulator", withExtension: "html")
            // 讀取 網址
            let urlStr = String(format: "%@", "https://.....")
            let url2 = URL(string: urlStr)
            // 若是 calculator.html is nil
            /*
            if let url2 = url2 {
                let calculateRequest = URLRequest(url: url2)
                self.webView2.loadRequest(calculateRequest)
            }else{
                NSLog("url is nil")
                self.webView2.loadHTMLString(calculateHtmlStr, baseURL: nil)
            }*/
            let request = URLRequest.init(url: url!)
            self.webView2.loadRequest(request)
        } catch  {
            NSLog("error : \(error.localizedDescription)")
        }
        
        
        
        let jsContext = self.webView2.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(JavaScriptFunc(), forKeyedSubscript: "javaScriptCallToSwift" as (NSCopying & NSObjectProtocol)!)
        
        
        
        self.view.addSubview(webView2)
    }
    func web3(){
        // (三)JavaScript call Swfit func
        // 取得bundle的SwiftUseJavaScriptDemo_2.html的內容並顯示在WebView內
        let path3 = Bundle.main.path(forResource: "SwiftUseJavaScriptDemo_2", ofType: "html")
        let htmlStr3: String = try! String(contentsOfFile: path3!)
        
        self.webView3 = UIWebView()
        self.webView3.frame = CGRect(x: 0, y: self.view.frame.size.height/2, width: self.view.frame.size.width, height: self.view.frame.size.height/7)
        self.webView3.loadHTMLString(htmlStr3, baseURL: nil)
        self.view.addSubview(self.webView3)
        
        let jsContext = self.webView3.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(JavaScriptFunc(), forKeyedSubscript: "javaScriptCallToSwift" as (NSCopying & NSObjectProtocol)!)
    }
    func swiftCallJS(){
        // (四)Swfit call JavaScript func
        NSLog("swiftCallJS")
        let path4 = Bundle.main.path(forResource: "SwiftUseJavaScriptDemo_3", ofType: "html")
        let htmlStr4: String = try! String(contentsOfFile: path4!)
        
        self.webView4 = UIWebView()
        self.webView4.frame = CGRect(x: 0, y: self.view.frame.size.height*4/6, width: self.view.frame.size.width, height: self.view.frame.size.height/7)
        self.webView4.loadHTMLString(htmlStr4, baseURL: nil)
        self.view.addSubview(self.webView4)
        
        // 生成Call JS Button
        let callJSBtn: UIButton = UIButton()
        callJSBtn.frame = CGRect(x: 0, y: webView4.frame.maxY, width: 200, height: 50)
        callJSBtn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        callJSBtn.setTitle("callJS", for: .normal)
        callJSBtn.layer.cornerRadius = 10
        callJSBtn.layer.masksToBounds = true
        callJSBtn.backgroundColor = UIColor.darkGray
        callJSBtn.addTarget(self, action: #selector(ViewController.callJS(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(callJSBtn)
    }
    // Call JS Event
    func callJS(_ sender: UIButton) {
        // 獲得指定 webView 頁面中的上下文
        guard let jsContext = self.webView4.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext else{
            return
        }
        // 取得 javaScript 的 方法
        guard let jsFunc =  jsContext.objectForKeyedSubscript("fromNative") else{
            return
        }
        // 傳值進入
        guard let d = jsFunc.call(withArguments: [Int(arc4random_uniform(10) + 1)]) else{
            return
        }
        print("returnValue : \(d)")
    }
    
    // UIWebViewDelegate function
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(JavaScriptFunc(), forKeyedSubscript: "javaScriptCallToSwift" as (NSCopying & NSObjectProtocol)!)
        return true
    }
}

