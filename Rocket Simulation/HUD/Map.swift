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
    
    //Camera Lock
    private var camLock:String =  "Earth"
    

    init(system:System, cam:SKCameraNode){
        self.system = system
        self.active = true
        self.cam = cam
        
        cam.setScale(scaleNum)
        system.scaleLabel(scale: scaleNum)
        
    }
    
    func touchesBegan(touch: CGPoint){
    
    }
    
    func touchesEnded(touch: AnyObject){
        
        let body = system.getPrimaryNode() as! SKShapeNode
        let point = touch.location(in: body.parent!)
        let node = body.parent!.atPoint(point)
        
        if let name = node.name, system.has(body: name){
            camLock = name
        }
        
    }
    
    func touchesMoved(x: CGFloat, y:CGFloat){

        //print("Previois Position:" + cam.position.debugDescription)
        //print("Position Change: (\(x), \(y))")
        cam.position.x = cam.position.x - x
        cam.position.y = cam.position.y - y
        //print("New Position: " + cam.position.debugDescription)

    }
    
    func update(ct:CGFloat){
        let v = system.vel(of: camLock)
        cam.position.x += v.x
        cam.position.y += v.y
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
        if scaleNum < 1 { scaleNum = 1}
        if scaleNum > 100000000000 { scaleNum = 100000000000 }
        
        //Update Camera Scale
        cam.setScale(scaleNum)
        
        //Scale Labels
        system.scaleLabel(scale: scaleNum)
        
        //print("Recognizer scale: \(scale)")
        //print("Camera scale - round:\(round(scaleNum))   scale:\(scaleNum)")
        
    }
    
    
    
    
}
