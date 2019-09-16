//
//  ViewController.swift
//  HelloSwiftARKit
//
//  Created by Uran on 2018/2/13.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import ARKit


class ViewController: UIViewController {
    let colors : [UIColor] = [UIColor.red,UIColor.blue,UIColor.green,UIColor.white,UIColor.gray,UIColor.black,UIColor.lightGray,UIColor.lightText,UIColor.purple]
    var cusAnchors = [CusAnchor]()
    @IBOutlet weak var sceneView: ARSCNView!
/*  configuration: 增加AR 的體驗
     ARWorldTrackingConfiguration :
     提供高品质的AR体验，使用后置摄像头精确跟踪设备的位置和方向，并允许平面检测和碰撞试验。
     AROrientationTrackingConfiguration :
     提供使用后置摄像头并仅跟踪设备方向的基本AR体验。
     ARFaceTrackingConfiguration :
     提供使用前置摄像头并跟踪用户脸部的移动和表情的AR体验。
     
*/
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.delegate = self
        self.sceneView.session.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 設定 SecenView
        self.reSetSceneView()
        // 顯示 XYZ 軸
//        self.sceneView.debugOptions = ARSCNDebugOptions.showWorldOrigin
        // 顯示黃點
//        self.sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        // 顯示Fps 以及其他的一些相關訊息
        self.sceneView.showsStatistics = true
        
        // SceneKit將自動地增加亮度到這個場景中
        sceneView.automaticallyUpdatesLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        
        if let anchorArray = DBManager.shared.searchAllData() {
            self.cusAnchors = anchorArray
            for cusAnchor in self.cusAnchors {
                self.sceneView.session.add(anchor: cusAnchor)
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let matrix0 : float4 = float4(0.842404, -0.081154, -0.5327, 0.0)
//        let matrix1 : float4 = float4(-0.0593368, 0.968611, -0.241397, 0.0)
//        let matrix2 : float4 = float4(0.535569, 0.234963, 0.811146, 0.0)
//        let matrix3 : float4 = float4(-0.801765, -0.288312, -0.661795, 1.0)
//        let matrix4X4 : matrix_float4x4 = matrix_float4x4.init(matrix0, matrix1, matrix2, matrix3)
//        let anchor : ARAnchor = ARAnchor(transform: matrix4X4)
//        self.sceneView.session.add(anchor: anchor)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: Touch 動作
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.sceneViewTapAction(touches)
        
    }
    
    @IBAction func screenRecordAction(_ sender: UIButton) {
        /// 擷取 ARKit SceneView 上的圖片
        let screenImg = self.sceneView.snapshot()
        guard let showVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowViewController") as? ShowViewController else {
            return
        }
        showVC.showImg = screenImg
        
        self.navigationController?.pushViewController(showVC, animated: true)
    }
    
    // MARK: Normal Function
    /// 當 SceneView 被點到時，會觸發的事情，現在先是 新增一個 Node
    ///
    /// - Parameter touches: 所有的點擊
    func sceneViewTapAction(_ touches : Set<UITouch>){
        for touch in touches {
            let point = touch.location(in: self.sceneView)
            let hitResults = self.sceneView.hitTest(point, options: nil)
            
            guard let node = hitResults.first?.node else{
                let hitResultPoints = self.sceneView.hitTest(point, types: ARHitTestResult.ResultType.featurePoint)
                if let hitResultFeaturePoint = hitResultPoints.first{
                    // 點擊到的座標位置
                    let translation = hitResultFeaturePoint.worldTransform.translation
                    self.addAnchor(x: translation.x, y: translation.y, z: translation.z)
                }
                return
            }
            // 根據 Node 刪除 Anchor
            self.deleteAnchor(node)
            
        }
    }
    
    /// 重新設定 ARSceneView，並移除 SceneView 所有的 Anchor 與 ScnNode
    func reSetSceneView() {
        // Restart session with a different worldAlignment - prevents bug from crashing app
        self.sceneView.session.pause()
/*      通知AR 去尋找水平面，並自動增加點錨Anchor 這時會自動觸發
        func renderer(SCNSceneRenderer, didAdd: SCNNode, for: ARAnchor) 這個 Delegate 方法
*/
//        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration, options: [
            .removeExistingAnchors,
            .resetTracking])
    }
    
    // MARK:- 刪除與增加 Anchor
    /// 新增一個 Box 在鏡頭前
    ///
    /// - Parameters:
    ///   - x: Box 的所在位置 X
    ///   - y: Box 的所在位置 Y
    ///   - z: Box 的所在位置 Z
    func addAnchor(x:Float = 0, y:Float = 0, z:Float = -0.6) {
        // 建立一個 Node
        let boxNode = SCNNode()
        // 設定 Node的形狀
        //        boxNode.geometry = pyramid
        
        //讓建立的 Node 隨者 Camera 的移動改變面向的位置
        // 轉向一定要在此做，否則，在Delegate function 內的 Node 無法做轉向，這會影響到 Anchor 的 rotation
        if let cameraFrame = self.sceneView.session.currentFrame {
            // 先講 boxNode 轉 90度，最後在做矩陣相乘時，會讓 BoxNode 轉 -90 度
            boxNode.eulerAngles.z = Float.pi/2
            // 設定轉動方向的是 boxNode
            let translation = boxNode.simdTransform
            // 會轉 -90 度，因先前已轉90度，所以這會轉成正常角度
            boxNode.simdTransform = matrix_multiply(cameraFrame.camera.transform, translation)
        }else{
            var translation = matrix_identity_float4x4
            // 讓 Node 被加入時放在距離鏡頭 0.6公尺的位置
            translation.columns.3.z = -0.6
            boxNode.transform = SCNMatrix4(translation)
        }
        // 設定 Node 的所在位置，要在轉換面對角度時使用，否則 BoxNode 會跑版
        boxNode.position = SCNVector3(x, y, z)
        // 在Sceneview 上新增node
        //        self.sceneView.scene.rootNode.addChildNode(boxNode)
        // 在 Session 上新增錨點
        let transform = boxNode.simdTransform
        let anchor : ARAnchor = ARAnchor(transform: transform)
        //        self.sceneView.session.add(anchor: anchor)
        DBManager.shared.insertAnchorData(anchor.transform)
        
        if let allAnchor = DBManager.shared.searchAllData() {
            self.cusAnchors = allAnchor
            if let lastAnchor = self.cusAnchors.last {
                self.sceneView.session.add(anchor: lastAnchor)
            }
        }
        
    }
    ///刪除 SceneView 上的 ARAnchor 和 ScnNode
    ///
    /// - Parameter deleteNode: 要被刪除的 ScnNode
    func deleteAnchor(_ deleteNode : SCNNode){
        // 移除 Node 所在的 anchor
        if let anchor = self.sceneView.anchor(for: deleteNode) {
            self.sceneView.session.remove(anchor: anchor)
            for kidAnchor in self.cusAnchors{
                if anchor.transform == kidAnchor.transform {
                    NSLog("kid anchor id \(kidAnchor.dataID)")
                    NSLog("相同 位置")
                    let delete = DBManager.shared.deleteData(withID: kidAnchor.dataID)
                    NSLog("delete success : \(delete)")
                    break
                }
            }
        }
        // 移除 Node
        deleteNode.removeFromParentNode()
    }
    
    
    
    
}
extension ViewController : ARSCNViewDelegate {
    
    // MARK : ARSCNViewDelegate
//        public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode?{
//            let node = self.sceneView.node(for: anchor)
//
//            return node
//        }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 取得 anchor 的 XYZ
        let x = anchor.transform.translation.x
        let y = anchor.transform.translation.y
        let z = anchor.transform.translation.z
        
        
//        let box = SCNBox(width: 0.1, height: 0.1, length: 0.05, chamferRadius: 0)
//        // 隨機顏色
//        let randumNum = Int(arc4random_uniform(UInt32(colors.count)))
//        let boxColor = colors[randumNum]
//        // 設定Box顏色
//        box.firstMaterial?.diffuse.contents = boxColor
//        box.chamferSegmentCount = 1000
//
//        // 一個平面
//        let image = UIImage(named: "sakura.jpg")!
//        let plane : SCNPlane = SCNPlane(width: 0.5, height: 0.5)
//        plane.firstMaterial?.diffuse.contents = image
//        // 一個金字塔
//        let pyramid : SCNPyramid = SCNPyramid(width: 0.3, height: 0.3, length: 0.3)
//        pyramid.firstMaterial?.diffuse.contents = UIColor.yellow
        
        
        // 一個金字塔
        let pyramid : SCNPyramid = SCNPyramid(width: 0.3, height: 0.3, length: 0.3)
        pyramid.firstMaterial?.diffuse.contents = UIColor.yellow
        // 一個平面
        let image = UIImage(named: "sakura.jpg")!
        let plane : SCNPlane = SCNPlane(width: 0.5, height: 0.5)
        plane.firstMaterial?.diffuse.contents = image
        // 設定 node 的圖型
        node.geometry = plane
        // 可重設位置，不設也沒差
        node.position = SCNVector3(x, y, z)
    }
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        NSLog("did removed a new anchor")
    }
    
}
extension ViewController : ARSessionDelegate {
    // MARK : ARSessionDelegate
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
    }
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        // 相機更換追蹤裝態時被觸發
        
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // 畫面更換時被觸發
    }
    func session(_ session: ARSession, didFailWithError error: Error) {
        // 防止 開啟後突然進入 背景模式出現 Required sensor failed. 錯誤
        if let arError = error as? ARError {
            NSLog("ARerror code : \(arError.errorCode)")
            switch arError.errorCode {
            case 102:
                self.configuration.worldAlignment = .gravity
                self.reSetSceneView()
            default:
                self.reSetSceneView()
            }
        }
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
    
}
