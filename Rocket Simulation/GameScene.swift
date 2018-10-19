//
//  GameScene.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 9/4/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private struct Keys{
        static let Area = "gameArea"
        static let GVC = "gvc"
    }
    
    var gameArea: CGRect
    let gvc:GameViewController
    let buildLabel = SKLabelNode(fontNamed: "KoHo-Bold")
    let savesLabel = SKLabelNode(fontNamed: "KoHo-Bold")
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        buildLabel.fontSize = 100
        buildLabel.fontColor = SKColor.white
        buildLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        buildLabel.text = "Build"
        buildLabel.position = CGPoint(x: self.size.width/2, y:self.size.height*0.4)
        buildLabel.zPosition = 1
        self.addChild(buildLabel)
        
        savesLabel.fontSize = 100
        savesLabel.fontColor = SKColor.white
        savesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        savesLabel.text = "Saves"
        savesLabel.position = CGPoint(x: self.size.width/2, y:self.size.height*0.33)
        savesLabel.zPosition = 1
        self.addChild(savesLabel)
        
        
    }
    
    init(size:CGSize, gvc: GameViewController){
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y:0, width: playableWidth, height: size.height)
        self.gvc = gvc
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.gameArea = aDecoder.decodeObject(forKey: Keys.Area) as! CGRect
        self.gvc = aDecoder.decodeObject(forKey: Keys.GVC) as! GameViewController
        super.init(size: gameArea.size)
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.gameArea, forKey: Keys.Area)
        aCoder.encode(self.gvc, forKey: Keys.GVC)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if(buildLabel.contains(pointOfTouch)){
                toBuildMenu()
            }
            
            if(savesLabel.contains(pointOfTouch)){
                toSavesMenu()
            }
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func toBuildMenu(){
        let changeSceneAction = SKAction.run {self.changeScene(scene: BuildScene(size: self.size, gvc: self.gvc), move: .right)}
        self.run(changeSceneAction)
    }
    
    func toSavesMenu(){
        let changeSceneAction = SKAction.run {self.changeScene(scene: SavesScene(size: self.size, gvc: self.gvc), move: .right)}
        self.run(changeSceneAction)
    }
    
    func changeScene(scene: SKScene, move: SKTransitionDirection){
        
        scene.scaleMode = self.scaleMode
        let myTransition = SKTransition.push(with: move, duration: 0.5)
        self.view!.presentScene(scene, transition: myTransition)
        
    }
    
}

