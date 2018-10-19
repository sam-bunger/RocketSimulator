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
        self.earth = Orbital(name: "Earth", mass: CGFloat(59720000), radius:CGFloat(6371), oR: CGFloat(149600000), cB:sun)
        self.moon = Orbital(name: "Moon", mass: CGFloat(734767), radius:CGFloat(1737), oR: CGFloat(238900), cB:earth)
        bodies.append(contentsOf: [sun, earth, moon])
        
        earth.addSatellite(orbital: moon)
        sun.addSatellite(orbital: earth)
        setInitialPositions()
    }
    
    func getPrimaryNode()->SKNode{
        return sun
    }
    
    
    func update(delta: CGFloat){
        
        earth.update(delta: delta)
        moon.update(delta: delta)
        
    }
    
    func setInitialPositions(){
        earth.initalPosition()
        moon.initalPosition()
    }
    
    func pos(of:String)->CGPoint{
        if of == "earth"{
            return earth.position
        }else if of == "moon"{
            return moon.position
        }
        return sun.position
    }
    
    func scaleLabel(scale:CGFloat){
        for body in bodies{
            body.label.setScale(scale)
            if let b = body as? Orbital{
                if (scale > 5000 && !b.isPlanet()){
                    b.label.setScale(0)
                }
            }
        }
    }
    
}
