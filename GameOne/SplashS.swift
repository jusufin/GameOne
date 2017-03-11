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
        //make random directions every 5 sec
        let wait = SKAction.wait(forDuration: 5)
        let run = SKAction.run{
            self.RandomDir()
        }
        self.run(SKAction.sequence([wait, run]))
    }
    
    func RandomDir()
    {
        let scene = SKScene(fileNamed: "MenuS")
        self.scene?.size = (self.view?.bounds.size)!
        
        // Present the scene
        self.view?.presentScene(scene!)
    }
}
