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
        self.sun = Body(name: "Sun", mass: CGFloat(1989000000000), radius: CGFloat(695000))
        self.earth = Orbital(name: "Earth", mass: CGFloat(5972000), radius:CGFloat(6371), a: CGFloat(149600000), cB:sun, e: CGFloat(0.0167))
        self.moon = Orbital(name: "Moon", mass: CGFloat(734767), radius:CGFloat(1737), a: CGFloat(238900), cB:earth, e: CGFloat(0.0549))
        bodies.append(contentsOf: [sun, earth, moon])
        
        earth.addSatellite(orbital: moon)
        sun.addSatellite(orbital: earth)
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
            return earth.position
        }else if of == "Moon"{
            return moon.position
        }
        return sun.position
    }
    
    func vel(of:String)->Vector{
        if of == "Earth"{
            return earth.getVel()
        }else if of == "Moon"{
            return moon.getVel()
        }
        return Vector(magnitude: CGPoint(x: 0, y: 0))
    }
    
    func scaleLabel(scale:CGFloat){
        for body in bodies{
            body.label.setScale(scale)
            if let b = body as? Orbital{
                if (scale > 10000000 && !b.isPlanet()){
                    b.label.setScale(0)
                }
            }
        }
    }
    
}
