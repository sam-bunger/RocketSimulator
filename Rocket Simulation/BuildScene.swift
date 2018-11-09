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
    
    //SELECTION LIST
    var mainSelect:Part?
    var root:Part?
    var selected:[Part]
    var notSelected:[Part]
    
    //ITEM LIST
    var list:[Part]
    
    //STAGE LIST
    var stageImgs:[[SKSpriteNode]]
    var stageLength:CGFloat
    var selectedStage:StageImg? = nil
    var newStage:SKSpriteNode? = nil
    
    
    var itemMenuIsOpen = false
    var saveMenuIsOpen = false
    var stageMenuIsOpen = false
    var isConnection = false
    
    var connectionReady:[Any?] = [1, 2, 3]
    var found = false
    
    let rocketItemsButton = SKSpriteNode(imageNamed: "rocketItemsTabButton")
    let itemsTab = SKSpriteNode(imageNamed: "rocketItemsTab")
    let background = SKSpriteNode(imageNamed: "backgroundBuild")
    let deleteTab = SKSpriteNode(imageNamed: "trash")
    let saveTab = SKSpriteNode(imageNamed: "save")
    let dim = SKSpriteNode(imageNamed: "dimmed")
    
    //Stage-Related Sprites
    let stagesBut = SKSpriteNode(imageNamed: "stageButton")
    
    let saveRect = SKShapeNode(rectOf: CGSize(width: 900, height: 600), cornerRadius: 20)
    let saveBut = SKShapeNode(rectOf: CGSize(width: 275, height: 150), cornerRadius: 10)
    let cancelBut = SKShapeNode(rectOf: CGSize(width: 275, height: 150), cornerRadius: 10)
    
    let saveLabel = SKLabelNode(fontNamed: "KoHo-Bold")
    let saveButLabel = SKLabelNode(fontNamed: "KoHo-Bold")
    let cancelButLabel = SKLabelNode(fontNamed: "KoHo-Bold")
    
    let deleteTabScale = CGFloat(0.3)
    let saveTabScale = CGFloat(0.057)
    let stageScale = CGFloat(0.5)
    
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
        
        //stages button
        stagesBut.setScale(stageScale)
        stagesBut.position = CGPoint(x: gameArea.origin.x + gameArea.size.width*0.1, y: gameArea.size.height*0.1)
        stagesBut.zPosition = 1
        stagesBut.alpha = 0.9
        self.addChild(stagesBut)
        
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
        //Stage Items
        let fDiv = StageDiv(index: -1)
        fDiv.position = CGPoint(x: gameArea.origin.x - 200, y: gameArea.size.height - (fDiv.size.height/2))
        fDiv.zPosition = 100
        fDiv.setScale(1)
        self.stageImgs = [[fDiv]]
        self.stageLength = fDiv.size.height
        
        super.init(size: size)
        
        //add first divider
        self.addChild(fDiv)
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
                return
            }
            
            if(stageMenuIsOpen){
                //SELECT STAGE
                for stage in stageImgs{
                    for task in stage{
                        if task is StageImg && task.contains(pointOfTouch){
                            (task as? StageImg)?.updateOriginalPos();
                            selectedStage = task as? StageImg
                            selectedStage?.getPart().color = .green
                            selectedStage?.getPart().colorBlendFactor = 0.6
                        }
                    }
                }
                //CLOSE
                if(background.contains(pointOfTouch) && !itemsTab.contains(pointOfTouch)){
                    closeStageMenu()
                }
                return
            }
            
            //When the menu is closed
            if(!itemMenuIsOpen && !saveMenuIsOpen && !stageMenuIsOpen){
                //OPEN MENU
                if(rocketItemsButton.contains(pointOfTouch)){
                    openItemsMenu()
                }
                
                if(stagesBut.contains(pointOfTouch)){
                    openStageMenu()
                }
                
                //SELECT ITEMS
                for part: Part in notSelected{
                    if part.contains(pointOfTouch) && selected.isEmpty{
                        if let p1 = part.getParent(){
                            let temp = part.select(i: p1.getDegree())
                            selected.append(contentsOf: temp)
                            for t:Part in temp{
                                notSelected.remove(at: notSelected.index(of:t)!)
                            }
                            part.breakConnection(part: p1)
                        }else{
                            let temp = part.select(i: -1)
                            selected.append(contentsOf: temp)
                            for t:Part in temp{
                                notSelected.remove(at: notSelected.index(of:t)!)
                            }
                        }
                        mainSelect = part
                    }
                }
            }
            
            break
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDraggedY = pointOfTouch.y - previousPointOfTouch.y
            let amountDraggedX = pointOfTouch.x - previousPointOfTouch.x
            
            //Allow selected stage to be moved
            if selectedStage != nil{
                let current = selectedStage!
                current.move(x:amountDraggedX, y:amountDraggedY)
                
                //find where stage is being moved to
                var taskFound = false;
                for stage in stageImgs{
                    for task in stage{
                        if let t = task as? StageImg{
                            if t.getIndex() == current.getIndex() {
                                continue
                            }
                        }
                        if task.contains(pointOfTouch){
                            newStage = task
                            taskFound = true;
                            //Change task color
                            task.color = .green
                            task.colorBlendFactor = 0.5
                        }else{
                            task.colorBlendFactor = 0.0
                        }
                    }
                }
                if !taskFound{
                    newStage = nil;
                }
            }
            
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
            
            if(stageMenuIsOpen && selectedStage == nil){
                let first = stageImgs.first!.first!
                let last = stageImgs.last!.last!
                let top = first.position.y - gameArea.size.height + (first.size.height/2) + amountDraggedY
                let bot = last.position.y + gameArea.size.height - (last.size.height/2) + amountDraggedY
                if((bot < gameArea.size.height && top > 0)){
                    for stage in stageImgs{
                        for task in stage{
                            if let t = task as? StageImg{
                                t.move(x: 0, y: amountDraggedY)
                            }
                            if let t = task as? StageDiv{
                                t.move(x: 0, y: amountDraggedY)
                            }
                        }
                    }
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
            
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            //SELECTING ITEMS IN ITEMS MENU
            if itemMenuIsOpen {
                for part:Part in list{
                    if part.contains(pointOfTouch){
                        if let obj = part as? Cockpit{
                            let a = Cockpit(type: obj.getType())
                            add(a: a)
                        }else if let obj = part as? Engine{
                            let a = Engine(type: obj.getType())
                            add(a: a)
                            addStage(part: a)
                        }else if let obj = part as? Decoupler{
                            let a = Decoupler(type: obj.getType())
                            add(a: a)
                            addStage(part: a)
                        }
                        closeItemsMenu()
                        break
                    }
                }
            }
            
            //DELETING ITEMS
            if(delButEnlarged){
                scale(button: deleteTab, amount: deleteTabScale, duration: 0.1)
                for part:Part in selected{
                    if part == root{
                        root = nil
                    }
                    removeStage(part: part)
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
                        let newRocket = Rocket(root: main, stage: getStages(main: main))
                        newRocket.connectParts()
                        gvc.displayAlertAction(rocket: newRocket)
                    }
                }
                if(cancelBut.contains(pointOfTouch)){
                    closeSaveMenu()
                }
            }
            
            //DESELECTING ITEMS
            if(!itemMenuIsOpen && !stageMenuIsOpen && !saveMenuIsOpen && !selected.isEmpty){
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
            
            if(stageMenuIsOpen && selectedStage != nil){
                let s = selectedStage!
                
                if newStage != nil{
                    
                    newStage?.colorBlendFactor = 0.0
                    
                    removeTask(task: s)
                    removeEmpty(idx: s.getIndex()+1)
                    
                    if let n = newStage as? StageImg{
                        let i = n.getIndex() + 1
                        let x = stageImgs[i].count - 2
                        stageImgs[i].insert(s, at: x)
                        updateIndex(from: n.getIndex())
                    }
                    
                    if let n = newStage as? StageDiv{
                        addStage(s: s, at: n.getIndex()+1)
                    }
                    
                    
                    rebuildStage(offset: 200)
                }else{
                    s.returnPos()
                }
                selectedStage?.getPart().colorBlendFactor = 0
                selectedStage = nil
                
            }
            
            break
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
        
        for stage in stageImgs{
            for task in stage{
                if let s = task as? StageImg{
                    s.update()
                }
                if let s = task as? StageDiv{
                    s.update()
                }
            }
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
            list.append(cockpit)
            self.addChild(cockpit)
        }
        
        //Engines
        for i in 1...1{
            let engine = Engine(type: i)
            counter += 1
            yDistribution = engine.size.height/2 + 50
            engine.position = CGPoint(x: x, y: gameArea.size.height - (yDistribution * CGFloat(counter)))
            engine.zPosition = 100
            engine.setScale(1)
            list.append(engine)
            self.addChild(engine)
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
    
    func openStageMenu(){
        stageMenuIsOpen = true
        let moveRight = SKAction.moveBy(x: 400, y: 0, duration: 0.2)
        itemsTab.run(moveRight)
        stagesBut.run(moveRight)
        for stage in stageImgs{
            for task in stage{
                task.run(moveRight)
            }
        }
    }
    
    func closeStageMenu(){
        stageMenuIsOpen = false
        let moveLeft = SKAction.moveBy(x: -400, y: 0, duration: 0.2)
        itemsTab.run(moveLeft)
        stagesBut.run(moveLeft)
        for stage in stageImgs{
            for task in stage{
                task.run(moveLeft)
            }
        }
    }
    
    func add(a:Part){
        if root == nil{
            root = a
        }
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
    
    func addStage(s:StageImg, at:Int){
        
        //create tempDiv
        let tempDiv = StageDiv(index: at)
        tempDiv.zPosition = 100
        tempDiv.setScale(1)
        self.addChild(tempDiv)
        
        //Update new stage
        s.moveStage(i: at)
        if at+1 < stageImgs.count{
            stageImgs.insert([s, tempDiv], at: at+1)
        }else{
            stageImgs.append([s, tempDiv])
        }
        
        updateIndex(from: at)
        
    }
    
    func addStage(part:Part){
        
        let x = gameArea.origin.x - 200
        let c = stageImgs.count - 1
        
        //Create new content
        let tempDiv = StageDiv(index: c)
        let tempPart = StageImg(index: c, part: part)
        stageImgs.append([tempPart, tempDiv])
        
        //Place tempPart
        tempPart.position = CGPoint(x: x, y: gameArea.size.height - (stageLength + tempPart.size.height/2))
        tempPart.zPosition = 100
        tempPart.setScale(1)
        stageLength += tempPart.size.height
        
        //Place tempDiv
        tempDiv.position = CGPoint(x: x, y: gameArea.size.height - (stageLength + tempDiv.size.height/2))
        tempDiv.zPosition = 100
        tempDiv.setScale(1)
        stageLength += tempDiv.size.height
        
        
        self.addChild(tempPart)
        self.addChild(tempDiv)
    }
    
    func rebuildStage(offset:Int){
        stageLength = 0
        for stage in stageImgs{
            for task in stage{
                task.position = CGPoint(x: gameArea.origin.x + CGFloat(offset), y: gameArea.size.height - (stageLength + task.size.height/2))
                stageLength += task.size.height
            }
        }
    }
    
    func removeStage(part:Part){
        for stage in stageImgs{
            for task in stage{
                let a = stage.firstIndex(of: task)
                let b = stageImgs.firstIndex(of: stage)
                if let t = task as? StageImg, t.getPart().equals(part:part){
                    t.removeFromParent()
                    stageImgs[b!].remove(at: a!)
                    //If there are no more tasks left in the stage delete the stage
                    if stageImgs[b!].count == 1{
                        stageImgs.remove(at: b!)
                    }
                }
                updateIndex(from: 0)
            }
        }
        
        rebuildStage(offset: -200)
    }
    
    func removeTask(task:StageImg){
        let index = stageImgs[task.getIndex()+1].firstIndex(of: task)!
        stageImgs[task.getIndex()+1].remove(at: index)
    }
    
    func removeEmpty(idx: Int){
        let stage = stageImgs[idx]
        if stage.count == 1{
            updateIndex(from: idx)
            stageImgs[idx][0].removeFromParent()
            stageImgs.remove(at: idx)
        }
        updateIndex(from: 0)
    }
    
    func updateIndex(from:Int){
        for i in from...stageImgs.count-1{
            for task in stageImgs[i]{
                if let t = task as? StageImg{
                    t.moveStage(i:i-1)
                }
                if let t = task as? StageDiv{
                    t.moveStage(i:i-1)
                }
            }
        }
    }
    
    func getStages(main:Part)->Stage{
        
        var currentStage:Stage? = nil
        var head:Stage? = nil
        
        for stage in stageImgs{
            var a:[Part] = []
            for task in stage{
                if let t = task as? StageImg { //, t.getPart().isConnected(part: main){
                    a.append(t.getPart())
                }
            }
            let temp = Stage(tasks: a)
            if(currentStage == nil){
                currentStage = temp
                head = temp
            }else{
                currentStage!.setNext(next: temp)
                currentStage = temp
            }
        }
        
        return head!
        
    }
    
    func toSavesMenu(){
        let changeSceneAction = SKAction.run {self.changeScene(scene: SavesScene(size: self.size, gvc: self.gvc), move: .right)}
        self.run(changeSceneAction)
    }
    
}

