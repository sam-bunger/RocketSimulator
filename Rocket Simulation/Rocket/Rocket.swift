//
//  Rocket.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 9/4/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import Foundation
import SpriteKit

class Rocket: NSObject, NSCoding{
    
    private struct Keys{
        static let Root = "root"
        static let Name = "name"
        static let Stage = "currentStage"
    }
    
    private let root:Part
    private var givenName:String
    private var currentStage:Stage
    
    override init(){
        self.currentStage = Stage()
        self.root = Cockpit(type: 0)
        self.givenName = "Untitled Rocket"
    }
    
    init(root:Part, stage:Stage){
        self.root = root
        self.givenName = ""
        self.currentStage = stage
        super.init()
    }
    
    func getSize()->CGRect{
        return getSize(last:root)
    }
    
    func getSize(last:Part)->CGRect{
        let rect = last.calculateAccumulatedFrame()
        for case let part? in last.getConnections(){
            if(part.getDegree() > last.getDegree()){
                return rect.union(getSize(last: part))
            }
        }
        return rect
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.root, forKey: Keys.Root)
        aCoder.encode(self.givenName, forKey: Keys.Name)
        aCoder.encode(self.currentStage, forKey: Keys.Stage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.root = aDecoder.decodeObject(forKey: Keys.Root) as! Part
        self.givenName = aDecoder.decodeObject(forKey: Keys.Name) as! String
        self.currentStage = aDecoder.decodeObject(forKey: Keys.Stage) as! Stage
        super.init()
    }
    
    func add(scene:SKNode){
        self.root.zPosition = 100
        scene.addChild(self.root)
    }
    
    func getRoot()->Part{
        return root
    }
    
    func clearParent(){
        self.root.removeFromParent()
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
        self.root.setScale(by)
    }
    
    func position(x:CGFloat, y:CGFloat){
        self.root.position = CGPoint(x: x, y: y)
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
        
        
    }
    
    func stage(){
        if let stage = currentStage.deploy(){
            currentStage = stage
        }
    }


}
