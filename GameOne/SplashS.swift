//
//  SplashS.swift
//  GameOne
//
//  Created by Jusufin on 2/23/17.
//  Copyright © 2017 Jusufin. All rights reserved.
//

import SpriteKit

class SplashS: SKScene
{
    override func didMove(to view: SKView)
    {
        //check for session Id and if exists then continue on - otherwise go to login
        let defaults = UserDefaults.standard
        let id = defaults.string(forKey: "id")
        
        if id != nil
        {
            print(id!)
            let wait = SKAction.wait(forDuration: 5)
            let run = SKAction.run{
                self.ChangeDir()
            }
            self.run(SKAction.sequence([wait, run]))
        }
        else
        {
            //login/create user if no data exists
            let wait = SKAction.wait(forDuration: 5)
            let run = SKAction.run{
                self.RandomDir()
            }
            self.run(SKAction.sequence([wait, run]))
        }
    }
    
    func RandomDir()
    {
        let scene = SKScene(fileNamed: "CreateUser")
        self.scene?.size = (self.view?.bounds.size)!
        
        // Present the scene
        self.view?.presentScene(scene!)
    }
    func ChangeDir()
    {
        let scene = SKScene(fileNamed: "MenuS")
        self.scene?.size = (self.view?.bounds.size)!
        
        // Present the scene
        self.view?.presentScene(scene!)
    }

}
