//
//  Vector.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 10/18/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import Foundation
import SpriteKit

class Vector{
    
    var magnitude:CGPoint
    
    init(magnitude: CGPoint){
        self.magnitude = magnitude
    }
    
    init(){
        magnitude = CGPoint(x: 0, y: 0)
    }
    
    func x()->CGFloat{
        return magnitude.x
    }
    
    func y()->CGFloat{
        return magnitude.y
    }
    
    func add(x:CGFloat, y:CGFloat){
        magnitude.x += x
        magnitude.y += y
    }
    
    func applyMagnitude(mag:CGFloat){
        self.magnitude.x *= mag
        self.magnitude.x *= mag
    }
    
    
    
    //STATIC FUNCS
    
    static func getUnit(origin:CGPoint, dest:CGPoint)->Vector{
        
        let dist = CGPoint(x:(origin.x - dest.x), y:(origin.y - dest.y))
        let magnitude = sqrt(pow(dist.x, 2) +  pow(dist.y, 2))
        return Vector(magnitude: CGPoint(x: dist.x/magnitude,y: dist.y/magnitude))
        
    }
    
    
    
}
