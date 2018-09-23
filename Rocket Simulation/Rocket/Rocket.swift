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
        static let Size = "size"
        static let Name = "name"
    }
    
    private let root:Part
    private var name:String
    private var size:CGRect
    
    override init(){
        self.root = Cockpit(type: 0)
        self.name = "Untitled Rocket"
        self.size = self.root.calculateAccumulatedFrame()
    }
    
    init(root:Part, name:String){
        self.root = root
        self.name = name
        self.size = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        super.init()
        self.size = getSize(root: self.root)
    }
    
    func getSize(root:Part)->CGRect{
        let rect = root.calculateAccumulatedFrame()
        for case let part? in root.getConnections(){
            return rect.union(getSize(root: part))
        }
        return rect
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.root, forKey: Keys.Root)
        aCoder.encode(self.name, forKey: Keys.Name)
        aCoder.encode(self.size, forKey: Keys.Size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.root = aDecoder.decodeObject(forKey: Keys.Root) as! Part
        self.name = aDecoder.decodeObject(forKey: Keys.Name) as! String
        self.size = aDecoder.decodeObject(forKey: Keys.Size) as! CGRect
        super.init()
    }
    
    func setName(name:String){
        self.name = name
    }
    
    func getName()->String{
        return self.name
    }

}
