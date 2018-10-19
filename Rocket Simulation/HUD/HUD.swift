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
    
    //Time Skipping
    private let leftSkip:SKSpriteNode
    private let rightSkip:SKSpriteNode
    
    
    init(system:System, cam:SKCameraNode){
        self.sol = system
        self.cam = cam
        self.map = Map(system: system, cam: cam)
        self.map.setCamPos(to: sol.pos(of: "earth"))
        
        leftSkip = SKSPriteNode(imageNamed: "leftSkip")
        rightSkip = SKSPriteNode(imageNamed: "rightSkip")
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
    
    
}
