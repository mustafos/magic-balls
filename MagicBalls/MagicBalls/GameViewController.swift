//
//  GameViewController.swift
//  MagicBalls
//
//  Created by Mustafa Bekirov on 18.02.2024.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var gameScene: GameScene!
    var gameOverScene: GameOverScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the game scene
            gameScene = GameScene(size: view.bounds.size)
            gameScene.scaleMode = .aspectFill
            
            // Load the game over scene
            gameOverScene = GameOverScene(size: view.bounds.size)
            gameOverScene.scaleMode = .aspectFill
            
            // Present the game scene
            view.presentScene(gameScene)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        gameScene.startGame()
    }
    
    func showGameOver(winner: Bool) {
        gameScene.removeFromParent()
        gameOverScene.winner = winner
        view.presentScene(gameOverScene)
    }
}
