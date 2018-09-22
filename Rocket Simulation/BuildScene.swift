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
        numOfSaves = defaults.integer(forKey: DefaultKeys.saveNum)
        self.gvc = gvc
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
                for part: Part in list{
                    if part.contains(pointOfTouch) && selected.isEmpty{
                        selected.append(contentsOf: part.select())
                        part.breakConnection()
                        mainSelect = part
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
            
            for i in 1...2{
                if var side:CGRect = connectionReady[i] as! CGRect{
                    side.origin.x += amountDraggedX
                    side.origin.y += amountDraggedY
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
                        let part = Cockpit(type: obj.getType())
                    }else if let obj = part as? Engine{
                        let part = Engine(type: obj.getType())
                    }
                    part.center(scene: self)
                    part.zPosition = CGFloat(notSelected.count) + 1
                    notSelected.append(part)
                    self.addChild(part)
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
                        
                        let newRocket = Rocket(root: main)
                        gvc.displayAlertAction(rocket: newRocket)
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
                if let main = mainSelect{
                    for part:Part in selected{
                        part.pressed()
                        notSelected.append(part)
                        part.zPosition = CGFloat(notSelected.count) + 1
                    }
                }
            }else{
                let partA:Part = connectionReady[2] as! ShipPart
                let dir2 = (connectionReady[1] as! ConnectionRect).getDirection()
                let dir1 = (connectionReady[0] as! ConnectionRect).getDirection()
                makeConnection(part1: partA, part2: mainSelection!, dir1: dir1, dir2: dir2, offset: partA.position.y-(mainSelection?.position.y)!)
                let directions:[CGFloat] = getDirections(part:partA, dir1: dir1, dir2: dir2)
                
                for part:ShipPart in selectedItems{
                    if partA.alpha == 1 {
                        part.released()
                    }
                    buildItems.append(part)
                    part.zPosition = CGFloat(buildItems.count) + 1
                    part.position.x += directions[0]
                    part.position.y += directions[1]
                    for rect:ConnectionRect in part.getRects(){
                        rect.position.x += directions[0]
                        rect.position.y += directions[1]
                    }
                    part.centerRootRect()
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
        
        
        //Detect Potential Connection
        if let main = mainSelect{
            for part:Part in notSelected{
                connectionReady = part.checkProximity(with: main)
            }
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
    
    func getDirection(dir1:Int, dir2:Int) -> Int{
        if(dir1 == 2 && dir2 == 0){
            return 0
        }else if(dir1 == 0 && dir2 == 2){
            return 2
        }else if(dir1 == 1 && dir2 == 3){
            return 3
        }else if(dir1 == 3 && dir2 == 1){
            return 1
        }
        return -1
    }
    
    func getDirections(part:ShipPart, dir1:Int, dir2:Int) -> [CGFloat]{
        
        let direction = getDirection(dir1: dir1, dir2: dir2)
        var dirArr:[CGFloat] = [0, 0]
        
        switch direction{
        case 0:
            dirArr[0] = part.position.x - (mainSelection?.position.x)!
            dirArr[1] = (part.position.y + part.size.height/2) - ((mainSelection?.position.y)! - ((mainSelection?.size.height)!/2))
        case 1:
            //Left to Right
            dirArr[0] = (part.position.x + part.size.width/2) - ((mainSelection?.position.x)! - ((mainSelection?.size.width)!/2))
            dirArr[1] = part.position.y - (mainSelection?.position.y)! - (mainSelection?.getConnection(at: 3)?.offset)!
        case 2:
            //Bot to Top
            dirArr[0] = part.position.x - (mainSelection?.position.x)!
            dirArr[1] = (part.position.y - part.size.height/2) - ((mainSelection?.position.y)! + (mainSelection?.size.height)!/2)
        case 3:
            //Right to Left
            dirArr[0] = (part.position.x - part.size.width/2) - ((mainSelection?.position.x)! + (mainSelection?.size.width)!/2)
            dirArr[1] = part.position.y - (mainSelection?.position.y)! - (mainSelection?.getConnection(at: 1)?.offset)!
        default:
            return dirArr
        }
        return dirArr
    }
    
    func makeConnection(part1:ShipPart, part2:ShipPart, dir1:Int, dir2:Int, offset: CGFloat){
        
        let con:connection
        
        let direction = getDirection(dir1: dir1, dir2: dir2)
        if(part2.checkIsRoot()){
            con = connection(connection1: part2, connection2: part1, offset: offset)
            part1.released()
        }else{
            con = connection(connection1: part1, connection2: part2, offset: offset)
        }
        switch direction{
        case 0:
            //Top to Bot
            part1.setConnection(con: con, at: 0)
            part2.setConnection(con: con, at: 2)
        case 1:
            //Left to Right
            part1.setConnection(con: con, at: 1)
            part2.setConnection(con: con, at: 3)
        case 2:
            //Bot to Top
            part1.setConnection(con: con, at: 2)
            part2.setConnection(con: con, at: 0)
        case 3:
            //Right to Left
            part1.setConnection(con: con, at: 3)
            part2.setConnection(con: con, at: 1)
        default:
            return
        }
        
    }
    
    func changeScene(scene: SKScene, move: SKTransitionDirection){
        
        scene.scaleMode = self.scaleMode
        let myTransition = SKTransition.push(with: move, duration: 0.5)
        self.view!.presentScene(scene, transition: myTransition)
        
    }
    
}

