//
//  SavesScene.swift
//  Rocket Man
//
//  Created by Sam Bunger on 2/11/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import SpriteKit
import GameplayKit

class SavesScene: SKScene{
    
    let defaults = UserDefaults.standard
    let gvc:GameViewController
    var numOfSaves:Int
    var gameArea: CGRect
    let background = SKSpriteNode(imageNamed: "backgroundBuild")
    
    //All Rocket Data to be used
    var items:[SKShapeNode]
    var rockets:[Rocket]
    
    //List Item Height
    let listItemHeight = CGFloat(500)

    
    override func didMove(to view: SKView) {
        
        //BACKGROUND
        background.size = CGSize(width: self.size.width, height: self.size.height*1.1)
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        for i in 0...(numOfSaves){
            if let rocket = NSKeyedUnarchiver.unarchiveObject(withFile: "\(gvc.filePath)\(i)"){
                rockets.append(rocket as! Rocket)
            }
        }
        
        drawMenu()
        
    }
    
    init(size:CGSize, gvc: GameViewController){
        let screenSize = UIScreen.main.bounds
        let maxAspectRatio: CGFloat = screenSize.height/screenSize.width
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y:0, width: playableWidth, height: size.height)
        numOfSaves = defaults.integer(forKey: "numOfSaves")
        self.gvc = gvc
        self.items = []
        self.rockets = []
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for touch: AnyObject in touches{
        
        //let pointOfTouch = touch.location(in: self)
        //let previousPointOfTouch = touch.previousLocation(in: self)
        
        
        //}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            var i = 0
            
            for item in items{
                if item.contains(pointOfTouch){
                    rockets[i].clearParent()
                    goToFlight(rocket: rockets[i])
                }
                i += 1
            }
            
            
        }
        
    }
    
    func drawMenu(){
        
        var i = 0
        
        for rocket in rockets{
            //Create Box
            let box = buildBox(i: i)
            self.addChild(box)
            
            //Add Rocket Image
            rocket.connectParts()
            let rect = rocket.getSize()
            rocket.setCenter()
            rocket.position(x: gameArea.origin.x + (listItemHeight/2), y: gameArea.size.height - (listItemHeight*CGFloat(i)) - (listItemHeight/2))
            rocket.scale(by: calculateScale(rect: rect))
            rocket.add(scene:box)
            
            let name = SKLabelNode(text: rocket.getName())
            name.fontSize = 100
            let x = listItemHeight + ((gameArea.size.width - listItemHeight)/2)
            let y = gameArea.size.height - (listItemHeight/2) - (listItemHeight*CGFloat(i))
            name.position = CGPoint(x: x, y: y)
            box.addChild(name)
            
            self.items.append(box)
            
            i += 1
                
        }
        
    }
    
    func buildBox(i:Int)->SKShapeNode{
        let padding = CGFloat(20)
        let x = gameArea.origin.x + padding/2
        let y = gameArea.size.height - (padding/2) - listItemHeight*CGFloat(i+1)
        
        let r = CGRect(x: x, y: y, width: gameArea.size.width - padding, height: listItemHeight - padding)
        let box = SKShapeNode(rect: r)
        box.zPosition = 1
        box.strokeColor = .red
        box.lineWidth = 3
        return box
    }
    
    func calculateScale(rect:CGRect)->CGFloat{
        if(rect.size.width > rect.size.height){
            return (listItemHeight - 100)/rect.size.width
        }else{
            return (listItemHeight - 100)/rect.size.height
        }
    }
    
    func goToFlight(rocket:Rocket){
        let csa = SKAction.run {self.changeScene(scene: FlightScene(size: self.size, gvc: self.gvc, rocket: rocket), move: .up)}
        self.run(csa)
    }
    
    func changeScene(scene: SKScene, move: SKTransitionDirection){
        
        scene.scaleMode = self.scaleMode
        let myTransition = SKTransition.push(with: move, duration: 0.5)
        self.view!.presentScene(scene, transition: myTransition)
        
    }
    
    
}
















