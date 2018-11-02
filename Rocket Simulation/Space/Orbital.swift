//
//  Orbital.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 10/17/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import Foundation
import SpriteKit

class Body:SKShapeNode{
    
    struct Const{
        static let G = CGFloat(pow(10,-11) * 6.67)
    }
    
    //Main Variables
    internal let objectName:String
    internal let mass:CGFloat
    internal let radius:CGFloat
    internal var satellites:[Orbital]
    internal let label:SKLabelNode
    
    init(name:String, mass:CGFloat, radius:CGFloat, color:SKColor){
        self.objectName = name
        //Mass is in terms of mass x 10^18
        self.mass = mass
        self.radius = radius
        self.label = SKLabelNode(fontNamed: "KoHo-Bold")
        self.satellites = []
        //let tex = SKTexture(imageNamed: objectName)
        
        //let size = CGSize(width:2*self.radius, height:2*self.radius)
        super.init()
        let diameter = radius * 2
        self.path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -1*radius, y: -1*radius), size: CGSize(width: diameter, height: diameter)), transform: nil)
        self.fillColor = color
        self.strokeColor = .clear
        self.name = name
        
        //Add Label
        label.text = objectName
        label.name = objectName
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
        return mass
    }
    
    func scaleLabel(scale:CGFloat){
        self.label.fontSize *= scale
    }
    
}

class Orbital:Body{
    
    private let centralBody:Body
    private var prevPos:CGPoint
    
    //Physics Variables
    private var accel:Vector = Vector()
    private var vel = CGPoint(x: 0, y: 0)
    private let a:CGFloat
    private let e:CGFloat
    private let n:CGFloat
    private let T:CGFloat

    
    init(name:String, color:SKColor, mass:CGFloat, radius:CGFloat, a:CGFloat, cB:Body, e:CGFloat){
        //minimize the size of all of the constants
        self.a = a
        self.centralBody = cB
        self.e = e
        self.T = CGFloat(2*Double.pi)*sqrt(pow(self.a, 3)/(Const.G*cB.getMass()))
        self.n = CGFloat(2*Double.pi)/T
        self.prevPos = CGPoint(x: -1*self.a, y:0)
        
        super.init(name: name, mass: mass, radius: radius, color: color)
        self.isAntialiased = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(delta:CGFloat, ct:CGFloat){
        updatePos(delta: delta, ct: ct)
    }
    
    func calcVel()->CGPoint{
        if(centralBody.name == "Sun"){
            return CGPoint(x: self.position.x - prevPos.x, y: self.position.y - prevPos.y )
        }
        let prev = (centralBody as! Orbital).calcVel()
        return CGPoint(x: prev.x + (self.position.x - prevPos.x), y: prev.y + (self.position.y - prevPos.y))
    }
    
    func getPos(at:CGFloat) -> CGPoint{
        
        //Calculate Mean Anomaly
        let M = n*at
        //Calculate Eccentric Anomaly
        var E = M
        while(true){
            let dE = (E - e * sin(E) - M)/(1 - e * cos(E))
            E -= dE
            if(abs(dE) < 1e-11 ){
                break
            }
        }
        //Calculate True Anomaly
        let v = 2*atan2(sqrt(1-e)*cos(E/2), sqrt(1+e)*sin(E/2))
        //let v2:Double = 2*atan2(sqrt(1-e)*cos(E/2), sqrt(1+e)*sin(E/2))
        //print("v: \(v2)")
        //Calculate Heliocentric Distance
        let r = (a*(1-e*cos(E)))

        return CGPoint(x: r * cos(v),y: r * sin(v))
        
    }
    
    func updatePos(delta:CGFloat, ct:CGFloat){
        
        let t = CGFloat(Int(ct*10000) % Int(T*10000))/10000
        let newPos = getPos(at: t)
        
        self.prevPos = self.position
        position = newPos
        self.vel = calcVel()
        
        if(self.name == "Earth"){
            print("P1: \(newPos.dictionaryRepresentation)")
            print("P2: \(self.position.dictionaryRepresentation)")
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
    
    func getVel()->CGPoint{
        return vel
    }
    
    func getCB()->Body{
        return centralBody
    }
    
    func drawPath(i:Int){
        
        let r = CGMutablePath()
        let inc = T/CGFloat(i)
        var t = inc
        r.move(to: getPos(at: 0))
        for _ in 1...i{
            r.addLine(to: getPos(at: t))
            t += inc
        }
        
        let path = SKShapeNode(path: r)
        path.strokeColor = .blue
        path.zPosition = -1
        path.name = "Path"
        centralBody.addChild(path)
    }
    
}
