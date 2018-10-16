//
//  StageImg.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 10/15/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import Foundation
import SpriteKit

class StageImg:SKSpriteNode{
    
    private var index:Int
    private let part:Part
    private var oPos:CGPoint
    
    //testing
    private var label:SKLabelNode
    
    init(index:Int, part:Part){
        
        self.label = SKLabelNode(text: "\(index)")
        label.zPosition = 110
        label.fontSize = 30
        self.index = index
        self.part = part
        self.oPos = CGPoint(x:0, y:0)
        var name = "engine"
        if part is Decoupler{
            name = "decoupler"
        }
        let tex = SKTexture(imageNamed:"\(name)Stage")
        super.init(texture: tex, color: .clear, size: tex.size())
        
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        self.label.text = "\(self.index)"
    }
    
    func moveStage(i:Int){
        self.index = i;
    }
    
    func delete(){
        self.removeFromParent()
    }
    
    func getPart()->Part{
        return self.part
    }
    
    func getIndex()->Int{
        return self.index
    }
    
    func move(x:CGFloat, y:CGFloat){
        self.position = CGPoint(x: self.position.x + x, y: self.position.y + y)
    }
    
    func updateOriginalPos(){
        oPos = self.position
    }
    
    func returnPos(){
        self.position = oPos
    }
    

}
