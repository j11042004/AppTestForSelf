//
//  MarkViewController.swift
//  FaceDetection
//
//  Created by Uran on 2019/6/5.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit

import Vision
import AVFoundation
class MarkViewController: UIViewController {
//    let img = UIImage(named: "people.png")
//    let img = UIImage(named: "girl.jpg")
    let img = UIImage(named: "man.jpg")

    @IBOutlet weak var imgView: UIImageView!
    
    let faceDetectionHandle = VNSequenceRequestHandler()
    let faceLandmarkHandle = VNSequenceRequestHandler()
    /// 臉部辨識 Request
    let faceRectRequest = VNDetectFaceRectanglesRequest()
    /// 臉部座標 Request
    let faceLandmarkRequest = VNDetectFaceLandmarksRequest()
    
    var imgCurrentFrame : CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgView.image = self.img
    }
    

    @IBAction func faceLandMark(_ sender: Any) {
        self.imgView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        guard
            let image = self.img ,
            let ciImg = CIImage(image: image)
        else {return}
        
        self.detectFaceRect(ciImg)
    }
}

extension MarkViewController{
    func detectFaceRect(_ img : CIImage){
        DispatchQueue.main.async {
            // 取得 Image 在 ImageView 上的 Frame
            self.imgCurrentFrame = AVMakeRect(aspectRatio: self.imgView.image!.size, insideRect: self.imgView.bounds)
        }
        DispatchQueue(label: "DetectFaceQueue", qos: .background, target: .global()).async
        {
            try? self.faceDetectionHandle.perform([self.faceRectRequest], on: img)
            guard
                let results = self.faceRectRequest.results as? [VNFaceObservation],
                results.count > 0
                else {
                    self.faceLandmarkRequest.inputFaceObservations = nil
                    return
            }
            self.faceLandmarkRequest.inputFaceObservations = results
            self.detectLandMarks(on: img)
        }
    }
    
    func detectLandMarks(on img : CIImage){
        DispatchQueue(label: "DetectFaceLandMarksQueue", qos: .background, target: .global()).async
        {
            try? self.faceLandmarkHandle.perform([self.faceLandmarkRequest], on: img)
            guard let faceObservations = self.faceLandmarkRequest.results as? [VNFaceObservation] else {
                return
            }
            
            NSLog("一共有 \(faceObservations.count) 張臉")
            // 取的所有臉部的特徵座標軸
            for observation in faceObservations{
                // 取得所有臉部特徵的座標軸
                guard
                    let allPoints = observation.landmarks?.allPoints
                    else {continue}
                let frame : CGRect = self.imgCurrentFrame
                
                self.process(landMark: allPoints, from: frame)
            }
        }
    }
    
    /// 處理取得的 LandMark 資訊
    func process(landMark info : VNFaceLandmarkRegion2D , from frame : CGRect){
        // 取得的 Point 座標點是以數學 座標 顯示
        let points = info.pointsInImage(imageSize: frame.size)
        let currentPoints : [CGPoint] = points.map(){ (point) -> CGPoint in
            return self.getCurrent(point: point, on: frame)
        }
        self.drawLandmarkLine(currentPoints)
    }
    
    /// 取得正確的 臉部辨識座標點
    ///
    /// 因此座標點標記的方式是用地圖的 X Y 軸(數學的座標軸)進行標記，
    /// 所以要把它轉成 Frame 的座標軸，否則會上下顛倒
    ///
    /// - Parameters:
    ///   - point: 在指定 Image Size 上的座標點
    ///   - frame: 該 Image 在 ImageView 上的 Frame
    func getCurrent(point : CGPoint , on frame : CGRect) -> CGPoint{
        let x = point.x
        let y = frame.size.height - point.y + frame.minY
        let currentPoint = CGPoint(x: x, y: y)
        DispatchQueue.main.async {
            let rect = UIView(frame: CGRect(x: x, y: y, width: 2, height: 2))
            rect.backgroundColor = UIColor.red
            self.imgView.addSubview(rect)
        }
        return currentPoint
    }
    
    func drawLandmarkLine(_ points : [CGPoint]){
        DispatchQueue.main.async {
            let vertices : [Vertex] = points.map()
            { (point) -> Vertex in
                return Vertex(x: Double(point.x), y: Double(point.y))
            }
            let triangles = Delaunay().triangulate(vertices)
            
            for triangle in triangles{
                let layer = CAShapeLayer()
                layer.path = triangle.path()
                layer.lineWidth = 1
                layer.strokeColor = UIColor.green.cgColor
                layer.fillColor = UIColor.clear.cgColor
                layer.backgroundColor = UIColor.clear.cgColor
                self.imgView.layer.addSublayer(layer)
            }
        }
    }
}
