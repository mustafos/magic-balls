//
//  GameScene.swift
//  MagicBalls
//
//  Created by Mustafa Bekirov on 18.02.2024.
//

import SpriteKit
import GameplayKit

import SpriteKit

enum PhysicsCategory: UInt32 {
    case ball = 1
    case platform = 2
    case obstacle = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball: SKSpriteNode!
    var startButton: SKSpriteNode!
    var platforms: [SKSpriteNode] = []
    var obstacles: [SKSpriteNode] = []
    var gameStarted = false
    var gameOver = false
    var timeElapsed: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Create the ball
        ball = SKSpriteNode(imageNamed: "ball")
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.platform | PhysicsCategory.obstacle
        ball.physicsBody?.collisionBitMask = PhysicsCategory.none
        addChild(ball)
        
        // Create the start button
        startButton = SKSpriteNode(imageNamed: "startButton")
        startButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        addChild(startButton)
        
        // Create platforms
        for i in 0..<5 {
            let platform = SKSpriteNode(color: .green, size: CGSize(width: frame.width, height: 50))
            platform.position = CGPoint(x: frame.midX, y: frame.midY - CGFloat(i * 100))
            platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
            platform.physicsBody?.categoryBitMask = PhysicsCategory.platform
            platform.physicsBody?.contactTestBitMask = PhysicsCategory.ball
            platform.physicsBody?.collisionBitMask = PhysicsCategory.none
            platforms.append(platform)
            addChild(platform)
        }
        
        // Create obstacles
        for i in 0..<5 {
            let obstacle = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
            obstacle.position = CGPoint(x: frame.midX + CGFloat(i * 100), y: frame.midY - CGFloat(i * 100))
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
            obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
            obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.ball
            obstacle.physicsBody?.collisionBitMask = PhysicsCategory.none
            obstacles.append(obstacle)
            addChild(obstacle)
        }
    }
    
    func startGame() {
        gameStarted = true
        startButton.removeFromParent()
        ball.physicsBody?.isDynamic = true
    }
    
    func gameOver(winner: Bool) {
        gameOver = true
        let gameOverScene = GameOverScene(size: view!.bounds.size)
        gameOverScene.winner = winner
        view?.presentScene(gameOverScene)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameStarted {
            if contact.bodyA.categoryBitMask == PhysicsCategory.ball && contact.bodyB.categoryBitMask == PhysicsCategory.obstacle {
                gameOver(winner: false)
            } else if contact.bodyA.categoryBitMask == PhysicsCategory.ball && contact.bodyB.categoryBitMask == PhysicsCategory.platform {
                gameOver(winner: true)
            }
        }
    }
}
