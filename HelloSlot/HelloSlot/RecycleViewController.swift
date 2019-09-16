//
//  RecycleViewController.swift
//  HelloSlot
//
//  Created by Uran on 2018/4/3.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class RecycleViewController: UIViewController {
    var datas = [String]()
    var index = 0
    var timer : Timer?
    
    @IBOutlet weak var lastImgView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var preImgView: UIImageView!
    @IBOutlet weak var slotView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slotView.clipsToBounds = true
        for i in 1...10
        {
            datas.append("cat\(i).jpg")
        }
        
        self.setImageView()
    }
    func setImageView(){
        if self.index == -1 || self.datas.isEmpty{
            
            return
        }
        var lastIndex = self.index - 1
        if lastIndex < 0 {
            lastIndex = self.datas.count - 1
        }
        var nextIndex = self.index + 1
        if nextIndex >= self.datas.count{
            nextIndex =  0
        }
        let lastImg = UIImage(named: datas[lastIndex])
        let nextImg = UIImage(named: datas[nextIndex])
        let image = UIImage(named: datas[self.index])
        self.lastImgView.image = lastImg
        self.imageView.image = image
        self.preImgView.image = nextImg
    }
    
    @IBAction func recycleAction(_ sender: UIButton) {
        if self.timer != nil{
            self.timer?.invalidate()
            self.timer = nil
            return
        }
        self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
        
    }
    @objc func changeImage(){
        // 用動畫更換 Image
        let transition = CATransition()
        transition.duration = 0.05
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.index += 1
        if self.index >= self.datas.count {
            self.index = 0
        }
        self.setImageView()
        self.lastImgView.layer.add(transition, forKey: nil)
        self.imageView.layer.add(transition, forKey: nil)
        self.preImgView.layer.add(transition, forKey: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
