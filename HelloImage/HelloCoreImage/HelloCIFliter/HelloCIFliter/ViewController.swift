//
//  ViewController.swift
//  HelloCIFliter
//
//  Created by Uran on 2018/6/27.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import CoreImage
class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var filteredImageView: UIImageView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterPicker: UIPickerView!
    @IBOutlet weak var pickerHeightConstraint: NSLayoutConstraint!
    
    /*
     要使用的濾鏡名
     所有的名稱參考在這
     https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/
     */
    
    var firstFilter : FilterType = .none
    var secondFilter : FilterType = .none
    
    let filtersName = ["原圖" , "棕色化" , "曝光率" , "黑白化" , "陰影平衡"]
    
    lazy var filters = Filter.sharedInstance.filters
    
    let filterManager = Filter.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage(named: "kiyomizu2.png")
        imageView.image = img
        
        filteredImageView.image = img
        
        ratingLabel.text = String(format: "%.f%%", ratingSlider.value)
        self.pickerHeightConstraint.constant = 0
        
        self.filterPicker.delegate = self
        self.filterPicker.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func showFilterPicker(_ sender: UIButton) {
        if sender.isSelected{
            self.pickerHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.pickerHeightConstraint.constant = 150
                self.view.layoutIfNeeded()
            }
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func changePartOfImg(_ sender: UIButton) {
        let backImg : UIImage = UIImage(named: "light.png")!
        let fountImg : UIImage = self.imageView.image!
        guard let finalCGImg = filterManager.sourceOverCompositionimage(fountImg: fountImg, backImg: backImg) else{
            NSLog("finalCGImg is nil")
            return
        }
        self.filteredImageView.image = UIImage(cgImage: finalCGImg)

    }
    
    
    @IBAction func ratingChanged(_ sender: UISlider) {
        ratingLabel.text = String(format: "%.f%%", ratingSlider.value)
        // 若兩個 Filter 都是 "" 就設為原圖
        if self.firstFilter.rawValue.count == 0 && self.secondFilter.rawValue.count == 0  {
            self.filteredImageView.image = imageView.image
            return
        }
        guard let img = imageView.image else {
            return
        }
        let rating = self.ratingSlider.value
        // 將圖片做多次濾鏡
        guard let finalImg = filterManager.filterImage(With: firstFilter,secondFilter, image: img, rate: rating) else{
            return
        }
        
        self.filteredImageView.image = finalImg
    }
    
    
    
}

extension ViewController : UIPickerViewDelegate , UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filters.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerView.subviews[1].isHidden = true
        pickerView.subviews[2].isHidden = true
        
        return filtersName[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0{
            firstFilter = filters[row]
        }
        if component == 1 {
            secondFilter = filters[row]
        }
        
        guard let img = imageView.image else {
            return
        }
        // 若選擇的多個 Filter 都為""，就設定 image 為原始圖
        if firstFilter.rawValue.count == 0 && secondFilter.rawValue.count == 0 {
            self.filteredImageView.image = img
            let filterName = filtersName[0]
            self.filterButton.setTitle(filterName, for: .normal)
            return
        }else if firstFilter.rawValue.count != 0 && secondFilter.rawValue.count == 0 {
            let index = filters.index(of: firstFilter)!
            let filterName = filtersName[index]
            self.filterButton.setTitle(filterName, for: .normal)
        }else if secondFilter.rawValue.count != 0 && firstFilter.rawValue.count == 0{
            let index = filters.index(of: secondFilter)!
            let filterName = filtersName[index]
            self.filterButton.setTitle(filterName, for: .normal)
        }else{
            if secondFilter == firstFilter{
                let index = filters.index(of: secondFilter)!
                let filterName = filtersName[index]
                self.filterButton.setTitle(filterName, for: .normal)
            }else{
                self.filterButton.setTitle("混合", for: .normal)
            }
        }
        
        let rating = self.ratingSlider.value
        // 將圖片做多次濾鏡
        guard let filteredImg = filterManager.filterImage(With: firstFilter , secondFilter, image: img, rate: rating) else{
            return
        }
        // 設定 image 到 filteredImageView
        self.filteredImageView.image = filteredImg
        
        
    }
    
    
}
