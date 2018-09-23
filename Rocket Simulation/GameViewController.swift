//
//  GameViewController.swift
//  Rocket Man
//
//  Created by Sam Bunger on 1/28/18.
//  Copyright © 2018 Samster. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit
import GameplayKit

class GameViewController: UIViewController {
    
    var usrTextField = UITextField()
    var rocket:Rocket = Rocket()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: CGSize(width: 1536, height: 2048), gvc: self)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    var filePath:String{
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("Data").path
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func displayAlertAction(rocket:Rocket){
        
        self.rocket = rocket
        
        let alertController = UIAlertController(title: "Enter Ship Name", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: usrTextField)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: self.okHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    func usrTextField(textField:UITextField){
        usrTextField = textField
        usrTextField.placeholder = "name"
    }
    
    func okHandler(alert: UIAlertAction){
        
        rocket.setName(name: usrTextField.text!)
        let num = defaults.integer(forKey: DefaultKeys.saveNum)
        print("\(filePath)\(num)")
        let success = NSKeyedArchiver.archiveRootObject(rocket, toFile: "\(self.filePath)\(num)")
        print(success ? "Successful save of \(rocket.getName())" : "Save Failed")
        defaults.set((num+1), forKey: DefaultKeys.saveNum)
        print(defaults.integer(forKey: DefaultKeys.saveNum))
        
    }
    
}

public struct DefaultKeys{
    static let saveNum = "numOfSaves"
}











