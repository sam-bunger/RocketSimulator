//
//  FlightScene.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 10/17/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import Foundation
import GameplayKit

class FlightScene:SKScene{
    
    //Game Scene Items
    private var gameArea: CGRect
    private let gvc:GameViewController
    
    //Content
    private let rocket:Rocket
    private let sol:System
    private let cam:SKCameraNode
    private let hud:HUD
    
    //Time Keeping
    var lastTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        // Add camera to view
        self.camera = cam
        
        let mapZoom = UIPinchGestureRecognizer(target: self, action: #selector(mapZoom(recognizer:)))
        self.view!.addGestureRecognizer(mapZoom)
    }
    
    init(size:CGSize, gvc: GameViewController, rocket: Rocket){
        
        //Initialize GameArea
        let screenSize = UIScreen.main.bounds
        let maxAspectRatio: CGFloat = screenSize.height/screenSize.width
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y:0, width: playableWidth, height: size.height)
        
        //Other Vars
        self.rocket = rocket
        self.sol = System()
        self.cam = SKCameraNode()
        self.hud = HUD(system: sol, cam: cam, gameArea: gameArea)
        self.gvc = gvc
        
        super.init(size: size)
        
        //Add rocket to camera
        self.cam.addChild(rocket.getRoot())
        
        //Add system to view
        self.addChild(sol.getPrimaryNode())
        
        //Add Camera
        self.addChild(cam)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //USER INPUT
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDraggedY = pointOfTouch.y - previousPointOfTouch.y
            let amountDraggedX = pointOfTouch.x - previousPointOfTouch.x
            
            hud.touchesMoved(x: amountDraggedX, y: amountDraggedY)
            
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            //let pointOfTouch = touch.location(in: cam)
            
            hud.touchesEnded(touch: touch)
            
            break
        }
        
    }
    
    @objc func mapZoom(recognizer: UIPinchGestureRecognizer){
        if recognizer.state == .changed {
            hud.scaleMap(scale: recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let delta = hud.getMultiplyer()*CGFloat(getDelta(currentTime: currentTime))
        
        sol.update(delta: delta)
        rocket.update(delta: delta)

    }
    
    private func getDelta(currentTime: TimeInterval)->TimeInterval{
        var delta: TimeInterval = currentTime - lastTime
        lastTime = currentTime
        
        if delta >= 1.0 {
            delta = 1.0
        }
        return delta
    }
    
}

