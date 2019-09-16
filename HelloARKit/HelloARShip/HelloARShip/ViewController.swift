//
//  ViewController.swift
//  HelloARShip
//
//  Created by Uran on 2018/3/8.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        self.sceneView.delegate = self
        
        // 顯示Fps 以及其他的一些相關訊息
        self.sceneView.showsStatistics = true
        // 顯示特徵點，幫助尋找 水平面
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // SceneKit將自動地增加亮度到這個場景中
        sceneView.automaticallyUpdatesLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.restartSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        self.sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches{
            let point = touch.location(in: self.sceneView)
            let hitPlaneExtrnts = self.sceneView.hitTest(point, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
            guard let hitPlaneExtrnt = hitPlaneExtrnts.first else{
                return
            }
            let translation = hitPlaneExtrnt.worldTransform.translation
            let x = translation.x
            let y = translation.y
            let z = translation.z
            guard let shipScene = SCNScene(named: "ship.scn") , let shipNode = shipScene.rootNode.childNode(withName: "ship", recursively: false) else{
                return
            }
            shipNode.position = SCNVector3(x,y,z)
            sceneView.scene.rootNode.addChildNode(shipNode)
        }
    }
    // MARK: Normal Function
    /// 重新設定 ARSceneView
    func restartSession() {
        // Restart session with a different worldAlignment - prevents bug from crashing app
        self.sceneView.session.pause()
        // 通知AR 去尋找水平面，並且自動增加 anchor，增加 anchor 時自動，呼叫 Delegete 中的 didadd 方法
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration, options: [
            .resetTracking,
            .removeExistingAnchors])
    }
    // 告知session 錯誤
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        NSLog("error : \(error.localizedDescription)")
        // 防止 開啟後突然進入 背景模式出現 Required sensor failed. 錯誤
        if let arError = error as? ARError {
            NSLog("ARerror code : \(arError.errorCode)")
            switch arError.errorCode {
            case 102:
                configuration.worldAlignment = .gravity
                self.restartSession()
            default:
                self.restartSession()
            }
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

extension ViewController : ARSCNViewDelegate{
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    // 每次有 ARAnchor 被加進 sceneView 的 Session 時被呼叫
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        NSLog("add new node")
        // 新建一個Plane 到 Node 上
        guard let planeAnchor = anchor as? ARPlaneAnchor else{
            return
        }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        // 設定平面的顏色
        plane.materials.first?.diffuse.contents = UIColor.init(red: 135/255, green: 206/255, blue: 250/255, alpha: 0.8)
        
        let planeNode = SCNNode(geometry: plane)
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -Float.pi/2
        
        node.addChildNode(planeNode)
    }
    // 當 Node 被更新時被呼叫
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 看 PlaneNode 是否存在
        guard let planeAnchor = anchor as? ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else {
                return
        }
        // 擴張 planeNode 的 寬高
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        // 更新 planeNode 的位置
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
}
// 擴展一個 translation 讓 float4x4 可以直接取得 float3 的值
extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

