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
    private var scaleNum:CGFloat = 30000
    private var previousScale:CGFloat = 1
    
    //Camera Lock
    private var camLock:String

    init(system:System, cam:SKCameraNode){
        self.system = system
        self.active = true
        self.cam = cam
        self.camLock = "Earth"
        
        cam.setScale(scaleNum)
        system.scaleLabel(scale: scaleNum)
    }
    
    func touchesEnded(touch: CGPoint){
        
        for body in system.getBodies(){
            //print("Body Pos: (\(body.position.x),\(body.position.y)))")
            //print("body size: (\(body.size.width),\(body.size.height))")
            //print("touch Pos: (\(touch.x),\(touch.y)))")
            if(body.contains(touch)){
                if let text = body.label.text{
                    camLock = text
                }
            }
        }
        
    }
    
    func touchesMoved(x: CGFloat, y:CGFloat){
        cam.position.x -= x
        cam.position.y -= y
    }
    
    func update(delta:CGFloat, ct:CGFloat){
        //print("CamLock: \(camLock)")
        let v = system.pos(of:camLock)
        //print("Vel: (\(v.x*delta),\(v.y*delta))")
        cam.position.x = v.x
        cam.position.y = v.y
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
    
    func zoom(scale:CGFloat){
        
        let new = (1/scale)
        
        scaleNum *= new
        //Limit Scale
        if scaleNum < 10 { scaleNum = 10}
        if scaleNum > 1000000000 { scaleNum = 1000000000 }
        
        //Update Camera Scale
        cam.setScale(scaleNum)
        
        //Scale Labels
        system.scaleLabel(scale: scaleNum)
        
        //print("Recognizer scale: \(scale)")
        //print("Camera scale: \(scaleNum)")
        
    }
    
    
    
    
}
