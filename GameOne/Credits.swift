//
//  Credits.swift
//  GameOne
//
//  Created by Jusufin on 2/23/17.
//  Copyright © 2017 Jusufin. All rights reserved.
//

import SpriteKit

class Credits: SKScene
{
    override func didMove(to view: SKView)
    {
        //make random directions every 5 sec
        let wait = SKAction.wait(forDuration: 5)
        let run = SKAction.run{
            let scene = SKScene(fileNamed: "MenuS")
            
            scene?.scaleMode = .aspectFill
            
            // Present the scene
            self.view?.presentScene(scene!)
        }
        self.run(SKAction.sequence([wait, run]))
    }   
    
}
