//
//  HUD.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 10/19/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import Foundation
import SpriteKit

class HUD{
    
    //Content
    private var map:Map
    private let sol:System
    private let cam:SKCameraNode
    private let gameArea:CGRect
    
    //Time Skipping
    private let leftSkip = SKSpriteNode(imageNamed: "timeSkipLeft")
    private let rightSkip = SKSpriteNode(imageNamed: "timeSkipRight")
    private let timeSkipBG = SKSpriteNode(imageNamed: "timeSkip")
    private var skipValue:CGFloat = 1
    private let skipLabel = SKLabelNode(fontNamed: "KoHo-Light")
    
    //Formatting
    private let hudZ = CGFloat(10)
    
    
    init(system:System, cam:SKCameraNode, gameArea:CGRect){
        self.sol = system
        self.cam = cam
        self.map = Map(system: system, cam: cam)
        self.map.setCamPos(to: sol.pos(of: "earth"))
        self.gameArea = gameArea
        format()
    }
    
    func format(){
        
        self.cam.addChild(timeSkipBG)
        
        timeSkipBG.setScale(1.4)
        let tsp = CGPoint(x:gameArea.size.width/2 - timeSkipBG.size.width/2, y:gameArea.size.height/2 - timeSkipBG.size.height/2 + 3)
        timeSkipBG.position = tsp
        timeSkipBG.zPosition = hudZ
        
        timeSkipBG.addChild(rightSkip)
        timeSkipBG.addChild(leftSkip)
        timeSkipBG.addChild(skipLabel)
        
        rightSkip.position = CGPoint(x: 85, y: 3)
        rightSkip.zPosition = hudZ
        leftSkip.position = CGPoint(x: -75, y: 3)
        leftSkip.zPosition = hudZ
        skipLabel.zPosition = hudZ
        skipLabel.position = CGPoint(x: 0, y: -10)
        updateSkipValue()
        
        
    }
    
    func touchesEnded(touch: AnyObject){
        
        let skip = touch.location(in: timeSkipBG)
        
        //Left Time Skip
        if rightSkip.contains(skip){
            print("Skip Right")
            skipRight()
        }
        
        //Right Time Skip
        if leftSkip.contains(skip){
            print("Skip Left")
            skipLeft()
        }
        
    }
    
    func touchesMoved(x: CGFloat, y: CGFloat) {
        
        if(map.isActive()){
            map.touchesMoved(x: x, y: y)
        }

    }
    
    func scaleMap(scale:CGFloat){
        if(map.isActive()){
            map.zoom(scale: scale)
        }
    }
    
    func skipRight(){
        if skipValue < 10000{
            skipValue *= 10
        }
        updateSkipValue()
    }
    
    func skipLeft(){
        if skipValue > 1{
            skipValue /= 10
        }
        updateSkipValue()
    }
    
    func updateSkipValue(){
        skipLabel.text = "x\(skipValue)"
    }
    
    func getMultiplyer()->CGFloat{
        return skipValue
    }
    
    
}
