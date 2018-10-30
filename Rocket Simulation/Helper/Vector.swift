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
    
    public var x:CGFloat
    public var y:CGFloat
    
    init(magnitude: CGPoint){
        self.x = magnitude.x
        self.y = magnitude.y
    }
    
    init(){
        self.x = 0
        self.y = 0
    }
    
    func add(x:CGFloat, y:CGFloat){
        self.x += x
        self.y += y
    }
    
    func applyMagnitude(mag:CGFloat){
        self.x *= mag
        self.y *= mag
    }
    
    func toPoint()->CGPoint{
        return CGPoint(x: x, y: y)
    }
    
    //STATIC FUNCS
    static func getUnit(point:CGPoint)->Vector{
        let magnitude = -1 * sqrt(pow(point.x, 2) +  pow(point.y, 2))
        return Vector(magnitude: CGPoint(x: point.x/magnitude,y: point.y/magnitude))
    }
    
    
    
}
