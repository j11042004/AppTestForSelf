//
//  GameElements.swift
//  SpriteKitSimpleGame
//
//  Created by Uran on 2017/12/25.
//  Copyright © 2017年 Uran. All rights reserved.
//

import Foundation
import SpriteKit

struct CollisionBitMask {
    static let birdCategory:UInt32 = 0x1 << 0
    static let pillerCategory:UInt32 = 0x1 << 1
    static let flowerCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
}
extension GameScene{
    // 建立鳥
    func createBird() -> SKSpriteNode {
        // 設定玩家控制的鳥，它的 SKSpriteNode name，大小，所在位址
        let bird = SKSpriteNode(texture: SKTextureAtlas(named: "player").textureNamed("bird1"))
        bird.size = CGSize(width: 50, height: 50)
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        // 設定物理碰撞的位置
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width/2)
        // 決定線性的比率
        bird.physicsBody?.linearDamping = 1.1
        // 決定反彈的比率
        bird.physicsBody?.restitution = 0
        
        bird.physicsBody?.categoryBitMask = CollisionBitMask.birdCategory
        bird.physicsBody?.collisionBitMask =  CollisionBitMask.pillerCategory | CollisionBitMask.groundCategory
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.pillerCategory | CollisionBitMask.flowerCategory | CollisionBitMask.groundCategory
        
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    // 建立各個 button
    func createRestartBtn(){
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width: 100, height:100)
        restartBtn.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        // 設定 restartBtn 最後大小比例與 duration
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    func createPauseBtn(){
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width: 40, height:40)
        pauseBtn.position = CGPoint.init(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    func createScoreLabel() -> SKLabelNode{
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height/2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        let scoreBgRect = CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100))
        scoreBg.path = CGPath(roundedRect: scoreBgRect, cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }
    func createHighScoreLabel() -> SKLabelNode{
        let highscoreLabel = SKLabelNode()
        highscoreLabel.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore") {
            highscoreLabel.text = "Highest Score: \(highestScore)"
        }else{
            highscoreLabel.text = "Highest Score: 0"
        }
        highscoreLabel.zPosition = 5
        highscoreLabel.fontSize = 15
        highscoreLabel.fontName = "Helvetica-Bold"
        return highscoreLabel
    }
    func createLogo(){
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "logo")
        logoImg.size = CGSize(width: 272, height: 65)
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 100)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(by: 1.0, duration: 0.3))
    }
    func createTaptoplayLabel() -> SKLabelNode{
        let taptopLayLabel = SKLabelNode()
        taptopLayLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY-100)
        taptopLayLabel.text = "Tap anywhere to play"
        taptopLayLabel.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptopLayLabel.zPosition = 5
        taptopLayLabel.fontSize = 20
        taptopLayLabel.fontName = "HelveticaNeue"
        return taptopLayLabel
    }
    func createWalls()->SKNode{
        // 準備 flower
        let flowerNode = SKSpriteNode(imageNamed: "flower")
        flowerNode.size = CGSize(width: 40, height: 40)
        flowerNode.position = CGPoint(x: self.frame.width+25, y: self.frame.height/2)
        flowerNode.physicsBody = SKPhysicsBody(rectangleOf: flowerNode.size)
        flowerNode.physicsBody?.affectedByGravity = false
        flowerNode.physicsBody?.isDynamic = false
        flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.flowerCategory
        flowerNode.physicsBody?.collisionBitMask = 0
        flowerNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        flowerNode.color = SKColor.blue
        
        // 準備 牆壁
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "piller")
        let btmWall = SKSpriteNode(imageNamed: "piller")
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height/2+420)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height/2-420)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillerCategory
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.isDynamic = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = CollisionBitMask.pillerCategory
        btmWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.affectedByGravity = false
        btmWall.physicsBody?.isDynamic = false
        
        topWall.zPosition = CGFloat(Double.pi)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        let randomPosition = random(max: -200, min: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        
        wallPair.addChild(flowerNode)
        
        wallPair.run(moveAndRemove)
        return wallPair
    }
    
    func random(max: CGFloat,  min:CGFloat) -> CGFloat {
        let random = Float(arc4random()) / 0xFFFFFFFF
        let cgfloatRandom = CGFloat(random)
        let maxMinRandom = cgfloatRandom*(max-min)+200
        
        return maxMinRandom
    }
}

