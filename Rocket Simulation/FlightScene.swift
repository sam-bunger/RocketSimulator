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
    var tCurrent:CGFloat = CGFloat(0)
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
    
        //Add system to view
        self.addChild(sol.getPrimaryNode())
    
        //Add Camera
        self.addChild(cam)
        self.camera = cam
        
        let mapZoom = UIPinchGestureRecognizer(target: self, action: #selector(mapZoom(recognizer:)))
        view.addGestureRecognizer(mapZoom)
        
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
        self.sol = System(rocket:rocket)
        self.cam = SKCameraNode()
        self.hud = HUD(system: sol, rocket: rocket, cam: cam, gameArea: gameArea)
        self.gvc = gvc
        
        super.init(size: size)
        
        hud.mapSet(on: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)

            hud.touchesBegan(touch: touch, mainPoint: pointOfTouch)
        
        }
    }
    
    //USER INPUT
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
        
            
            let amountDraggedY = (pointOfTouch.y - previousPointOfTouch.y)
            let amountDraggedX = (pointOfTouch.x - previousPointOfTouch.x)
            
            cam.touchesMoved(touches, with: event)
            
            hud.touchesMoved(x: amountDraggedX, y: amountDraggedY)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            hud.touchesEnded(touch: touch, mainPoint: pointOfTouch)
            
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
        tCurrent += delta
        
        sol.update(delta: delta, ct: tCurrent)
        rocket.update(delta: delta, ct: tCurrent)
        
    }
    
    override func didSimulatePhysics() {
        
    }
    
    override func didFinishUpdate() {
        hud.update(ct: tCurrent)
    }
    
    private func getDelta(currentTime: TimeInterval)->TimeInterval{
        let delta: TimeInterval = currentTime - lastTime
        lastTime = currentTime
        return delta
    }
    
}

