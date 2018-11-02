//
//  System.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 10/17/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import Foundation
import SpriteKit

class System{
    
    private let sun:Body
    private let earth:Orbital
    private let moon:Orbital
    
    //All bodies
    private var bodies:[Body] = []
    
    init(){
        self.sun = Body(name: "Sun", mass: CGFloat(1.9891e30), radius: CGFloat(695000000), color: .orange)
        self.earth = Orbital(name: "Earth", color: .blue, mass: CGFloat(5.972e24), radius:CGFloat(6371000), a: CGFloat(149600000000), cB:sun, e: CGFloat(0.0167))
        self.moon = Orbital(name: "Moon", color: .gray, mass: CGFloat(7.34767e22), radius:CGFloat(1737000), a: CGFloat(238900000), cB:earth, e: CGFloat(0.0549))
        bodies.append(contentsOf: [sun, earth, moon])
        
        earth.addSatellite(orbital: moon)
        sun.addSatellite(orbital: earth)
        
        //Create Paths
        earth.drawPath(i:1000)
        moon.drawPath(i:1000)
    }
    
    func getPrimaryNode()->SKNode{
        return sun
    }
    
    func getBodies()->[Body]{
        return self.bodies
    }
    
    func getLabels()->[SKLabelNode]{
        var temp:[SKLabelNode] = []
        for body in bodies{
            temp.append(body.label)
        }
        return temp
    }
    
    func update(delta:CGFloat, ct:CGFloat){
        earth.update(delta: delta, ct: ct)
        moon.update(delta: delta, ct: ct)
        
    }
    
    func pos(of:String)->CGPoint{
        if of == "Earth"{
            return earth.absolutePos()
        }else if of == "Moon"{
            return moon.absolutePos()
        }
        return sun.position
    }
    
    func vel(of:String)->CGPoint{
        if of == "Earth"{
            return earth.getVel()
        }else if of == "Moon"{
            return moon.getVel()
        }
        return CGPoint(x: 0, y: 0)
    }
    
    func has(body:String)->Bool{
        for b in bodies{
            if b.name == body{
                return true
            }
        }
        return false;
    }
    
    func setScale(scale:CGFloat, x:CGFloat, y:CGFloat){
        sun.setScale(scale)
    }
    
    func scaleLabel(scale:CGFloat){
        for body in bodies{
            
            //Change Label size
            body.label.setScale(scale)
            
            //Change Path Size
            if let path = body.childNode(withName: "Path") as? SKShapeNode{
                path.lineWidth = scale*3
            }
            
            if let b = body as? Orbital{
                
                if (scale > 10000000 && !b.isPlanet()){
                    b.label.setScale(0)
                    if let path = b.getCB().childNode(withName: "Path") as? SKShapeNode{
                        path.lineWidth = 0
                    }
                }
                if (scale < 10000000 && b.isPlanet()){
                    if let path = b.getCB().childNode(withName: "Path") as? SKShapeNode{
                        path.lineWidth = 0
                    }
                }
                
            }
        }
    }
    
}
