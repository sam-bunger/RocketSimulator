//
//  Orbital.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 10/17/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import Foundation
import SpriteKit

class Body:SKSpriteNode{
    
    struct Const{
        static let G = CGFloat(pow(10,-11) * 6.67)
    }
    
    //Main Variables
    internal let objectName:String
    internal let mass:CGFloat
    internal let radius:CGFloat
    internal var satellites:[Orbital]
    internal let label:SKLabelNode
    
    init(name:String, mass:CGFloat, radius:CGFloat){
        self.objectName = name
        //Mass is in terms of mass x 10^18
        self.mass = mass
        self.radius = radius
        self.label = SKLabelNode(fontNamed: "KoHo-Bold")
        self.satellites = []
        let tex = SKTexture(imageNamed: objectName)
        
        let size = CGSize(width:2*radius, height:2*radius)
        super.init(texture: tex, color: .clear, size: size)
        
        //Add Label
        label.text = objectName
        label.fontSize = 40
        label.zPosition = 2
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSatellite(orbital:Orbital){
        self.addChild(orbital)
        self.satellites.append(orbital)
    }
    
    func getMass()->CGFloat{
        return mass * pow(10.0, 18.0)
    }
    
    func scaleLabel(scale:CGFloat){
        self.label.fontSize *= scale
    }
    
}

class Orbital:Body{
    
    private let orbitRadius:CGFloat
    private let centralBody:Body
    
    //Physics Variables
    private var accel:Vector = Vector()
    private var vel:Vector = Vector()

    
    init(name:String, mass:CGFloat, radius:CGFloat, oR:CGFloat, cB:Body){
        self.orbitRadius = oR
        self.centralBody = cB
        super.init(name: name, mass: mass, radius: radius)
        setInitalVelocity()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(delta: CGFloat){
        updateAccel(delta: delta)
        updateVel(delta: delta)
        updatePos(delta: delta)
        print("\(self.objectName) pos: (\(self.position.x), \(self.position.y))" )
    }
    
    func setInitalVelocity(){
        vel.add(x: 100, y: 0)
    }
    
    func updateAccel(delta:CGFloat){
        accel = Vector.getUnit(point: self.position)
        let adg = (Const.G * (centralBody.getMass()))/pow(orbitRadius, 2)
        accel.applyMagnitude(mag: adg)
    }
    
    func updateVel(delta:CGFloat){
        vel.add(x: accel.x()*delta,y: accel.y()*delta)
    }
    
    func updatePos(delta:CGFloat){
        let current = self.position
        self.position = CGPoint(x: current.x - (vel.x() * delta), y: current.y - (vel.y() * delta))
    }
    
    func initalPosition(){
        self.position = CGPoint(x: 0, y: orbitRadius)
    }
    
    func absolutePos()->CGPoint{
        
        if(centralBody.objectName == "Sun"){
            return self.position
        }
        let pos1 = centralBody.position
        let pos2 = self.position
        return CGPoint(x: (pos1.x+pos2.x), y:(pos1.y+pos2.y))
        
    }
    
    func isPlanet()->Bool{
        print("My Name: \(self.objectName) ----> \(centralBody.objectName)")
        if(centralBody.objectName == "Sun"){
            return true
        }
        return false
    }
    
}
