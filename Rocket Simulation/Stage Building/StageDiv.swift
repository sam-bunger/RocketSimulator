//
//  StageDiv.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 10/15/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import Foundation
import SpriteKit

class StageDiv:SKSpriteNode{
    
    var index:Int
    private var label:SKLabelNode
    
    init(index:Int){
        self.index = index
        self.label = SKLabelNode(text: "\(index)")
        label.zPosition = 110
        label.fontSize = 30
        let tex = SKTexture(imageNamed:"StageDiv")
        super.init(texture: tex, color: .clear, size: tex.size())
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        self.label.text = "\(self.index)"
    }
    
    func getIndex()->Int{
        return self.index
    }
    
    func moveStage(i:Int){
        self.index = i
    }
    
    func move(x:CGFloat, y:CGFloat){
        self.position = CGPoint(x: self.position.x + x, y: self.position.y + y)
    }
    
}
