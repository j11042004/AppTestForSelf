//: Playground - noun: a place where people can play

import UIKit
import Foundation
//  Protocol 與 Class 不同
// Class 與繼承
public class Animal : NSObject{
    public func makeSound(){
        fatalError("子類別 記得實作 叫聲")
    }
    public func eatFood(){
        fatalError("子類別 記得實作 吃的")
    }
    public func livePlace(){
        print("生活在地球上")
    }
}

public class DogSubClass : Animal{
    // 若子類別沒有實作父類別
    public override func livePlace() {
        // 重做並覆寫
        super.livePlace()
        print("生活在陸地上")
    }
}


let dog1 : DogSubClass = DogSubClass()
// 若為重做就呼叫 或是 做了又在 super.Function 就會觸發 fatalError()
dog1.livePlace()
//dog1.makeSound()
//dog1.eatFood()



public protocol Sound {
    func makeSound()
}
// 比起用 Class 使用 Struct 會更好
struct Cat : Sound{
    func makeSound() {
        print("喵喵喵！")
    }
    var food : String
    
}
var cat : Cat = Cat(food: "fish")

print(cat.food)
cat.makeSound()
