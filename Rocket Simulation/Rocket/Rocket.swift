//
//  Rocket.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 9/4/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import Foundation
import SpriteKit

class Rocket: SKNode{
    
    private struct Keys{
        static let Root = "root"
        static let Name = "name"
        static let Stage = "currentStage"
    }
    
    private var givenName:String
    
    //Current Rocket Stage
    private var currentStage:Stage
    
    //Rocket Itself
    private let root:Part
    
    //Rocket Map Icon
    private let mapIco:SKSpriteNode = SKSpriteNode(imageNamed: "RocketIcon.png")
    
    //Rocket Trajectory
    private var traj:SKShapeNode = SKShapeNode(rect: CGRect(x: 0, y:0, width:0, height:0))
    
    //Physics
    private var vel:Vector = Vector(x: 0, y: 0)
    private var accel:Vector = Vector(x: 0, y: 0)
    
    //Throttle
    private var throttle = CGFloat(0)
    
    //Heading
    private var heading = CGFloat(0)
    
    //Orbit data
    private var E = CGFloat(0)
    private var e = CGFloat(0)
    private var a = CGFloat(0)
    private var T = CGFloat(0)
    
    override init(){
        self.currentStage = Stage()
        self.root = Cockpit(type: 0)
        self.givenName = "Untitled Rocket"
        super.init()
        self.addChild(root)
        self.addChild(mapIco)
    }
    
    init(root:Part, stage:Stage){
        self.root = root
        self.givenName = ""
        self.currentStage = stage
        super.init()
        initVars()
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.root, forKey: Keys.Root)
        aCoder.encode(self.givenName, forKey: Keys.Name)
        aCoder.encode(self.currentStage, forKey: Keys.Stage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.root = aDecoder.decodeObject(forKey: Keys.Root) as! Part
        self.givenName = aDecoder.decodeObject(forKey: Keys.Name) as! String
        self.currentStage = aDecoder.decodeObject(forKey: Keys.Stage) as! Stage
        super.init()
        initVars()
    }
    
    func initVars(){
        root.removeFromParent()
        self.zPosition = 100
        root.zPosition = 100
        root.position = CGPoint(x: 0, y: 0)
        mapIco.zPosition = 100
        mapIco.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.addChild(root)
        self.addChild(mapIco)
        if parent is Body{
            self.parent?.addChild(traj)
        }
        
    }
    
    func getSize()->CGRect{
        return getSize(last:root)
    }
    
    func getMass()->CGFloat{
        return getMass(last:root)
    }
    
    func getMass(last:Part)->CGFloat{
        let mass = last.getMass()
        for case let part? in last.getConnections(){
            if(part.getDegree() > last.getDegree()){
                return mass + getMass(last: part)
            }
        }
        return mass
    }
    
    func getSize(last:Part)->CGRect{
        return last.calculateAccumulatedFrame()
    }
    
    func getMapIco()->SKSpriteNode{
        return mapIco
    }
    
    func add(scene:SKNode){
        self.root.zPosition = 100
        scene.addChild(self.root)
    }
    
    func getRoot()->Part{
        return root
    }
    
    func setName(name:String){
        self.givenName = name
    }
    
    func getName()->String{
        return self.givenName
    }
    
    func connectParts(){
        root.connectAdjParts()
    }
    
    func scale(by:CGFloat){
        root.setScale(by)
    }
    
    func position(x:CGFloat, y:CGFloat){
        root.position = CGPoint(x: x, y: y)
        mapIco.position = CGPoint(x: x, y: y)
    }
    
    func newAnchorPoint(point:CGPoint){
        root.newAnchor(point: point)
    }
    
    func setCenter(){
        self.newAnchorPoint(point: self.getCenter())
    }
    
    func getCenter()->CGPoint{
        root.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        return root.getCenter()
    }
    
    /* ==================================== *
     * ======= FLIGHT FUNCTIONALITY ======= *
     * ==================================== */
    
    func update(delta: CGFloat, ct:CGFloat){
        getAccel()
        calcVel(delta: delta)
        
        //Calculate orbit variables from velocity
        calcOrbit()
        //Calculate orbit path
        calcTraj(1000)
        
        if(delta < 10){
            self.position.x += vel.x * delta
            self.position.y += vel.y * delta
        }else{
            self.position = getPos(at: ct)
        }
    }
    
    func getAccel(){
        var totalThrust = CGFloat(0)
        for part in currentStage.getTasks(){
            if let p = part as? Engine{
                totalThrust += p.getThrust(throttle: throttle)
            }
        }
        let mag = totalThrust/getMass()
        accel = Vector(x: mag*cos(zRotation), y:mag*sin(zRotation))
    }
    
    func calcTraj(_ i:Int){
        let r = CGMutablePath()
        let inc = T/CGFloat(i)
        var t = inc
        
        r.move(to: getPos(at: 0))
        for _ in 1...i{
            r.addLine(to: getPos(at: t))
            t += inc
        }
        let path = SKShapeNode(path: r)
        path.strokeColor = .cyan
        path.zPosition = -1
        path.name = "Path"
        path.alpha = 0.3
        traj = path
    }
    
    func calcVel(delta: CGFloat){
        vel.x += accel.x * delta
        vel.y += accel.y * delta
    }
    
    func calcOrbit(){
        if let p = parent as? Body{
            //Calculate eccentricity
            let u = p.getU()
            let r = Vector(magnitude: position)
            let m = r.mult(pow(vel.mag(),2) - u/r.mag())
            let b = vel.mult(vel.dot(r))
            e = m.sub(b).mult((1/u)).mag()
            
            //calc E
            E = (pow(vel.mag(),2)/2) - (u/r.mag())
            
            if(e != 1){
                a = -1*u/(2*E)
            }else{
                a = CGFloat.infinity
            }
        }
    }
    
    func getPos(at:CGFloat) -> CGPoint{
        var u = CGFloat(0.00001)
        if let p = parent as? Body{
            u = p.getU()
        }
        //orbital period
        T = pow(a,3)/u
        //Get current time mod orbital period
        let t = at.truncatingRemainder(dividingBy: T)
        //Calculate Mean Anomaly
        let M = (CGFloat(2*Double.pi)/T)*t
        //Calculate Eccentric Anomaly
        var E = M
        while(true){
            let dE = (E - e * sin(E) - M)/(1 - e * cos(E))
            E -= dE
            if(abs(dE) < 1e-5 ){
                break
            }
        }
        //Calculate True Anomaly
        let v = 2*atan2(sqrt(1-e)*cos(E/2), sqrt(1+e)*sin(E/2))
        
        //Calculate Heliocentric Distance
        let r = (a*(1-e*cos(E)))
        
        //Convert from polar to cartesian and return a CGPoint
        return CGPoint(x: r * cos(v),y: r * sin(v))
    }
    
    func stage(){
        if let stage = currentStage.deploy(){
            currentStage = stage
        }
    }


}
