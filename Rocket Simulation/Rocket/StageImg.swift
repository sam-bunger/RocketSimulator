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
    
    init(index:Int, part:Part){
        self.index = index
        self.part = part
        var name = "engine"
        if part is Decoupler{
            name = "decoupler"
        }
        let tex = SKTexture(imageNamed:"\(name)Stage")
        super.init(texture: tex, color: .clear, size: tex.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    

}
