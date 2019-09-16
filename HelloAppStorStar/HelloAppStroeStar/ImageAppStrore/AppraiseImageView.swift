//
//  AppraiseView.swift
//  NextLaunch
//
//  Created by Uran on 2018/5/11.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class AppraiseImageView: UIView {
    /// 評價數值
    public var rating : Double?
    private weak var view : UIView!
    @IBOutlet private weak var pointView: UIView!
    @IBOutlet private weak var firstImgView: UIImageView!
    @IBOutlet private weak var secImgView: UIImageView!
    @IBOutlet private weak var thirdImgView: UIImageView!
    @IBOutlet private weak var forthImgView: UIImageView!
    @IBOutlet private weak var fifthImgView: UIImageView!
    @IBOutlet private weak var sixthImgView: UIImageView!
    @IBOutlet private weak var seventhImgView: UIImageView!
    @IBOutlet private weak var eigthImgView: UIImageView!
    @IBOutlet private weak var ninethImgView: UIImageView!
    @IBOutlet private weak var tenthImgView: UIImageView!
    private let leftStar = UIImage(named: "StarLeft.png")
    private let leftCoverStar = UIImage(named: "StarLeftCover.png")
    private let rightStar = UIImage(named: "StarRight.png")
    private let rightCoverStar = UIImage(named: "StarRightCover.png")
    
    private var maxCoverValue : CGFloat!
    private var ranges = [CGFloat]()
    private var starImgViews : [UIImageView?] {
        let array = [firstImgView ,secImgView ,thirdImgView ,forthImgView ,fifthImgView ,sixthImgView ,seventhImgView ,eigthImgView ,ninethImgView ,tenthImgView]
        return array
    }
    convenience init(){
        self.init(frame: CGRect.zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customerInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customerInit()
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        print("will toSuperview")
    }
    override func willMove(toWindow newWindow: UIWindow?) {
        print("willMove toWindow")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func customerInit(){
        view = self.loadViewfromNib()
        self.addSubview(view)
        self.maxCoverValue = self.bounds.width * 0.7
        let range = self.maxCoverValue / 10
        var value : CGFloat = 0
        // 取的 12 個區間，為了對應最小與最大的區間
        for index in 0..<self.starImgViews.count+2 {
            value = CGFloat(index) * range
            self.ranges.append(value)
        }
    }
    
    func loadViewfromNib() -> UIView {
        let xibStr = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: xibStr, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        return view
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        // 取得在 appraiseView 上 的位置
        let movedPoint = touch.location(in: self.pointView)
        var value = movedPoint.x
        // 判斷 Value 是否有超過範圍
        if value > self.maxCoverValue {
            value = self.maxCoverValue
        }
        if value < 0 {
            value = 0
        }
        // 比對最接近的值
        for index in 0..<self.ranges.count{
            let range = self.ranges[index]
            // 小於等於 maxIndex 就把對應的 imageView 換成 CoverImage
            let maxIndex = index - 1
            self.changeCoverStarImage(MaxIndex: maxIndex)
            if range > value{
                break
            }
        }
    }
    
    /// 設定評價
    ///
    /// - Parameter value: 評價得值，最小為 0，最大為 5，間隔 0.5
    public func setRating(_ value : Double?){
        self.rating = value
        guard let value = value else {
            return
        }
        var maxIndex = Int(value*2)
        if maxIndex < 0 {
            maxIndex = 0
        }
        if maxIndex > self.starImgViews.count {
            maxIndex = self.starImgViews.count
        }
        self.changeCoverStarImage(MaxIndex: maxIndex)
    }
    private func changeCoverStarImage(MaxIndex max : Int ){
        if max < 0 || max > self.starImgViews.count {
            return
        }
        // 取得 Rating的值
        let ratingValue = Double(max) / 2
        self.rating = ratingValue
        
        for index in 0..<max {
            self.starImgViews[index]?.image = index % 2 == 0 ? leftCoverStar : rightCoverStar
        }
        for index in max..<self.starImgViews.count{
            self.starImgViews[index]?.image = index % 2 == 0 ? leftStar : rightStar
        }
    }
    
}
