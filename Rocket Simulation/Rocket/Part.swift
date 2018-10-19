//
//  Part.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 9/4/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import Foundation
import SpriteKit

class Part:SKSpriteNode{
    
    private struct Keys{
        static let ShipType = "type"
        static let Texture = "texture"
        static let Degree = "degree"
        static let Offset = "offset"
        static let Parts = "connections"
        static let ID = "id"
    }
    
    private var id:String
    private var type:Int
    private var degree:Int
    private var offset:CGFloat
    private let tex:SKTexture
    private var connections:[Part?] = [nil, nil, nil, nil]
    private var label:SKLabelNode
    
    init(imageName:String, type:Int){
        self.type = type
        self.degree = 0
        self.label = SKLabelNode(text: "\(degree)")
        label.color = UIColor.red
        label.zPosition = 100
        self.offset = 0
        self.tex = SKTexture(imageNamed: imageName)
        self.id = UUID().uuidString
        super.init(texture: tex, color: .clear, size: tex.size())
        //self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let c = aDecoder.decodeObject(forKey: Keys.Parts) as? [Part?]{
            self.connections = c
        }
        
        self.tex = aDecoder.decodeObject(forKey: Keys.Texture) as! SKTexture
        self.type = aDecoder.decodeInteger(forKey: Keys.ShipType)
        self.degree = aDecoder.decodeInteger(forKey: Keys.Degree)
        self.offset = aDecoder.decodeObject(forKey: Keys.Offset) as! CGFloat
        self.id = aDecoder.decodeObject(forKey: Keys.ID) as! String
        self.label = SKLabelNode(text: "\(self.degree)")
        label.zPosition = 100
        label.color = UIColor.red
        super.init(texture: tex, color: .clear, size: tex.size())
        //self.addChild(label)
        
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.type, forKey: Keys.ShipType)
        aCoder.encode(self.texture, forKey: Keys.Texture)
        aCoder.encode(self.degree, forKey: Keys.Degree)
        aCoder.encode(self.offset, forKey: Keys.Offset)
        aCoder.encode(self.connections, forKey: Keys.Parts)
        aCoder.encode(self.id, forKey: Keys.ID)
    }
    
    func update(){
        self.label.text = "\(self.degree)"
    }
    
    //GETTERS AND SETTERS
    func getConnection(at:Int)->Part?{
        return self.connections[at]
    }
    
    func getConnections()->[Part?]{
        return connections;
    }
    
    func setConnection(con:Part, at:Int){
        self.connections[at] = con
    }
    
    func getOffset()->CGFloat{
        return self.offset
    }
    
    func setOffset(offset:CGFloat){
        self.offset = offset
    }
    
    func getDegree()->Int{
        return self.degree
    }
    
    func setDegree(deg:Int){
        self.degree = deg;
    }
    
    func getType()->Int{
        return self.type
    }
    
    func center(scene: SKScene){
        self.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
    }
    
    
    /* =====================================
     * ====== BUILDING FUNCTIONALITY =======
     * =====================================
     */
    func makeConnection(part:Part, at:Int, offset:CGFloat){
        self.offset = offset;
        self.updateDegree(degree: part.degree+1)
        part.connections[at] = self
        self.connections[opSide(i: at)] = part
    }
    
    func updateDegree(degree:Int){
        for case let part? in connections{
            if(self.degree < part.degree){
                part.updateDegree(degree: degree+1)
            }
        }
        self.degree = degree
    }
    
    //Find the opposite side of a function
    func opSide(i:Int)->Int{
        if(i < 2 && i >= 0){
            return i + 2
        }else{
            return i - 2
        }
    }
    
    func isConnected(part:Part)->Bool{
        
        for case let part? in connections{
            if(part.degree > self.degree){
                if part.equals(part: self){
                    return true
                }else{
                    return self.isConnected(part: part)
                }
            }
        }
        
        return false
        
    }
    
    func connectAdjParts(){
        for case let part? in connections{
            if(part.degree > self.degree){
                part.removeFromParent()
                self.addChild(part)
                var x = 0
                var y = 0
                let index = self.getConnections().firstIndex(of: part)
                switch index{
                    case 0:
                    y = 1; break
                    case 1:
                    x = 1; break
                    case 2:
                    y = -1; break
                    default:
                    x = -1; break
                }
                let xChange = (self.size.width/2) + (part.size.width/2)
                let yChange = (self.size.height/2) + (part.size.height/2)
                part.move(x: CGFloat(x)*xChange, y: CGFloat(y)*yChange)
                part.connectAdjParts()
            }
        }
    }
    
    func select(i:Int)->[Part]{
        var r:[Part] = [self]
        for case let part? in self.connections{
            if(part.degree > self.degree){
                r.append(contentsOf: part.select(i:i))
            }
        }
        self.degree -= i+1
        return r
    }
    
    func breakConnection(part:Part){
        let i:Int = self.connections.index(of: part)!
        part.connections[opSide(i:i)] = nil
        self.connections[i] = nil
    }
    
    func getParent()->Part?{
        for case let part? in connections{
            if(part.degree < self.degree){
                return part;
            }
        }
        return nil;
    }
    
    func move(x:CGFloat, y: CGFloat){
        self.position = CGPoint(x: self.position.x + x, y: self.position.y + y)
    }
    
    func equals(part:Part)->Bool{
        return self.id == part.id
    }
    
    func numParts()->Int{
        var n = 1
        for case let part? in connections{
            if(part.degree > self.degree){
                n += part.numParts()
            }
        }
        return n
    }
    
    func getCorners()->[CGPoint]{
        var r:[CGPoint] = []
        r.append(CGPoint(x: CGFloat(self.position.x - self.size.width/2), y: CGFloat(self.position.y - self.size.height/2)))
        r.append(CGPoint(x: CGFloat(self.position.x + self.size.width/2), y: CGFloat(self.position.y - self.size.height/2)))
        r.append(CGPoint(x: CGFloat(self.position.x + self.size.width/2), y: CGFloat(self.position.y + self.size.height/2)))
        r.append(CGPoint(x: CGFloat(self.position.x - self.size.width/2), y: CGFloat(self.position.y + self.size.height/2)))
        return r
    }
    
    func checkProximity(with: Part)->[Any?]{
        var r:[Any?] = [self]
        for i in 0...3{
            if(with.connections[opSide(i:i)] != nil || self.connections[i] != nil){
                continue
            }
            
            let r1:[CGPoint] = self.getCorners()
            let r2:[CGPoint] = with.getCorners()
            
            switch i{
            case 0:
                let a = Line(a: r1[3], b: r1[2])
                let b = Line(a: r2[0], b: r2[1])
                if(a.distance(line: b, orientation: 0)){
                    
                    r.append(a.getRect(orientation: 0))
                    r.append(b.getRect(orientation: 0))
                    r.append(0)
                    return r
                }
                break
            case 1:
                let a = Line(a: r1[1], b: r1[2])
                let b = Line(a: r2[0], b: r2[3])
                if(a.distance(line: b, orientation: 1)){
                    r.append(a.getRect(orientation: 1))
                    r.append(b.getRect(orientation: 1))
                    r.append(1)
                    return r
                }
                break
            case 2:
                let a = Line(a: r1[0], b: r1[1])
                let b = Line(a: r2[3], b: r2[2])
                if(a.distance(line: b, orientation: 0)){
                    r.append(a.getRect(orientation: 0))
                    r.append(b.getRect(orientation: 0))
                    r.append(2)
                    return r
                }
                break
            case 3:
                let a = Line(a: r1[0], b: r1[3])
                let b = Line(a: r2[1], b: r2[2])
                if(a.distance(line: b, orientation: 1)){
                    r.append(a.getRect(orientation: 1))
                    r.append(b.getRect(orientation: 1))
                    r.append(3)
                    return r
                }
                break
            default:
                break
            }
        }
        return r
    }
    
    func getSnapDist(main:Part, dir:Int)->[CGFloat]{
        
        var r:[CGFloat] = [0, 0]
        
        switch dir{
        case 0:
            r[0] = self.position.x - (main.position.x)
            r[1] = (self.position.y + self.size.height/2) - ((main.position.y) - ((main.size.height)/2))
            break
        case 1:
            r[0] = (self.position.x + self.size.width/2) - ((main.position.x) - ((main.size.width)/2))
            r[1] = self.position.y - (main.position.y) - (main.offset)
            break
        case 2:
            r[0] = self.position.x - (main.position.x)
            r[1] = (self.position.y - self.size.height/2) - ((main.position.y) + (main.size.height)/2)
            break
        case 3:
            r[0] = (self.position.x - self.size.width/2) - (main.position.x + main.size.width/2)
            r[1] = self.position.y - (main.position.y) - (main.offset)
            break
        default:
            break
        }
        return r
    }
    
    /* ==================================== *
     * ======= FLIGHT FUNCTIONALITY ======= *
     * ==================================== */
    
    func beginTask(){
        
    }
    
    func newAnchor(point:CGPoint){
        
        self.anchorPoint = CGPoint(x: 0.5 + (point.x/self.size.width), y: 0.5 + (point.y/self.size.height))
        
        for case let part? in connections{
            if part.degree > self.degree{
                part.newAnchor(point: point)
            }
        }
    
        
    }
    
    func getCenter()->CGPoint{
        let temp = addPoints()
        let num = CGFloat(numParts())
        return CGPoint(x: temp.x/num, y:temp.y/num)
    }
    
    func posRelativeToRoot()->CGPoint{
        
        var p = self.position
        
        if let part = getParent(){
            let next = part.posRelativeToRoot()
            p = CGPoint(x: p.x + next.x, y: p.y + next.y)
        }
        
        return p
        
    }
    
    func addPoints()->CGPoint{
        
        var cPoint = self.posRelativeToRoot()
        for case let part? in connections{
            if part.degree > self.degree {
                let point = part.addPoints()
                cPoint = CGPoint(x:cPoint.x + point.x, y:cPoint.y + point.y)
            }
        }
        
        return cPoint
    }
 
}

class Cockpit:Part{
    
    init(type:Int){
        super.init(imageName: "cockpit\(type)", type: type)
        self.setScale(1)
        self.zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func beginTask(){
        
    }
    
}

class Decoupler:Part{
    
    private let stageItem = SKSpriteNode(imageNamed: "decouplerStage");
    
    init(type:Int){
        super.init(imageName: "decoupler\(type)", type: type)
        setStats(t: self.getType())
        self.setScale(1)
        self.zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setStats(t: self.getType())
    }
    
    func setStats(t:Int){

    }
    
    func getStageItem()->SKSpriteNode{
        return stageItem
    }
    
    override func beginTask(){
        
    }
    
}

class Engine:Part{
    
    private var fuel:Int
    private let stageItem = SKSpriteNode(imageNamed: "engineStage");
    
    init(type:Int){
        self.fuel = 0
        super.init(imageName: "engine\(type)", type: type)
        setStats(t: self.getType())
        self.setScale(1)
        self.zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.fuel = 0
        super.init(coder: aDecoder)
        setStats(t: self.getType())
    }
    
    func setStats(t:Int){
        switch t{
        case 1:
            self.fuel = 1000
            break
        case 2:
            self.fuel = 10000
            break
        case 3:
            self.fuel = 100000
            break
        default:
            break
        }
    }
    
    func getStageItem()->SKSpriteNode{
        return stageItem
    }
    
    override func beginTask(){
        
    }
    
}

class Line{
    
    private var a:CGPoint
    private var b:CGPoint
    
    init(a:CGPoint, b:CGPoint){
        if(a.x < b.x || a.y < b.y){
            self.a = a
            self.b = b
        }else{
            self.b = a
            self.a = b
        }
    }
    
    //returns the distance between two parrallel lines that are both either horizontal or vertical.
    // 0 = horizontal
    // 1 = vertical
    func distance(line:Line, orientation:Int)->Bool{
        let prox:CGFloat = CGFloat(40)
        if(orientation == 0){
            if(abs(self.a.y - line.a.y) < prox){
                if(self.midpoint().x > line.a.x && self.midpoint().x < line.b.x){
                    return true;
                }
            }
        }else{
            if(abs(self.a.x - line.a.x) < prox){
                if(self.midpoint().y > line.a.y && self.midpoint().y < line.b.y){
                    return true;
                }
            }
        }
        return false;
    }
    
    func midpoint()->CGPoint{
        return CGPoint(x: (a.x + b.x)/2, y: (a.y+b.y)/2)
    }
    
    func getRect(orientation: Int)->SKShapeNode{
        if(orientation == 0){
            let rect = CGRect(origin: a, size: CGSize(width: CGFloat(b.x-a.x), height: CGFloat(10)))
            let r = SKShapeNode(rect: rect)
            r.fillColor = UIColor.green
            r.zPosition = 100
            return r
        }else{
            let rect = CGRect(origin: a, size: CGSize(width: CGFloat(10), height: CGFloat(b.y - a.y)))
            let r = SKShapeNode(rect: rect)
            r.fillColor = UIColor.green
            r.zPosition = 100
            return r
        }
    }
    
    
}

















