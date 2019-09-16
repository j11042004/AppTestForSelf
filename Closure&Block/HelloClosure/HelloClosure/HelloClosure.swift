//: Playground - noun: a place where people can play

import UIKit
import Foundation

class People : NSObject{
    typealias OverEighteen = (_ name : String , _ age : Int) -> Bool
    // 請參閱 HelloRssParser 中的 RssParser.swift 檔
    var checkAge : OverEighteen?
    private var age : Int = -1
    private var name : String = ""
    func cheakAdult(name : String , birthAge : Int , result : @escaping OverEighteen) {
        let age = 2018 - birthAge
        self.age = age
        self.name = name
        
        self.checkAge = result
        
        self.httpFunc()
        self.propertyClosure()
    }
    
    // 因Playground 現還未支援所以要跑在模擬器上
    private func httpFunc(){
        let url : URL = URL.init(string: "https://www.google.com")!
        let request = URLRequest(url: url)
        let configure = URLSessionConfiguration.default
        let session = URLSession(configuration: configure)
        session.dataTask(with: request) { (data, response, error) in
            // cheakAdult 的 Closure 在此才會被送出
            guard let _ = self.checkAge?(self.name , self.age) else{
                fatalError("checkAge is nil")
            }
            
        }.resume()
        
    }
    /** 實現 變數 Closure */
    func propertyClosure(){
        var nameAction : (_ name : String , _ action : String)->Void
        nameAction = { name,action in
            NSLog("Name:\(name),Action: \(action)")
        }
        nameAction("Jack","play")
    }
    
}


