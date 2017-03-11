//
//  GameScene.swift
//  GameOne
//
//  Created by Jusufin on 2/2/17.
//  Copyright © 2017 Jusufin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    //collision
    let PlayerCategory  : UInt32 = 0x1 << 1
    let PickupCategory: UInt32 = 0x1 << 2
    let WallCategory: UInt32 = 0x1 << 3
    let EnemyCategory: UInt32 = 0x1 << 4
    
    
    //sprites and labels
    var sprite_Char: SKSpriteNode = SKSpriteNode()
    var pBar: SKSpriteNode = SKSpriteNode()
    var bBar: SKSpriteNode = SKSpriteNode()
    var startB: SKLabelNode = SKLabelNode()
    var restartB: SKLabelNode = SKLabelNode()
    var ScoreL: SKLabelNode = SKLabelNode()
    var ExitB: SKLabelNode = SKLabelNode()
    var t1: SKLabelNode = SKLabelNode()
    var t2: SKLabelNode = SKLabelNode()
    var t3: SKLabelNode = SKLabelNode()
    var PauseB: SKSpriteNode = SKSpriteNode()
    var backB: SKSpriteNode = SKSpriteNode()
    
    
    var body_array:[SKSpriteNode] = []
    var point_array:[CGPoint] = []
    var dir_array: [String] = []
    var rand_dir = 0
    
    //array that will hold textures
    var spriteArray = Array<SKTexture>();
    
    //sounds used in the game
    var sound = SKAction.playSoundFileNamed("z.wav", waitForCompletion: false)
    var sound2 = SKAction.playSoundFileNamed("m.wav", waitForCompletion: false)
    var sound3 = SKAction.playSoundFileNamed("G.mp3", waitForCompletion: false)
    
    //misc - timer/moving for sprite movement/looking for paused state/etc
    var lastInterval: CFTimeInterval?
    var moving: Bool = false
    var ifPaused: Bool = false
    var Score = 0
    var Dir = ""
    
    
    override func didMove(to view: SKView)
    {
        
        //get sprites / add collision / animate sprites
        if let nPlayer:SKSpriteNode = self.childNode(withName: "MainCR") as? SKSpriteNode
        {
            //collision detection
            sprite_Char = nPlayer
            sprite_Char.physicsBody?.categoryBitMask = PlayerCategory
            sprite_Char.physicsBody?.collisionBitMask = PickupCategory | WallCategory | EnemyCategory
            sprite_Char.physicsBody?.contactTestBitMask = WallCategory | EnemyCategory
            sprite_Char.isHidden = true
            
        }
        if let bgr:SKSpriteNode = self.childNode(withName: "Back") as? SKSpriteNode
        {
            backB = bgr
            
            //create border collison with frame of background instead of self.frame which used whole screen
            physicsWorld.contactDelegate = self
            let borderBody = SKPhysicsBody(edgeLoopFrom: backB.frame)
            self.physicsBody = borderBody
            self.physicsBody?.categoryBitMask = WallCategory
            backB.physicsBody?.contactTestBitMask = PlayerCategory
            backB.physicsBody?.collisionBitMask = WallCategory | EnemyCategory | PlayerCategory
        }
        if let nP:SKSpriteNode = self.childNode(withName: "Pick") as? SKSpriteNode
        {
            pBar = nP
            pBar.physicsBody?.categoryBitMask = PickupCategory
            pBar.physicsBody?.contactTestBitMask = PlayerCategory
            pBar.physicsBody?.collisionBitMask = PlayerCategory
            pBar.isHidden = true
            
            //add images to array
            spriteArray.append(SKTexture(imageNamed: "Pickup.png"));
            spriteArray.append(SKTexture(imageNamed: "Pickup2.png"));
            
            //create action from array and have sprite_Char run it
            let animateAction = SKAction.animate(with: self.spriteArray, timePerFrame: 0.50);
            let repeatAction = SKAction.repeatForever(animateAction);
            //self.pBar.run(repeatAction);
            self.pBar.run(repeatAction, withKey:"moving")
            
        }        
        if let sB:SKLabelNode = self.childNode(withName: "Start") as? SKLabelNode
        {
            startB = sB
        }
        if let eB:SKLabelNode = self.childNode(withName: "E") as? SKLabelNode
        {
            ExitB = eB
        }
        if let e1:SKLabelNode = self.childNode(withName: "1") as? SKLabelNode
        {
            t1 = e1
        }
        if let e2:SKLabelNode = self.childNode(withName: "2") as? SKLabelNode
        {
            t2 = e2
        }
        if let e3:SKLabelNode = self.childNode(withName: "3") as? SKLabelNode
        {
            t3 = e3
        }
        if let rB:SKLabelNode = self.childNode(withName: "Restart") as? SKLabelNode
        {
            restartB = rB
        }
        if let sB:SKLabelNode = self.childNode(withName: "Score") as? SKLabelNode
        {
            ScoreL = sB
        }
        if let pB:SKSpriteNode = self.childNode(withName: "Pause") as? SKSpriteNode
        {
            PauseB = pB
            PauseB.isHidden = true
        }
        
        //detect direction of swipes with gesture recognizer
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.hS(sender:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.hS(sender:)))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.hS(sender:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.hS(sender:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        upSwipe.direction = .up
        downSwipe.direction = .down
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        
    }
   
    //get direction of swipe and set data to the direction / will be used by MoveC method to determine player/body movement
    func hS(sender: UISwipeGestureRecognizer)
    {
        switch sender.direction
        {
        case UISwipeGestureRecognizerDirection.right:
            //print("Swiped right")
            Dir = "R"
            
        case UISwipeGestureRecognizerDirection.down:
            //print("Swiped down")
            Dir = "D"
            
        case UISwipeGestureRecognizerDirection.left:
            //print("Swiped left")
            Dir = "L"
            
        case UISwipeGestureRecognizerDirection.up:
            //print("Swiped up")
            Dir = "U"
            
        default:
            break
        }
    }
    
    //changed from random to player based
    func RandomDir(body : SKSpriteNode)
    {
      
        if let index = body.userData?.value(forKey: "num") as? Int
        {
            rand_dir = Int(arc4random_uniform(UInt32(3))) + 1
            
            let pos = sprite_Char.position
            
            let pos2 = body.position
            
            
            if ((pos.x - pos2.x) > 135 || (pos.x - pos2.x) < 135 || (pos.y - pos2.y) > 135 || (pos.y - pos2.y) < 135)
            {
                dir_array[index - 1] = Dir
            }
            else
            {
                switch rand_dir
                {
                    case 1:
                        dir_array[index] = "R"
                        
                    case 2:
                        dir_array[index] = "D"
                        
                    case 3:
                        dir_array[index] = "L"
                        
                    case 4:
                        dir_array[index] = "U"
                        
                    default:
                        break
                }
            }
        }
        
    }
    
    
    func randomNum(fNum: CGFloat, sNum: CGFloat) -> CGFloat
    {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(fNum - sNum) + min(fNum, sNum)
    }
    
    // when player collides with a wall, pickup, or border - this will run and give a gameover or a point depending on collision
    func didBegin(_ contact: SKPhysicsContact)
    {
        
        //pickup contact
        if (contact.bodyA.categoryBitMask == PlayerCategory) && (contact.bodyB.categoryBitMask == PickupCategory)
        {
            run(sound2)
            Score = Score + 1
            ScoreL.text = "Point: " + String(Score)
            pBar.isHidden = true
            pBar.physicsBody?.categoryBitMask = 0
            
            let spawn_loc_y = randomNum(fNum: -160, sNum: 120)
            let spawn_loc_x = randomNum(fNum: -300, sNum: 300)
            
            let action = SKAction.move(to: CGPoint(x: spawn_loc_x, y: spawn_loc_y), duration: 0)
            pBar.run(action)
            pBar.isHidden = false
            pBar.physicsBody?.categoryBitMask = PickupCategory
            
            // Create sprite
            switch Dir
            {
            case "R":
                //right
                
                //create sprite with collision
                let body = SKSpriteNode(imageNamed: "B.png")
                body.position = CGPoint(x: sprite_Char.position.x - 30, y: sprite_Char.position.y )
                body.size = CGSize(width: 15, height: 15)
                body.physicsBody = SKPhysicsBody(rectangleOf: body.size)
                body.physicsBody?.isDynamic = true
                body.physicsBody?.categoryBitMask = EnemyCategory
                body.physicsBody?.collisionBitMask = WallCategory | PlayerCategory
                body.physicsBody?.contactTestBitMask = PlayerCategory | WallCategory
                body.physicsBody?.affectedByGravity = false
                body.physicsBody?.allowsRotation = false
                let arrayC = body_array.count + 1
                body.userData = ["num": arrayC ]
                
                //check if body array and point array is empty
                if !(body_array.isEmpty)
                {
                    for (index, _) in body_array.enumerated()
                    {
                        //timer that creates random dir with range
                        let wait = SKAction.wait(forDuration: 2, withRange: 1)
                        let run = SKAction.run{
                            self.RandomDir(body: self.body_array[index])
                        }
                        self.run(SKAction.repeatForever(SKAction.sequence([wait, run])), withKey : "n")
                    }
                }
                
                // Add the sprite to the scene
                body.name = "B"
                addChild(body)
                
                dir_array.append("R")
                body_array.append(body)
                
            case "D":
                //down
                let body = SKSpriteNode(imageNamed: "B.png")
                
                body.position = CGPoint(x: sprite_Char.position.x , y: sprite_Char.position.y + 50)
                body.size = CGSize(width: 15, height: 15)
                body.physicsBody = SKPhysicsBody(rectangleOf: body.size)
                body.physicsBody?.isDynamic = true
                body.physicsBody?.categoryBitMask = EnemyCategory
                body.physicsBody?.collisionBitMask = WallCategory | PlayerCategory
                body.physicsBody?.contactTestBitMask = PlayerCategory | WallCategory
                body.physicsBody?.affectedByGravity = false
                body.physicsBody?.allowsRotation = false
                
                let arrayC = body_array.count + 1
                body.userData = ["num": arrayC ]
                
                //check if body array and point array is empty
                if !(body_array.isEmpty)
                {
                    for (index, _) in body_array.enumerated()
                    {
                        //timer that creates random dir with range
                        let wait = SKAction.wait(forDuration: 2, withRange: 1)
                        let run = SKAction.run{
                            self.RandomDir(body: self.body_array[index])
                        }
                        self.run(SKAction.repeatForever(SKAction.sequence([wait, run])), withKey : "n")
                    }
                }
                
                // Add the sprite to the scene
                addChild(body)
                body.name = "B"
                dir_array.append("D")
                body_array.append(body)
                
            case "L":
                //left
                let body = SKSpriteNode(imageNamed: "B.png")
                
                body.position = CGPoint(x: sprite_Char.position.x + 50, y: sprite_Char.position.y )
                body.size = CGSize(width: 15, height: 15)
                body.physicsBody = SKPhysicsBody(rectangleOf: body.size)
                body.physicsBody?.isDynamic = true
                body.physicsBody?.categoryBitMask = EnemyCategory
                body.physicsBody?.collisionBitMask = WallCategory | PlayerCategory
                body.physicsBody?.contactTestBitMask = PlayerCategory | WallCategory
                body.physicsBody?.affectedByGravity = false
                body.physicsBody?.allowsRotation = false
                
                let arrayC = body_array.count + 1
                body.userData = ["num": arrayC ]
                
                //check if body array and point array is empty
                if !(body_array.isEmpty)
                {
                    for (index, _) in body_array.enumerated()
                    {
                        //timer that creates random dir with range
                        let wait = SKAction.wait(forDuration: 3, withRange: 1)
                        let run = SKAction.run{
                            self.RandomDir(body: self.body_array[index])
                        }
                        self.run(SKAction.repeatForever(SKAction.sequence([wait, run])), withKey : "n")
                    }
                }
                
                // Add the sprite to the scene
                addChild(body)
                body.name = "B"
                dir_array.append("L")
                body_array.append(body)
                
            case "U":
                //up
                let body = SKSpriteNode(imageNamed: "B.png")
                
                body.position = CGPoint(x: sprite_Char.position.x, y: sprite_Char.position.y - 50)
                body.size = CGSize(width: 15, height: 15)
                body.physicsBody = SKPhysicsBody(rectangleOf: body.size)
                body.physicsBody?.isDynamic = true
                body.physicsBody?.categoryBitMask = EnemyCategory
                body.physicsBody?.collisionBitMask = WallCategory | PlayerCategory
                body.physicsBody?.contactTestBitMask = PlayerCategory | WallCategory
                body.physicsBody?.affectedByGravity = false
                body.physicsBody?.allowsRotation = false
                
                let arrayC = body_array.count + 1
                
                body.userData = ["num": arrayC ]
                
                //check if body array and point array is empty
                if !(body_array.isEmpty)
                {
                    for (index, _) in body_array.enumerated()
                    {
                        //timer that creates random dir with range
                        let wait = SKAction.wait(forDuration: 2, withRange: 1)
                        let run = SKAction.run{
                            self.RandomDir(body: self.body_array[index])
                        }
                        self.run(SKAction.repeatForever(SKAction.sequence([wait, run])), withKey : "n")
                    }
                }
                
                // Add the sprite to the scene
                addChild(body)
                body.name = "B"
                dir_array.append("U")
                body_array.append(body)
                
            default:
                break
            }
            
        }
        //game over for wall and border
        else if (contact.bodyA.categoryBitMask == WallCategory && contact.bodyB.categoryBitMask == PlayerCategory) || (contact.bodyB.categoryBitMask == WallCategory && contact.bodyA.categoryBitMask == PlayerCategory)
        {
            moving = false
            run(sound3)
            sprite_Char.isHidden = true
            restartB.isHidden = false
            pBar.isHidden = true
            ScoreL.isHidden = true
            PauseB.isHidden = true
            ExitB.isHidden = false
            
            if !(body_array.isEmpty)
            {
                for (_, _) in body_array.enumerated()
                {
                    removeChildren(in: body_array)
                }
            }
            
            
            
            self.removeAllActions()
            
            dir_array.removeAll()
            body_array.removeAll()
        }
        //game over for enemy
        else if (contact.bodyA.categoryBitMask == EnemyCategory && contact.bodyB.categoryBitMask == PlayerCategory) || (contact.bodyB.categoryBitMask == EnemyCategory && contact.bodyA.categoryBitMask == PlayerCategory)
        {
            moving = false
            run(sound3)
            sprite_Char.isHidden = true
            restartB.isHidden = false
            pBar.isHidden = true
            ScoreL.isHidden = true
            PauseB.isHidden = true
            ExitB.isHidden = false
            
            if !(body_array.isEmpty)
            {
                for (_, _) in body_array.enumerated()
                {
                    removeChildren(in: body_array)
                }
            }
            
            self.removeAllActions()
            
            dir_array.removeAll()
            body_array.removeAll()
        }
        
        
        if (contact.bodyA.categoryBitMask == EnemyCategory && contact.bodyB.categoryBitMask == WallCategory)
        {
            print("contact with wall")
            let body = contact.bodyA.node
            
            if let index = body?.userData?.value(forKey: "num") as? Int
            {
                switch dir_array[index - 1]
                {
                case "R":
                    //right
                    dir_array[index - 1] = "L"
                case "D":
                    //down
                    dir_array[index - 1] = "U"
                case "L":
                    //left
                    dir_array[index - 1] = "R"
                case "U":
                    //up
                    dir_array[index - 1] = "D"
                default:
                    break
                }
            }
            
        }
        if (contact.bodyB.categoryBitMask == EnemyCategory && contact.bodyA.categoryBitMask == WallCategory)
        {
            print("contact with wall")
            let body = contact.bodyB.node
            
            if let index = body?.userData?.value(forKey: "num") as? Int
            {
                switch dir_array[index - 1]
                {
                case "R":
                    //right
                    dir_array[index - 1] = "L"
                case "D":
                    //down
                    dir_array[index - 1] = "U"
                case "L":
                    //left
                    dir_array[index - 1] = "R"
                case "U":
                    //up
                    dir_array[index - 1] = "D"
                default:
                    break
                }
            }
        }
        
    }
    
    //detect if touching buttons using the sprite nodes name
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
                
        for touch in touches
        {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            /*
            // old method used for turning player
            if node.name == "F"
            {
                //Left
                run(sound)
                sprite_Char.run(SKAction.rotate(byAngle: CGFloat(-M_PI_2), duration: 0))
            }
            */
            
            //starts and restarts game
            if node.name == "Pause"
            {
                if ifPaused == false
                {
                    moving = false
                    ExitB.isHidden = false
                    
                    if let action = pBar.action(forKey: "moving")
                    {
                        action.speed = 0
                    }
                    //self.isPaused = true
                    ifPaused = true
                }
                else
                {
                    moving = true
                    ExitB.isHidden = true
                    
                    if let action = pBar.action(forKey: "moving")
                    {
                        action.speed = 1
                    }
                    //self.isPaused = false
                    ifPaused = false
                }
                //self.scene?.view?.paused = true
            }
            
            //starts and restarts game
            if node.name == "Start"
            {
                //start settings
                pBar.isHidden = false
                ScoreL.isHidden = false
                sprite_Char.isHidden = false
                startB.isHidden = true
                PauseB.isHidden = false
                t1.isHidden = true
                t2.isHidden = true
                t3.isHidden = true
                pBar.physicsBody?.categoryBitMask = PickupCategory
                run(sound)
                moving = true
                
            }
            if node.name == "Restart"
            {
                //restart setting
                pBar.isHidden = true
                sprite_Char.isHidden = true
                ScoreL.isHidden = true
                restartB.isHidden = true
                startB.isHidden = false
                PauseB.isHidden = true
                ExitB.isHidden = true
                t1.isHidden = false
                t2.isHidden = false
                t3.isHidden = false
                
                ifPaused = false
                run(sound)
                moving = false
                Score = 0
                ScoreL.text = "Point: 0"
                //sprite_Char.zRotation = 0
                let action = SKAction.move(to: CGPoint(x: 0, y: 0),duration: 0)
                sprite_Char.run(action)
                
            }
            if node.name == "E"
            {
                let wait = SKAction.wait(forDuration: 0)
                let run2 = SKAction.run
                    {
                        let scene = SKScene(fileNamed: "MenuS")
                        scene?.scaleMode = .aspectFill
                        // Present the scene
                        self.view?.presentScene(scene!)
                    }
                self.run(SKAction.sequence([wait, run2]))
            }
        }
    }
    
    //called to move player
    func MoveC(byTimeDelta timeDelta: TimeInterval)
    {
        
        
        //time * speed
        let distanceToTravel = CGFloat(timeDelta) * CGFloat(50)
        
        //check if body array and point array is empty
        if !(body_array.isEmpty)
        {
            for (index, element) in body_array.enumerated()
            {
                switch dir_array[index]
                {
                    case "R":
                        //right
                        let action = SKAction.move(to: CGPoint(x: distanceToTravel * cos(0) + element.position.x, y: distanceToTravel * sin(0) +    element.position.y), duration: 0)
                        element.run(action)
                    case "D":
                        //down
                        let action = SKAction.move(to: CGPoint(x: distanceToTravel * cos(4.71239) + element.position.x, y: distanceToTravel * sin(4.71239) + element.position.y), duration: 0)
                        element.run(action)
                    case "L":
                        //left
                        let action = SKAction.move(to: CGPoint(x: distanceToTravel * cos(3.14159) + element.position.x, y: distanceToTravel * sin(3.14159) + element.position.y), duration: 0)
                        element.run(action)
                    case "U":
                        //up
                        let action = SKAction.move(to: CGPoint(x: distanceToTravel * cos(1.5708) + element.position.x, y: distanceToTravel * sin(1.5708) + element.position.y), duration: 0)
                        element.run(action)
                    default:
                        break
                }
            }
        }
        
        switch Dir
        {
            case "R":
                //right
                let action = SKAction.move(to: CGPoint(x: distanceToTravel * cos(0) + sprite_Char.position.x, y: distanceToTravel * sin(0) + sprite_Char.position.y),      duration: 0)
                sprite_Char.run(action)
            case "D":
                //down
                let action = SKAction.move(to: CGPoint(x: distanceToTravel * cos(4.71239) + sprite_Char.position.x, y: distanceToTravel * sin(4.71239) + sprite_Char.position.y),      duration: 0)
                sprite_Char.run(action)
            case "L":
                //left
                let action = SKAction.move(to: CGPoint(x: distanceToTravel * cos(3.14159) + sprite_Char.position.x, y: distanceToTravel * sin(3.14159) + sprite_Char.position.y),      duration: 0)
                sprite_Char.run(action)
            case "U":
                //up
                let action = SKAction.move(to: CGPoint(x: distanceToTravel * cos(1.5708) + sprite_Char.position.x, y: distanceToTravel * sin(1.5708) + sprite_Char.position.y),      duration: 0)
                sprite_Char.run(action)
            default:
                //up
                let action = SKAction.move(to: CGPoint(x: distanceToTravel * cos(1.5708) + sprite_Char.position.x, y: distanceToTravel * sin(1.5708) + sprite_Char.position.y),      duration: 0)
                sprite_Char.run(action)
                break
        }
    }
  
    
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered
        if lastInterval == nil
        {
            lastInterval = currentTime
        }
        
        //time between interval
        let delta: CFTimeInterval = currentTime - lastInterval!
        
        if (moving)
        {
            MoveC(byTimeDelta: delta)
        }
        
        lastInterval = currentTime
    }
}
