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
        self.checkAge = result
        self.age = age
        self.name = name
        
        self.httpFunc()
    }
    
    // 因Playground 現還未支援所以要跑在模擬器上
    private func httpFunc(){
        let url : URL = URL.init(string: "https://www.google.com")!
        let request = URLRequest(url: url)
        let configure = URLSessionConfiguration.default
        let session = URLSession(configuration: configure)
        session.dataTask(with: request) { (data, response, error) in
            let bo = self.checkAge?(self.name , self.age)
            print(bo)
        }.resume()
        
    }
    
    
}


let sam = People()
sam.cheakAdult(name: "Sam", birthAge: 1991) { (name, age) -> Bool in
    print(name)
    print(age)
    
    return age < 18 ? false : true
}




