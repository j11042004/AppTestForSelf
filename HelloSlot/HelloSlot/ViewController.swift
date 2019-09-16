//
//  ViewController.swift
//  HelloSlot
//
//  Created by Uran on 2018/4/3.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    let values = [1,2,3,4,5,6,7,8,9,0]
    var firstTimer : Timer?
    var firstValue = 0
    var secTimer : Timer?
    var secValue = 0
    var thirdTimer : Timer?
    var thirdValue = 0
    
    
    var tableTimer : Timer?
    var tableValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.pickerView.selectRow(0, inComponent: 0, animated: false)
        self.pickerView.selectRow(0, inComponent: 1, animated: false)
        self.pickerView.selectRow(0, inComponent: 2, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tableViewAction(_ sender: UIButton) {
        if self.tableTimer != nil {
            UIView.animate(withDuration: 3, animations: {
                self.tableTimer?.invalidate()
            }) { (complete) in
                self.tableTimer = nil
            }
            
            return
        }
        
        self.tableTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
            self.tableValue+=1
            if self.tableValue >= self.values.count{
                self.tableValue = 0
            }
            let index = IndexPath(row: self.tableValue, section: 0)
            self.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.middle, animated: true)
        })
    }
    
    
    @IBAction func pickerViewAction(_ sender: UIButton) {
        
        if firstTimer != nil {
            firstTimer?.invalidate()
            secTimer?.invalidate()
            thirdTimer?.invalidate()
            firstTimer = nil
            secTimer = nil
            thirdTimer = nil
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.firstTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
                
                self.firstValue+=1
                if self.firstValue >= self.values.count{
                    self.firstValue = 0
                }
                
                self.pickerView.selectRow(self.firstValue, inComponent: 0, animated: false)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
            self.secTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
                self.pickerView.selectRow(self.secValue, inComponent: 1, animated: false)
                self.secValue+=1
                if self.secValue >= self.values.count{
                    self.secValue = 0
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
            self.thirdTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
                self.pickerView.selectRow(self.thirdValue, inComponent: 2, animated: false)
                self.thirdValue+=1
                if self.thirdValue >= self.values.count{
                    self.thirdValue = 0
                }
            }
        }
    
    }

}
extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(values[row])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(self.values[row])
    }
}


extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(self.values[indexPath.row])"
        return cell
    }
}
