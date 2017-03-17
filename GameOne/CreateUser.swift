//
//  CreateUser.swift
//  GameOne
//
//  Created by Jusufin on 3/16/17.
//  Copyright © 2017 Jusufin. All rights reserved.
//

import SpriteKit

class CreateUser: SKScene
{
    var TextInput:UITextField?
    var TextInput2:UITextField?
    var TextInput3:UITextField?
    let myLabel = SKLabelNode(fontNamed:"Helvetica Neue Light")
    let myLabel2 = SKLabelNode(fontNamed:"Helvetica Neue Light")
    let myLabelN = SKLabelNode(fontNamed:"Helvetica Neue Light")
    let myLabelP = SKLabelNode(fontNamed:"Helvetica Neue Light")
    let myLabelE = SKLabelNode(fontNamed:"Helvetica Neue Light")
    let CreateU = SKLabelNode(fontNamed:"Helvetica Neue Light")
    let LogU = SKLabelNode(fontNamed:"Helvetica Neue Light")
    
    
    override func didMove(to view: SKView)
    {
        
        //labels
        myLabel.text = "CREATE A USER"
        myLabel.fontSize = 40
        myLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 160)
        self.addChild(myLabel)
        
        myLabel2.text = "or login with User Name And Pass"
        myLabel2.fontSize = 20
        myLabel2.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 140)
        self.addChild(myLabel2)
        
        myLabelN.text = "USER NAME"
        myLabelN.fontSize = 20
        myLabelN.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 70)
        self.addChild(myLabelN)
        
        
        myLabelP.text = "PASSWORD"
        myLabelP.fontSize = 20
        myLabelP.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 30)
        self.addChild(myLabelP)
        
       
        myLabelE.text = "Email"
        myLabelE.fontSize = 20
        myLabelE.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 10)
        self.addChild(myLabelE)
        
        CreateU.name = "C"
        CreateU.text = "CREATE"
        CreateU.fontSize = 20
        CreateU.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        self.addChild(CreateU)
        
        LogU.name = "L"
        LogU.text = "LOG IN"
        LogU.fontSize = 20
        LogU.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 140)
        self.addChild(LogU)
        
        
        //init textfields
        self.TextInput = UITextField()
        TextInput?.frame = CGRect(x: view.frame.midX - 100, y: view.frame.midY - 70, width: 200, height: 20)
        self.view!.addSubview(TextInput!)
        TextInput?.backgroundColor = UIColor.white
        
        self.TextInput2 = UITextField()
        TextInput2?.frame = CGRect(x: view.frame.midX - 100, y: view.frame.midY - 30, width: 200, height: 20)
        self.view!.addSubview(TextInput2!)
        TextInput2?.backgroundColor = UIColor.white
        
        self.TextInput3 = UITextField()
        TextInput3?.frame = CGRect(x: view.frame.midX - 100, y: view.frame.midY + 10, width: 200, height: 20)
        self.view!.addSubview(TextInput3!)
        TextInput3?.backgroundColor = UIColor.white
        
    }
    
    //detect if touching buttons using the sprite nodes name
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        for touch in touches
        {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            
            if node.name == "C"
            {
                if TextInput?.text != "" && TextInput2?.text != "" && TextInput3?.text != ""
                {
                    CreateUserF(NAME: (TextInput?.text)!, PASS: (TextInput2?.text)!, EMAIL: (TextInput3?.text)!)
                }
            }
            if node.name == "L"
            {
                if TextInput?.text != "" && TextInput2?.text != ""
                {
                    LogIn(NAME: (TextInput?.text)!, PASS: (TextInput2?.text)!)
                }
            }
        }
    }
    
    
    //create a user
    func CreateUserF(NAME : String, PASS : String, EMAIL : String)
    {
        let userName = NAME
        let pwd = PASS
        let emailId = EMAIL
        App42API.initialize(withAPIKey: "1ef91372d294afd33ed12095e845d20a6fd9e41be1f920f1bf7952916dace0c9", andSecretKey: "f5df9415ca972351535cab425a3aedc488799b990437efd061fc764b6fddd785")
        
        
        let userService = App42API.buildUserService() as? UserService
        
        
        userService?.createUser(userName, password: pwd, emailAddress:emailId, completionBlock: { (success, response, exception) -> Void in
            if(success)
            {
                let user = response as! User
                NSLog("%@", user.userName)
                NSLog("%@", user.email)
                NSLog("%@", user.sessionId)
                let defaults = UserDefaults.standard
                defaults.set(user.sessionId, forKey: "id")
                defaults.set(user.userName, forKey: "name")
                
                let scene = SKScene(fileNamed: "MenuS")
                self.scene?.size = (self.view?.bounds.size)!
                
                // Present the scene
                self.view?.presentScene(scene!)
            }
            else
            {
                print(exception?.reason ?? String.self)
                print(exception?.appErrorCode ?? String.self)
                print(exception?.httpErrorCode ?? String.self)
                print(exception?.userInfo! ?? String.self)
            }  
        })
    }
    
    //auth user
    func LogIn(NAME : String, PASS : String)
    {
        let userName = NAME
        let pwd = PASS
        App42API.initialize(withAPIKey: "1ef91372d294afd33ed12095e845d20a6fd9e41be1f920f1bf7952916dace0c9", andSecretKey: "f5df9415ca972351535cab425a3aedc488799b990437efd061fc764b6fddd785")
        
        
        let userService = App42API.buildUserService() as? UserService
        
        
        userService?.authenticateUser(userName, password:pwd, completionBlock: { (success, response, exception) -> Void in
            if(success)
            {
                let user = response as! User
                NSLog("%@", user.userName)
                NSLog("%@", user.email)
                NSLog("%@", user.sessionId)
                //save session to userdefault
                let defaults = UserDefaults.standard
                defaults.set(user.sessionId, forKey: "id")
                defaults.set(user.userName, forKey: "name")
                
                let scene = SKScene(fileNamed: "MenuS")
                self.scene?.size = (self.view?.bounds.size)!
                
                // Present the scene
                self.view?.presentScene(scene!)
            }
            else
            {
                print(exception?.reason ?? String.self)
                print(exception?.appErrorCode ?? String.self)
                print(exception?.httpErrorCode ?? String.self)
                print(exception?.userInfo! ?? String.self)
            }  
        })
    }
    
    
    
    
    //remove from view
    override func willMove(from view: SKView)
    {
        TextInput?.removeFromSuperview()
        TextInput2?.removeFromSuperview()
        TextInput3?.removeFromSuperview()
    }
    
    //move to new scene
    func ChangeScene()
    {
        let scene = SKScene(fileNamed: "MenuS")
        self.scene?.size = (self.view?.bounds.size)!
        
        // Present the scene
        self.view?.presentScene(scene!)
    }
}
