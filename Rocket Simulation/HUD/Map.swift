//
//  Map.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 10/18/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import Foundation
import SpriteKit

class Map{
    
    //Intial Vars
    private let system:System
    private var active:Bool
    private let cam:SKCameraNode
    
    //Zoom
    private var scaleNum:CGFloat = 50
    private var previousScale:CGFloat = 1


    init(system:System, cam:SKCameraNode){
        self.system = system
        self.active = true
        self.cam = cam
        
        cam.setScale(scaleNum)
        system.scaleLabel(scale: scaleNum)
    }
    
    func setCamPos(to: CGPoint){
        cam.position = to
    }
    
    func activate(){
        self.active = true
    }
    
    func deactivate(){
        self.active = false
    }
    
    func isActive()->Bool{
        return self.active
    }
    
    func touchesMoved(x: CGFloat, y:CGFloat){
        cam.position.x -= x
        cam.position.y -= y
    }
    
    func zoom(scale:CGFloat){
        
        let new = (1/scale)
        
        scaleNum *= new
        //Limit Scale
        if scaleNum < 1 { scaleNum = 1}
        if scaleNum > 500000 { scaleNum = 500000 }
        
        //Update Camera Scale
        cam.setScale(scaleNum)
        
        //Scale Labels
        system.scaleLabel(scale: scaleNum)
        /*
        print("Recognizer scale: \(scale)")
        print("Camera scale: \(scaleNum)")
        */
    }
    
    
    
    
}
