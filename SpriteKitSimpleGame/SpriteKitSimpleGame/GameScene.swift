//
//  GameScene.swift
//  SpriteKitSimpleGame
//
//  Created by Uran on 2017/12/25.
//  Copyright © 2017年 Uran. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var isGameStarted : Bool = false
    var isDied : Bool = false
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    var score : Int = 0
    var scoreLabel = SKLabelNode()
    var highScoreLbl = SKLabelNode()
    var tapTopLayLbl = SKLabelNode()
    
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    
    // Create the bird atlas for animation
    let birdAtlas = SKTextureAtlas(named: "player")
    var birdSprites = Array<SKTexture>()
    var bird = SKSpriteNode()
    var repeatActionBird = SKAction()
    
    
    
    override func didMove(to view: SKView) {
        //建立場景
        self.createScene()
    }
    
    
    
    // 點擊畫面時，會進行的事
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 若是，未進行遊戲，讓 bird 開始動作，同時建立 pause btn
        if !isGameStarted {
            isGameStarted = true
            bird.physicsBody?.affectedByGravity = true
            createPauseBtn()
            // 移動 logo
            logoImg.run(SKAction.scale(to: 1.0, duration: 0.3), completion: {
                self.logoImg.removeFromParent()
            })
            tapTopLayLbl.removeFromParent()
            
            self.bird.run(repeatActionBird)
            // add the wall
            let spawn = SKAction.run({ () in
                self.wallPair = self.createWalls()
                self.addChild(self.wallPair)
            })
            let delay = SKAction.wait(forDuration: 1.5)
            let spawnDelay = SKAction.sequence([spawn,delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePillers = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008*distance))
            let removePillers = SKAction.removeFromParent()
            // 設定牆壁移動動作
            moveAndRemove = SKAction.sequence([movePillers,removePillers])
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        }else{
            if !isDied{
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
        }
        
        
        for touch in touches{
            let location = touch.location(in: self)
            if isDied == true{
                // 判斷 resatart btn 是否被按到
                if restartBtn.contains(location){
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < Int(scoreLabel.text!)!{
                            UserDefaults.standard.set(scoreLabel.text, forKey: "highestScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    restartScene()
                }
            } else {
                // 判斷 pauseBtn 是否被按到
                if pauseBtn.contains(location){
                    NSLog("pauseBtn.contains")
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
            }
        }
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        if isGameStarted {
            if !isDied {
                enumerateChildNodes(withName: "background", using: { (node, error) in
                    guard let bg = node as? SKSpriteNode else{
                        NSLog("bg is not SKSpriteNode")
                        return
                    }
                    bg.position = CGPoint(x: bg.position.x-2, y: bg.position.y)
                    // 若是 bg的位址x 小於 - bg 的寬
                    if bg.position.x <= -bg.size.width{
                         bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
                    }
                })
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        // 判斷 game over 或是碰到金幣
        if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.pillerCategory
            || firstBody.categoryBitMask == CollisionBitMask.pillerCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory
            || firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory
            || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory{
            enumerateChildNodes(withName: "wallPair", using: { (node, error) in
                node.speed = 0
                self.removeAllActions()
            })
            // 若死亡
            if !isDied{
                isDied = true
                self.createRestartBtn()
                //  移除 pause button
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.flowerCategory {
            
            run(coinSound)
            score += 1
            self.scoreLabel.text = "\(score)"
            secondBody.node?.removeFromParent()
            
        } else if firstBody.categoryBitMask == CollisionBitMask.flowerCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            
            run(coinSound)
            score += 1
            self.scoreLabel.text = "\(score)"
            firstBody.node?.removeFromParent()
            
        }
    }
// MARK: Function
    //建立場景
    func createScene() {
        // 建立 背景畫面
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        // set backGround
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint(x: 0, y: 0)
            background.position = CGPoint.init(x: CGFloat(i) * self.frame.width, y: 0)
            background.name = "background"
            if let view = self.view {
                background.size = view.bounds.size
            }else{
                background.size = self.frame.size
            }
            // 把 background 加到 view 上
            self.addChild(background)
        }
        
        // 先準備好 bird 的各種狀態
        let bird1 = birdAtlas.textureNamed("bird1")
        let bird2 = birdAtlas.textureNamed("bird2")
        let bird3 = birdAtlas.textureNamed("bird3")
        let bird4 = birdAtlas.textureNamed("bird4")
        birdSprites.append(bird1)
        birdSprites.append(bird2)
        birdSprites.append(bird3)
        birdSprites.append(bird4)
        
        self.bird = createBird()
        self.addChild(self.bird)
        // 決定 bird 動畫要更換的圖片以及更換的間隔秒數
        let animateBird = SKAction.animate(with: self.birdSprites, timePerFrame: 0.1)
        self.repeatActionBird = SKAction.repeatForever(animateBird)
        
        // 準備畫面上的 ui
        scoreLabel = createScoreLabel()
        self.addChild(scoreLabel)
        
        highScoreLbl = createHighScoreLabel()
        self.addChild(highScoreLbl)
        
        createLogo()
        
        tapTopLayLbl = createTaptoplayLabel()
        self.addChild(tapTopLayLbl)
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        score = 0
        createScene()
    }
}
