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
    }
    
    private let root:Part
    private let size:CGRect
    
    init(root:Part){
        self.root = root
    }
    
    func encode(with aCoder: NSCoder) {
        <#code#>
    }
    
    required init?(coder aDecoder: NSCoder) {
        <#code#>
    }

}
