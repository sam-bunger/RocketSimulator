//
//  Stage.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 9/24/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import Foundation

class Stage:NSObject, NSCoding{
    
    private struct Keys{
        static var Next = "nextStage"
        static var Tasks = "tasks"
    }
    
    private let nextStage:Stage?
    private var tasks:[Part]
    
    override init(){
        self.nextStage = nil
        self.tasks = []
        super.init()
    }
    
    init(next: Stage){
        self.nextStage = next
        tasks = []
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.nextStage = aDecoder.decodeObject(forKey: Keys.Next) as? Stage
        self.tasks = aDecoder.decodeObject(forKey: Keys.Tasks) as! [Part]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.tasks, forKey: Keys.Tasks)
        aCoder.encode(self.nextStage, forKey: Keys.Next)
    }
    
    func addTask(task:Part){
        tasks.append(task)
    }
    
    func removeTask(task:Part){
        tasks.remove(at: tasks.index(of: task)!)
    }
    
    func deploy()->Stage?{
        for task in tasks{
            task.beginTask()
        }
        return self.nextStage
    }
    
    
}
