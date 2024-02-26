//
//  GameScene.swift
//  MagicBalls
//
//  Created by Mustafa Bekirov on 18.02.2024.
//

import SpriteKit
import CoreMotion
import WebKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var startButton: SKLabelNode!
    var ball: SKSpriteNode!
    var motionManager: CMMotionManager!
    var lastUpdateTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    var platforms: [SKSpriteNode] = []
    var gameOver = false
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        createStartButton()
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        // Start timer
        let wait = SKAction.wait(forDuration: 30)
        let gameOverAction = SKAction.run {
            self.gameOver
        }
        run(SKAction.sequence([wait, gameOverAction]))
    }
    
    func createStartButton() {
        startButton = SKLabelNode(text: "Start")
        startButton.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(startButton)
    }
    
    func startGame() {
        startButton.removeFromParent()
        
        // Create ball
        ball = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        addChild(ball)
        
        // Create platforms
        let platformSize = CGSize(width: frame.width, height: 20)
        let platform = SKSpriteNode(color: .green, size: platformSize)
        platform.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(platform)
        platforms.append(platform)
        
        // Add movement to platforms
        let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 25), duration: 1)
        let moveLoop = SKAction.repeatForever(SKAction.sequence([moveUp]))
        platform.run(moveLoop)
    }
    
    func moveBall() {
        if let accelerometerData = motionManager.accelerometerData {
            let acceleration = accelerometerData.acceleration
            let speed: CGFloat = 50
            
            let newX = ball.position.x + CGFloat(acceleration.x) * speed
            let newY = ball.position.y
            
            ball.position = CGPoint(x: newX, y: newY)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !gameOver {
            if lastUpdateTime == 0 {
                lastUpdateTime = currentTime
            } else {
                deltaTime = currentTime - lastUpdateTime
                lastUpdateTime = currentTime
            }
            moveBall()
            
            for platform in platforms {
                if ball.intersects(platform) {
                    gameOver
                    return
                }
            }
        }
    }
    
    func gameOver() {
        gameOver = true
        motionManager.stopAccelerometerUpdates()
        
        let url = URL(string: "https://2llctw8ia5.execute-api.us-west-1.amazonaws.com/prod")!
        let webView = WKWebView(frame: self.frame)
        webView.load(URLRequest(url: url))
        
        if let view = self.view {
            view.addSubview(webView)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, startButton.contains(touch.location(in: self)) {
            startGame()
        }
    }
}
