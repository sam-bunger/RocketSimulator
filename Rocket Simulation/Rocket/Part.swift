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
    }
    
    private var type:Int
    private var degree:Int
    private var offset:CGFloat
    private let tex:SKTexture
    private var connections:[Part?] = [nil, nil, nil, nil]
    
    init(imageName:String, type:Int){
        self.type = type
        self.degree = 0
        self.offset = 0
        self.tex = SKTexture(imageNamed: imageName)
        super.init(texture: tex, color: .clear, size: tex.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let c = aDecoder.decodeObject(forKey: Keys.Parts) as? [Part?]{
            self.connections = c
        }
        
        self.tex = aDecoder.decodeObject(forKey: Keys.Texture) as! SKTexture
        self.type = aDecoder.decodeInteger(forKey: Keys.ShipType)
        self.degree = aDecoder.decodeInteger(forKey: Keys.Degree)
        self.offset = aDecoder.decodeObject(forKey: Keys.Offset) as! CGFloat
        super.init(texture: tex, color: .clear, size: tex.size())
        
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.type, forKey: Keys.ShipType)
        aCoder.encode(self.texture, forKey: Keys.Texture)
        aCoder.encode(self.degree, forKey: Keys.Degree)
        aCoder.encode(self.offset, forKey: Keys.Offset)
        aCoder.encode(self.connections, forKey: Keys.Parts)
    }
    
    //GETTERS AND SETTERS
    func getConnection(at:Int)->Part?{
        return self.connections[at]
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
    
    /*
     *  Make a new connection
     */
    func makeConnection(part:Part, at:Int, offset:CGFloat){
        self.degree = part.getDegree() + 1;
        self.offset = offset;
        for case let con? in connections{
            if(self.degree > con.degree){
                con.makeConnection(part: con, at: self.connections.index(of: con)!, offset: con.offset)
            }
        }
        self.connections[opSide(i: at)] = part
    }
    
    //Find the opposite side of a function
    func opSide(i:Int)->Int{
        if(i < 2 && i >= 0){
            return i + 2
        }else{
            return i - 2
        }
    }
    
    func select()->[Part]{
        var r:[Part] = [self]
        for case let part? in self.connections{
            if(part.degree > self.degree){
                r.append(contentsOf: part.select())
            }
        }
        return r
    }
    
    func breakConnection(){
        for case let part? in connections{
            if(part.degree < self.degree){
                let i = self.connections.index(of: part)!
                part.connections[opSide(i:i)] = nil
                self.connections[i] = nil
            }
        }
    }
    
    func move(x:CGFloat, y: CGFloat){
        self.position = CGPoint(x: self.position.x + x, y: self.position.y + y)
    }
    
    func pressed(){
        let fadeOut = SKAction.fadeAlpha(to: 0.70, duration: 0.1)
        self.run(fadeOut)
    }
    
    func released(){
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        self.run(fadeIn)
    }
    
    func checkProximity(with: Part)->[Any?]{
        for i in 0...3{
            if with.connections[i] != nil{
                continue
            }
            
        }
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
    
}

class Engine:Part{
    
    init(type:Int){
        super.init(imageName: "engine\(type)", type: type)
        self.setScale(1)
        self.zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

















