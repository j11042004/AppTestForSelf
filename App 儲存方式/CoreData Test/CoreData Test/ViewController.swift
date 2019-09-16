//
//  ViewController.swift
//  CoreData Test
//
//  Created by Uran on 2017/10/3.
//  Copyright © 2017年 Uran. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var allTest = [TestObj()]
    private var request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>()
    private var dateCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let testRequest : NSFetchRequest<Test> = Test.fetchRequest()
        
        do {
            let savedArray = try context.fetch(testRequest)
            var count = 0
            for element in savedArray {
                print("\(element.number)")
                count += 1
            }
        } catch  {
            print("Data Fail")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

