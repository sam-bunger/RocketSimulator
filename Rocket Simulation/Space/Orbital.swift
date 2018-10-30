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
        self.radius = radius * 1000
        self.label = SKLabelNode(fontNamed: "KoHo-Bold")
        self.satellites = []
        let tex = SKTexture(imageNamed: objectName)
        
        let size = CGSize(width:2*self.radius, height:2*self.radius)
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
    
    private let centralBody:Body
    
    //Physics Variables
    private var accel:Vector = Vector()
    private var vel:Vector = Vector()
    private let a:CGFloat
    private let e:CGFloat
    private let n:CGFloat

    
    init(name:String, mass:CGFloat, radius:CGFloat, a:CGFloat, cB:Body, e:CGFloat){
        self.a = a * 1000
        self.centralBody = cB
        self.e = e
        self.n = sqrt((Const.G*cB.getMass())/pow(a, 3))
        
        super.init(name: name, mass: mass, radius: radius)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPath(p1: CGPoint)->CGPath{
        let r = CGMutablePath()
        r.move(to: CGPoint(x: 0, y: 0))
        r.addLine(to: CGPoint(x: p1.x/10,y: p1.y/10))
        return r
    }
    
    func update(delta:CGFloat, ct:CGFloat){
        updateAccel(delta: delta)
        updateVel(delta: delta)
        updatePos(delta: delta, ct: ct)
    }
    
    func setInitalVelocity(){
        let v = sqrt((Const.G*centralBody.getMass())/self.a)
        vel.add(x: v, y: 0)
    }
    
    func updateAccel(delta:CGFloat){
        accel = Vector.getUnit(point: self.position)
        let dist = sqrt(pow(self.position.x, 2) + pow(self.position.y, 2))
        let adg = (Const.G * centralBody.getMass())/pow(dist, 2)
        //print("\(self.objectName):  (\(Const.G) * \(centralBody.getMass()))/\(pow(dist, 2)) = \(adg)")
        accel.applyMagnitude(mag: adg)
    }
    
    func updateVel(delta:CGFloat){
        vel.add(x: accel.x*delta,y: accel.y*delta)
    }
    
    func getVel()->Vector{
        return vel
    }
    
    func updatePos(delta:CGFloat, ct:CGFloat){
        let t = ct
        //let current = self.position
        //self.position = CGPoint(x: current.x + (vel.x * delta), y: current.y + (vel.y * delta))
        //Calculate Mean Anomaly
        let M = n*t
        //Calculate Eccentric Anomaly
        var E = M
        while(true){
            let dE = (E - e * sin(E) - M)/(1 - e * cos(E))
            E -= dE
            if(abs(dE) < 1e-6 ){
                break
            }
        }
        //Calculate True Anomaly
        let v = 2*atan2(sqrt(1-e)*cos(E/2), sqrt(1+e)*sin(E/2))
        //Calculate Heliocentric Distance
        let r = a*(1-e*cos(E))
        
        self.position.x = r * cos(v)
        self.position.y = r * sin(v)
        
        if(self.objectName == "Earth"){
            print("t: \(t)")
            print("M: \(M)")
            print("E: \(E)")
            print("(r, deg): (\(e),\(v))")
            print("pos: (\(self.position.x),\(self.position.y))")

        }
        
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
        if(centralBody.objectName == "Sun"){
            return true
        }
        return false
    }
    
}
