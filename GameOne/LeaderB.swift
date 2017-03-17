//
//  LeaderB.swift
//  GameOne
//
//  Created by Jusufin on 3/16/17.
//  Copyright © 2017 Jusufin. All rights reserved.
//

import SpriteKit
import Social

class LeaderB: SKScene, UITableViewDataSource, UITableViewDelegate
{
    var LeaderTable:UITableView?
    var TableData = [String]()
    var UserN: String?
    var TweetL: SKLabelNode = SKLabelNode()
    var Score = 0
    
    override func didMove(to view: SKView)
    {
        //check for session Id and if exists then continue on - otherwise go to login
        let defaults = UserDefaults.standard
        let NameOfUser = defaults.string(forKey: "name")
        
        if let sD:SKLabelNode = self.childNode(withName: "T") as? SKLabelNode
        {
            TweetL = sD
        }
        
        if NameOfUser != nil
        {
            UserN = NameOfUser
            HighS(NameU: UserN!)
        }
        else
        {
            print("id nil")
        }
        
        //get score and create table
        getSC()
        self.LeaderTable = UITableView()
        LeaderTable?.frame = CGRect(x: view.frame.midX - 200, y: view.frame.midY - 100, width: 400, height: 200)
        self.LeaderTable?.dataSource = self
        self.LeaderTable?.delegate = self
        LeaderTable?.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        self.view!.addSubview(LeaderTable!)
    }
    
    //get scores based on date range
    func getSC()
    {
        let gameName = "GameOne"
        let startDate = NSDate(timeIntervalSinceNow: -168*60*60*2)
        let endDate = NSDate()
        App42API.initialize(withAPIKey: "1ef91372d294afd33ed12095e845d20a6fd9e41be1f920f1bf7952916dace0c9", andSecretKey: "f5df9415ca972351535cab425a3aedc488799b990437efd061fc764b6fddd785")
        
        let scoreBoardService = App42API.buildScoreBoardService() as? ScoreBoardService
        
        scoreBoardService?.getTopRankings(gameName, start:startDate as Date!, end:endDate as Date!, completionBlock: { (success, response, exception) -> Void in
            if(success)
            {
                let game = response as! Game
                NSLog("gameName is %@", game.name)
               
                let scoreList = game.scoreList
                
                for score in scoreList!
                {
                    //print("\((score as AnyObject).userName)") 
                    //print("Value is = \(scoreValue)")
                    let scoreValue = (score as AnyObject).value as Double
                    let name = (score as AnyObject).userName as String
                    //print(name)
                    //print(Int(scoreValue))
                    let value = "NAME: \(name)   SCORE: \(Int(scoreValue))"
                    self.TableData.append(value)
                }                
                print(self.TableData)
                self.LeaderTable?.reloadData()
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
    
    //detect if touching buttons using the sprite nodes name
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        for touch in touches
        {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            
            if node.name == "B"
            {
                let scene = SKScene(fileNamed: "MenuS")
                self.scene?.size = (self.view?.bounds.size)!
                
                // Present the scene
                self.view?.presentScene(scene!)
            }
            if node.name == "T"
            {
                showTweet()
            }
        }
    }
    
    override func willMove(from view: SKView)
    {
        LeaderTable?.removeFromSuperview()
        TableData.removeAll()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return TableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = self.TableData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("User selected table row \(indexPath.row) and item \(TableData[indexPath.row])")
    }
    
    func HighS(NameU: String)
    {
        let gameName = "GameOne"
        let userName = NameU
        
        App42API.initialize(withAPIKey: "1ef91372d294afd33ed12095e845d20a6fd9e41be1f920f1bf7952916dace0c9", andSecretKey: "f5df9415ca972351535cab425a3aedc488799b990437efd061fc764b6fddd785")
        
        
        let scoreBoardService = App42API.buildScoreBoardService() as? ScoreBoardService
        scoreBoardService?.getHighestScore(byUser: gameName, gameUserName:userName, completionBlock: { (success, response, exception) -> Void in
            if(success)
            {
                let game = response as! Game
                NSLog("gameName is %@", game.name)
                
                let scoreList = game.scoreList
                
                for score in scoreList!
                {
                    let scoreValue = (score as AnyObject).value as Double
                    self.Score = Int(scoreValue)
                    self.TweetL.isHidden = false
                }
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
    
    //show highscore
    func showTweet()
    {
        let tweet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        tweet?.completionHandler =
            {
                result in
                switch result
                {
                case SLComposeViewControllerResult.cancelled:
                    break
                case SLComposeViewControllerResult.done:
                    self.TweetL.isHidden = true
                    break
                }
        }
        
        tweet?.setInitialText("\(UserN!)'s high score is \(Score) points in Brick Collect!") //The default text in the tweet
        self.view?.window?.rootViewController!.present(tweet!, animated: false, completion:{
            //Optional completion statement
        })
    }
    
}
