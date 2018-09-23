//
//  BuildScene.swift
//  Rocket Simulation
//
//  Created by Sam Bunger on 9/4/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import SpriteKit
import GameplayKit

class BuildScene: SKScene{
    
    let defaults = UserDefaults.standard
    let gvc:GameViewController
    var numOfSaves:Int
    
    var gameArea: CGRect
    
    var delButFaded = true
    var delButEnlarged = false
    var saveButEnlarged = false
    
    var mainSelect:Part?
    var selected:[Part]
    var notSelected:[Part]
    var list:[Part]
    
    var itemMenuIsOpen = false
    var saveMenuIsOpen = false
    var isConnection = false
    
    var connectionReady:[Any?] = [1, 2, 3]
    var found = false;
    
    let rocketItemsButton = SKSpriteNode(imageNamed: "rocketItemsTabButton")
    let itemsTab = SKSpriteNode(imageNamed: "rocketItemsTab")
    let background = SKSpriteNode(imageNamed: "backgroundBuild")
    let deleteTab = SKSpriteNode(imageNamed: "trash")
    let saveTab = SKSpriteNode(imageNamed: "save")
    let dim = SKSpriteNode(imageNamed: "dimmed")
    
    let saveRect = SKShapeNode(rectOf: CGSize(width: 900, height: 600), cornerRadius: 20)
    let saveBut = SKShapeNode(rectOf: CGSize(width: 275, height: 150), cornerRadius: 10)
    let cancelBut = SKShapeNode(rectOf: CGSize(width: 275, height: 150), cornerRadius: 10)
    
    let saveLabel = SKLabelNode(fontNamed: "Japanese 3017")
    let saveButLabel = SKLabelNode(fontNamed: "Japanese 3017")
    let cancelButLabel = SKLabelNode(fontNamed: "Japanese 3017")
    
    let deleteTabScale = CGFloat(0.3)
    let saveTabScale = CGFloat(0.057)
    
    override func didMove(to view: SKView) {
        
        //BACKGROUND
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        //ITEMS MENU BUTTON
        rocketItemsButton.setScale(1.5)
        rocketItemsButton.position = CGPoint(x: gameArea.origin.x + gameArea.size.width*0.1, y: gameArea.size.height*0.9)
        rocketItemsButton.zPosition = 99
        self.addChild(rocketItemsButton)
        
        //ITEMS MENU BACKGROUND TAB
        itemsTab.setScale(1.05)
        itemsTab.position = CGPoint(x: gameArea.origin.x - 205, y: gameArea.size.height/2)
        itemsTab.zPosition = 99
        self.addChild(itemsTab)
        
        //TRASH BUTTON
        deleteTab.setScale(deleteTabScale)
        deleteTab.position = CGPoint(x: gameArea.origin.x + gameArea.size.width*0.9, y: gameArea.size.height*0.1)
        deleteTab.zPosition = 1
        deleteTab.alpha = 0.1
        self.addChild(deleteTab)
        
        //SAVE BUTTON
        saveTab.setScale(saveTabScale)
        saveTab.position = CGPoint(x: gameArea.origin.x + gameArea.size.width*0.9, y: gameArea.size.height*0.9)
        saveTab.zPosition = 1
        saveTab.alpha = 0.1
        self.addChild(saveTab)
        
        //BACKGROUND DIMMER
        dim.setScale(1)
        dim.position = CGPoint(x: self.size.width/2, y: gameArea.size.height/2)
        dim.zPosition = 100
        
        //SAVE MENU SHAPES
        saveRect.fillColor = SKColor.darkGray
        saveRect.strokeColor = SKColor.black
        saveRect.lineWidth = 5
        saveRect.position = CGPoint(x: self.size.width/2, y: gameArea.size.height*0.65)
        saveRect.zPosition = 101
        
        saveBut.fillColor = UIColor(displayP3Red: 0.7294117647, green: 0.3137254902, blue: 0.3137254902, alpha: 1.0)
        //saveBut.strokeColor = SKColor.black
        saveBut.lineWidth = 0
        saveBut.position = CGPoint(x: self.size.width/2 + 210, y: gameArea.size.height*0.56)
        saveBut.zPosition = 101
        
        cancelBut.fillColor = UIColor(displayP3Red: 0.7294117647, green: 0.3137254902, blue: 0.3137254902, alpha: 1.0)
        //cancelBut.strokeColor = SKColor.black
        cancelBut.lineWidth = 0
        cancelBut.position = CGPoint(x: self.size.width/2 - 210, y: gameArea.size.height*0.56)
        cancelBut.zPosition = 101
        
        //SAVE MENU LABELS
        saveLabel.text = "Save this ship?"
        saveLabel.fontSize = 100
        saveLabel.color = SKColor.white
        saveLabel.position = CGPoint(x: self.size.width/2, y: gameArea.size.height*0.68)
        saveLabel.zPosition = 102
        
        saveButLabel.text = "Save"
        saveButLabel.fontSize = 50
        saveButLabel.color = SKColor.white
        saveButLabel.position = CGPoint(x: self.size.width/2 + 210, y: gameArea.size.height*0.55)
        saveButLabel.zPosition = 102
        
        cancelButLabel.text = "Cancel"
        cancelButLabel.fontSize = 50
        cancelButLabel.color = SKColor.white
        cancelButLabel.position = CGPoint(x: self.size.width/2 - 210, y: gameArea.size.height*0.55)
        cancelButLabel.zPosition = 102
        
        
        //IMPLEMENT MENU ITEMS
        buildItemsMenu()
        
    }
    
    init(size:CGSize, gvc: GameViewController){
        let screenSize = UIScreen.main.bounds
        let maxAspectRatio: CGFloat = screenSize.height/screenSize.width
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y:0, width: playableWidth, height: size.height)
        numOfSaves = 0//defaults.integer(forKey: DefaultKeys.saveNum)
        self.gvc = gvc
        self.selected = []
        self.notSelected = []
        self.list = []
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            //When the menu is open
            if(itemMenuIsOpen){
                //CLOSE MENU
                if(background.contains(pointOfTouch) && !itemsTab.contains(pointOfTouch)){
                    closeItemsMenu()
                }
            }
            
            //When the menu is closed
            if(!itemMenuIsOpen && !saveMenuIsOpen){
                //OPEN MENU
                if(rocketItemsButton.contains(pointOfTouch)){
                    openItemsMenu()
                }
                //SELECT ITEMS
                for part: Part in notSelected{
                    if part.contains(pointOfTouch) && selected.isEmpty{
                        print("prev deg: \(part.getDegree())")
                        if let p1 = part.getParent(){
                            let temp = part.select(i: p1.getDegree())
                            selected.append(contentsOf: temp)
                            for t:Part in temp{
                                notSelected.remove(at: notSelected.index(of:t)!)
                            }
                            part.breakConnection(part: p1)
                            print("nonroot selected")
                        }else{
                            let temp = part.select(i: -1)
                            selected.append(contentsOf: temp)
                            for t:Part in temp{
                                notSelected.remove(at: notSelected.index(of:t)!)
                            }
                            print("root selected")
                        }
                        mainSelect = part
                        print("next deg: \(part.getDegree())")
                        print("----------------------")
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDraggedY = pointOfTouch.y - previousPointOfTouch.y
            let amountDraggedX = pointOfTouch.x - previousPointOfTouch.x
            
            //Allow selected item(s) to be move
            if !selected.isEmpty{
                for items:Part in selected{
                    items.move(x:amountDraggedX, y:amountDraggedY)
                }
            }
            
            //Allow connection bars to move too
            if !connectionReady.isEmpty{
                if let side = connectionReady[2] as? SKShapeNode{
                    side.position.x += amountDraggedX
                    side.position.y += amountDraggedY
                }
            }
            
            //Allows for the scrolling of items
            if(itemMenuIsOpen && !saveMenuIsOpen){
                if(!(list.first!.position.y + (list.first!.size.height/2) + amountDraggedY > gameArea.size.height || list.last!.position.y - (list.last!.size.height/2) + amountDraggedY < 0)){
                    for part:Part in list{
                        part.move(x:0, y: amountDraggedY)
                    }
                }
            }else{
                if(!selected.isEmpty && deleteTab.contains(pointOfTouch) && !delButEnlarged){
                    scale(button: deleteTab, amount: deleteTabScale + 0.1, duration: 0.1)
                    delButEnlarged = true
                }
                if(!selected.isEmpty && !deleteTab.contains(pointOfTouch) && delButEnlarged){
                    scale(button: deleteTab, amount: deleteTabScale, duration: 0.1)
                    delButEnlarged = false
                }
                if(!selected.isEmpty && saveTab.contains(pointOfTouch) && !saveButEnlarged){
                    scale(button: saveTab, amount: saveTabScale + 0.05, duration: 0.1)
                    saveButEnlarged = true
                }
                if(!selected.isEmpty && !saveTab.contains(pointOfTouch) && saveButEnlarged){
                    scale(button: saveTab, amount: saveTabScale, duration: 0.1)
                    saveButEnlarged = false
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            //SELECTING ITEMS IN ITEMS MENU
            for part:Part in list{
                if part.contains(pointOfTouch){
                    if let obj = part as? Cockpit{
                        let a = Cockpit(type: obj.getType())
                        add(a: a)
                    }else if let obj = part as? Engine{
                        let a = Engine(type: obj.getType())
                        add(a: a)
                    }
                    closeItemsMenu()
                    break
                }
            }
            
            //DELETING ITEMS
            if(delButEnlarged){
                scale(button: deleteTab, amount: deleteTabScale, duration: 0.1)
                for part:Part in selected{
                    part.removeFromParent()
                }
                mainSelect = nil
                selected.removeAll()
                delButEnlarged = false
            }
            
            //SAVING ITEMS
            if(saveButEnlarged && !saveMenuIsOpen){
                openSaveMenu()
            }else if(saveMenuIsOpen){
                if(saveBut.contains(pointOfTouch)){
                    if let main = mainSelect, main.getDegree() == 0{
                        
                        //let newRocket = Rocket(root: main)
                       // gvc.displayAlertAction(rocket: newRocket)
                    }
                }
                if(cancelBut.contains(pointOfTouch)){
                    closeSaveMenu()
                }
            }
        }
        
        //DESELECTING ITEMS
        if(!itemMenuIsOpen && !selected.isEmpty){
            if connectionReady.isEmpty{
                if mainSelect != nil{
                    for part:Part in selected{
                        notSelected.append(part)
                        part.zPosition = CGFloat(notSelected.count) + 1
                    }
                }
            }else{
                let a:Part = connectionReady[0] as! Part
                if let main = mainSelect{
                    main.makeConnection(part: a, at: connectionReady[3] as! Int, offset: 0)
                    let directions = a.getSnapDist(main: main, dir: connectionReady[3] as! Int)
                    for part:Part in selected{
                        if a.alpha == 1 {
                        }
                        notSelected.append(part)
                        part.zPosition = CGFloat(notSelected.count) + 1
                        
                        part.position.x += directions[0]
                        part.position.y += directions[1]
                        
                    }
                }
            }
            mainSelect = nil
            selected.removeAll()
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //Fade Effect on the Delete Button
        if !selected.isEmpty && delButFaded{
            let fadeIn = SKAction.fadeAlpha(by: 0.9, duration: 0.5)
            deleteTab.run(fadeIn)
            saveTab.run(fadeIn)
            delButFaded = false
        }else if selected.isEmpty && !delButFaded{
            let fadeOut = SKAction.fadeAlpha(by: -0.9, duration: 0.5)
            deleteTab.run(fadeOut)
            saveTab.run(fadeOut)
            delButFaded = true
        }
        
        for part:Part in notSelected{
            part.update()
        }
        
        for part:Part in selected{
            part.update()
        }
        
        if let main = mainSelect{
            for part:Part in notSelected{
                let arr = part.checkProximity(with: main);
                if(arr.count > 1){
                    if(connectionReady.isEmpty){//} || (!(arr[0] as! Part).equals(part: (connectionReady[0] as! Part)) && (arr[3] as! Int) != (connectionReady[3] as! Int))){
                        
                        self.addChild(arr[1] as! SKShapeNode)
                        self.addChild(arr[2] as! SKShapeNode)
                        connectionReady = arr
                        
                        return
                    }else{
                        return
                    }
                }
            }
            
        }
        if(!connectionReady.isEmpty){
            if let con = (connectionReady[1] as? SKShapeNode){
                con.removeFromParent()
            }
            if let con = (connectionReady[2] as? SKShapeNode){
                con.removeFromParent()
            }
            connectionReady.removeAll()
        }
        
    }
    
    //Places build items into the side menu
    func buildItemsMenu(){
        
        var counter = 0
        var yDistribution = CGFloat(0);
        let x = gameArea.origin.x - 200
        
        //Warheads
        for i in 1...1{
            let cockpit = Cockpit(type: i)
            counter += 1
            yDistribution = cockpit.size.height/2 + 50
            cockpit.position = CGPoint(x: x, y: gameArea.size.height - (yDistribution * CGFloat(counter)))
            cockpit.zPosition = 100
            cockpit.setScale(1)
            self.addChild(cockpit)
            list.append(cockpit)
        }
        
        //Engines
        for i in 1...1{
            let engine = Engine(type: i)
            counter += 1
            yDistribution = engine.size.height/2 + 50
            engine.position = CGPoint(x: x, y: gameArea.size.height - (yDistribution * CGFloat(counter)))
            engine.zPosition = 100
            engine.setScale(1)
            self.addChild(engine)
            list.append(engine)
        }
        
    }
    
    func openItemsMenu(){
        itemMenuIsOpen = true
        let moveRight = SKAction.moveBy(x: 400, y: 0, duration: 0.2)
        itemsTab.run(moveRight)
        rocketItemsButton.run(moveRight)
        for parts in list{
            parts.run(moveRight)
        }
    }
    
    func closeItemsMenu(){
        itemMenuIsOpen = false
        let moveLeft = SKAction.moveBy(x: -400, y: 0, duration: 0.2)
        itemsTab.run(moveLeft)
        rocketItemsButton.run(moveLeft)
        for parts in list{
            parts.run(moveLeft)
        }
    }
    
    func scale(button: SKSpriteNode, amount: CGFloat, duration: CGFloat){
        let scale = SKAction.scale(to: amount, duration: TimeInterval(duration))
        let waitAction = SKAction.wait(forDuration: TimeInterval(duration+0.1))
        let seq = SKAction.sequence([scale, waitAction])
        button.run(seq)
    }
    
    func openSaveMenu(){
        saveMenuIsOpen = true
        self.addChild(dim)
        self.addChild(saveRect)
        self.addChild(saveBut)
        self.addChild(cancelBut)
        self.addChild(saveLabel)
        self.addChild(saveButLabel)
        self.addChild(cancelButLabel)
    }
    
    func closeSaveMenu(){
        saveMenuIsOpen = false
        dim.removeFromParent()
        saveRect.removeFromParent()
        saveBut.removeFromParent()
        cancelBut.removeFromParent()
        saveLabel.removeFromParent()
        saveButLabel.removeFromParent()
        cancelButLabel.removeFromParent()
    }
    
    func add(a:Part){
        a.center(scene: self)
        a.zPosition = CGFloat(notSelected.count) + 1
        notSelected.append(a)
        self.addChild(a)
    }

    func changeScene(scene: SKScene, move: SKTransitionDirection){
        
        scene.scaleMode = self.scaleMode
        let myTransition = SKTransition.push(with: move, duration: 0.5)
        self.view!.presentScene(scene, transition: myTransition)
        
    }
    
}

