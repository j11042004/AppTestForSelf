//
//  ViewController.swift
//  HelloMarquee
//
//  Created by Uran on 2019/4/15.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit
class ViewController: UIViewController , CAAnimationDelegate {
    var run : Bool = false
    @IBOutlet weak var marqueeLeading: NSLayoutConstraint!
    @IBOutlet weak var marqueeLabel: UILabel!
    @IBOutlet weak var marqueeView: UIView!
    
    @IBOutlet weak var finalMarqueeView: MarqueeView!
    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    var marqueeInfos : [NSAttributedString] = [NSAttributedString]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.marqueeView.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        self.marqueeLabel.text = nil
        self.marqueeLabel.attributedText = nil
        self.marqueeLeading.constant = UIScreen.main.bounds.width
        self.view.layoutIfNeeded()
    }

    @IBAction func hideMarquee(_ sender: Any) {
        self.finalMarqueeView.clearAllMarqueeStr()
        
        self.marqueeInfos.removeAll()
        self.marqueeLabel.layer.removeAllAnimations()
        // 要馬上更新把 animation 徹底清理乾淨
        self.marqueeLabel.layoutIfNeeded()
        
        
        self.marqueeLeading.constant = self.marqueeView.frame.width
        self.view.layoutIfNeeded()
    }
    
    @IBAction func runMarquee(_ sender: Any) {
        let resulAttributeString = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13)])
        let attributStr1 = NSAttributedString.init(string: "贊助者暱稱", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        let attributStr2 = NSAttributedString.init(string: "贊助", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
        let attributStr3 = NSAttributedString.init(string: "贊助項目", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        let attributStr4 = NSAttributedString.init(string: "87", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
        let attributStr5 = NSAttributedString.init(string: "元, 想對贊助項目說:", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        let attributStr6 = NSAttributedString(string: "贊助訊息贊助訊息贊助訊息", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
        
        resulAttributeString.append(attributStr1)
        resulAttributeString.append(attributStr2)
        resulAttributeString.append(attributStr3)
        resulAttributeString.append(attributStr4)
        resulAttributeString.append(attributStr5)
        resulAttributeString.append(attributStr6)
        
        marqueeInfos.append(resulAttributeString)
        
        self.finalMarqueeView.insertNew(Marquee: resulAttributeString)
        self.runMarquee()
    }
    func runMarquee(){
        guard
            run != true ,
            let willShowMarquee = self.marqueeInfos.first
        else {
            return
        }
        run = true
        self.marqueeInfos.removeFirst()
        
        self.marqueeLeading.constant = self.marqueeView.frame.width
        self.view.layoutIfNeeded()
        
        
        self.marqueeLabel.attributedText = willShowMarquee
        self.marqueeView.isHidden = false
        // 使用 label size to fit 容易有跑版的問題，
        // 因此用 layoutIfNeeded 去取得
        self.marqueeView.layoutIfNeeded()
        
        self.marqueeView.isHidden = false
        
        self.marqueeLeading.constant = -self.marqueeLabel.frame.width
        
        let durationTimer : TimeInterval = TimeInterval((self.marqueeLabel.frame.width + self.marqueeView.frame.width)/30)

        NSLog("durationTimer : \(durationTimer) , \(self.marqueeLabel.frame.width) , \(self.marqueeView.frame.width)")
        UIView.animate(withDuration: durationTimer, delay: 0, options: .curveLinear, animations: {
            self.marqueeView.layoutIfNeeded()
        }) { (_) in
            self.marqueeLeading.constant = self.marqueeView.frame.width
            self.marqueeView.layoutIfNeeded()
            NSLog("Animate finish")
            self.run = false
            NSLog("\(self.marqueeInfos.count)")
            if self.marqueeInfos.count > 0 {
                self.runMarquee()
            }
        }
    }
}

