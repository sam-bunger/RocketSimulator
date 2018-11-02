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
    private var skipIndex:CGFloat = 0
    private let skipLabel = SKLabelNode(fontNamed: "KoHo-Light")
    
    //Formatting
    private let hudZ = CGFloat(10)
    
    
    init(system:System, cam:SKCameraNode, gameArea:CGRect){
        self.sol = system
        self.cam = cam
        self.map = Map(system: system, cam: cam)
        self.map.setCamPos(to: sol.pos(of: "Earth"))
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
    
    func touchesBegan(touch: AnyObject, mainPoint: CGPoint){
        map.touchesBegan(touch: mainPoint)
    }
    
    func touchesEnded(touch: AnyObject, mainPoint: CGPoint){
        
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
        
        map.touchesEnded(touch: touch)
        
    }
    
    func touchesMoved(x: CGFloat, y: CGFloat) {
        
        if(map.isActive()){
            map.touchesMoved(x: x, y: y)
        }

    }
    
    func update(ct:CGFloat){
        map.update(ct: ct)
    }
    
    func scaleMap(scale:CGFloat){
        if(map.isActive()){
            map.zoom(scale: scale)
        }
    }
    
    func skipRight(){
        if skipValue < 10000000{
            skipIndex += 1
            skipValue = pow(8, skipIndex)
            
        }
        updateSkipValue()
    }
    
    func skipLeft(){
        if skipValue > 1{
            skipIndex -= 1
            skipValue = pow(8, skipIndex)
            
        }
        updateSkipValue()
    }
    
    func updateSkipValue(){
        skipLabel.text = "x\(skipIndex)"
    }
    
    func getMultiplyer()->CGFloat{
        return skipValue
    }
    
    
}
