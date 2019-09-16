//
//  ViewController.swift
//  SunEarthMoon
//
//  Created by Uran on 2018/3/6.
//  Copyright ©
//2018年 Uran. All rights reserved.
//

import UIKit
import SceneKit
class ViewController: UIViewController {
    
    @IBOutlet weak var zFarSlider: UISlider!
    @IBOutlet weak var scnView: SCNView!
    // 建立攝影機 Node
    let cameraNode : SCNNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSceneView()
        
        
        let sunColor = UIColor.red.withAlphaComponent(0.6)
        let sunNode : SCNNode = self.makeSphere(WithRadius: 40, color: sunColor, isLighting: true, sphereStr: "太陽")
        self.scnView.scene?.rootNode.addChildNode(sunNode)
        // 讓太陽自轉
        self.rotation(node: sunNode)
        
        let earthColor = UIColor.blue.withAlphaComponent(0.8)
        let earthNode : SCNNode = self.makeSphere(WithRadius: 20, color: earthColor, isLighting: false, sphereStr: "地球")
        earthNode.position = SCNVector3Make(sunNode.boundingBox.max.x*3, 0, 0)
        // 地球 Node 加到太陽 Node 上時，就可造成 公轉效果
        sunNode.addChildNode(earthNode)
        self.rotation(node: earthNode)
        
        let moonColor = UIColor.yellow.withAlphaComponent(0.8)
        let moonNode : SCNNode = self.makeSphere(WithRadius: 10, color: moonColor, isLighting: true, sphereStr: "月球")
        let moonNodeMax = earthNode.boundingBox.max.x*2
        moonNode.position = SCNVector3Make(moonNodeMax, 0, 0)
        earthNode.addChildNode(moonNode)
        self.rotation(node: moonNode)
    }
    /**建立場景View*/
    func setSceneView(){
        self.scnView.backgroundColor = UIColor.lightGray
        // 建立一個場景
        let scene : SCNScene = SCNScene()
        // 設定場景View 中的 Scene
        self.scnView.scene = scene
        
        scene.rootNode.addChildNode(self.cameraNode)

        // 設定攝影機 Node 上的 鏡頭
        self.cameraNode.camera = SCNCamera()
        // 設定攝影機位置
        self.cameraNode.position = SCNVector3Make(0, 0, 250)
        // 設定攝影機的倍率
        self.cameraNode.camera?.zFar = 2000
//        self.zFarSlider.value = self.zFarSlider.maximumValue
        
        // 將攝影機 Node 加到場景(Scene)中
    }
    
    /// 建立天體
    ///
    /// - Parameters:
    ///   - radius: 天體的大小
    ///   - color: 天體的顏色
    ///   - isLighting: 是否發光
    ///   - sphereStr: 天體上的顏色
    /// - Returns: 天體Node
    func makeSphere(WithRadius radius:CGFloat , color:UIColor , isLighting:Bool , sphereStr:String)->SCNNode{
        let sphereNode = SCNNode()
        // 建立一個圓形，並設定圓形大小
        let sphere : SCNSphere = SCNSphere(radius: radius)
        
        // 天體的顏色
        sphere.firstMaterial?.diffuse.contents = color
        // 設定 Node 的形狀
        sphereNode.geometry = sphere
        
        if isLighting{
            // 設定光源
            sphereNode.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
            // 設定光源的顏色
            let ominiLightNode : SCNNode = SCNNode()
            ominiLightNode.light = SCNLight()
            ominiLightNode.light?.type = SCNLight.LightType.omni
            ominiLightNode.light?.color = UIColor.white
            sphereNode.addChildNode(ominiLightNode)
        }
        
        
        // 在圓形加入文字
        let textNode = SCNNode()
        let text = SCNText(string: sphereStr, extrusionDepth: 2)
        let fontSize = radius*0.8
        text.font = UIFont.systemFont(ofSize: fontSize)
        text.firstMaterial?.diffuse.contents = UIColor.white
        textNode.geometry = text
        sphereNode.addChildNode(textNode)
//        self.recentNodeText(node: textNode)
        let textSize = Float(fontSize)
        textNode.position = SCNVector3Make(sphereNode.position.x - textSize, sphereNode.position.y - textSize*2/3, 0)
        return sphereNode
    }
    /**天體自轉*/
    func rotation(node:SCNNode){
        let customerAction = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)
        let repeatAction = SCNAction.repeatForever(customerAction)
        node.runAction(repeatAction)
    }
    
    /// 將 Node 重新置中
    ///
    /// - Parameter node:
    func recentNodeText(node:SCNNode){
        guard let sceneText = node.geometry as? SCNText else {
            return
        }
        var min : SCNVector3 = SCNVector3Zero
        var max : SCNVector3 = SCNVector3Zero
        sceneText.boundingBox = (min: min, max: max)
        sceneText.__getBoundingBoxMin(&min , max: &max)
        sceneText.alignmentMode = kCAAlignmentCenter
        let textHeight = max.y - min.y
        let textWidth = max.x - min.x
        let position : SCNVector3 = SCNVector3Make(-textWidth/2, -textHeight*2/3, 0)
        node.position = position
    }
    @IBAction func sliderAction(_ sender: UISlider) {
        NSLog("sender : \(Double(sender.value))")
        self.cameraNode.camera?.zFar = Double(sender.value)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        NSLog("self.scnView : \(self.scnView.frame)")
        return self.scnView
    }
}

