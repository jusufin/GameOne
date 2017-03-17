//
//  MenuS.swift
//  GameOne
//
//  Created by Jusufin on 2/23/17.
//  Copyright © 2017 Jusufin. All rights reserved.
//

import SpriteKit

class MenuS: SKScene
{
    
    var startB: SKLabelNode = SKLabelNode()
    var creditB: SKLabelNode = SKLabelNode()
    
    override func didMove(to view: SKView)
    {
        if let sgr:SKLabelNode = self.childNode(withName: "S") as? SKLabelNode
        {
            startB = sgr
        }
        if let cgr:SKLabelNode = self.childNode(withName: "C") as? SKLabelNode
        {
            creditB = cgr
        }
    }
    
    //detect if touching buttons using the sprite nodes name
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        for touch in touches
        {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            
            if node.name == "S"
            {
                let wait = SKAction.wait(forDuration: 0)
                let run = SKAction.run{
                    
                    let scene = SKScene(fileNamed: "GameScene")
                    
                    scene?.scaleMode = .aspectFill
                    
                    // Present the scene
                    self.view?.presentScene(scene!)
                    
                }
                self.run(SKAction.sequence([wait, run]))
            }
            if node.name == "L"
            {
                let wait = SKAction.wait(forDuration: 0)
                let run = SKAction.run{
                    
                    let scene = SKScene(fileNamed: "LeaderB")
                    
                    scene?.scaleMode = .aspectFill
                    
                    // Present the scene
                    self.view?.presentScene(scene!)
                    
                }
                self.run(SKAction.sequence([wait, run]))
            }
            if node.name == "C"
            {
                //make random directions every 5 sec
                let wait = SKAction.wait(forDuration: 0)
                let run = SKAction.run{
                    let scene = SKScene(fileNamed: "Credits")
                    
                    scene?.scaleMode = .aspectFill
                    
                    // Present the scene
                    self.view?.presentScene(scene!)
                }
                self.run(SKAction.sequence([wait, run]))
            }
        }
    }

}
