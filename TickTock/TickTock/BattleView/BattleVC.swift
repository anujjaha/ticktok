//
//  BattleVC.swift
//  TickTock
//
//  Created by Kevin on 26/03/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class BattleVC: UIViewController
{
    @IBOutlet weak var vwJoinBattle : UIView!
    @IBOutlet weak var vwBattleList : UIView!
    @IBOutlet weak var tblBattleBoard : UITableView!
    @IBOutlet weak var vwBattleGame : UIView!
    
    @IBOutlet weak var lblBattleNO : UILabel!
    @IBOutlet weak var lblPrizeNO : UILabel!

    @IBOutlet weak var vwBattleGame1 : UIView!
    @IBOutlet weak var vwBattleGame2 : UIView!
    @IBOutlet weak var vwBattleGame3 : UIView!
    @IBOutlet weak var vwBattleGame4 : UIView!
    
    @IBOutlet weak var txtGameClock: UITextField!
    @IBOutlet weak var txtDoomdsDayClock: UITextField!
    
    @IBOutlet weak var txtBattleClock: UITextField!
    
    var arrBattelList = NSMutableArray()
    var arrAdvanceBattleList = NSMutableArray()
    var dictBattleList = NSMutableDictionary()

    var dictgameInfo = NSDictionary()
    var dictjackpotInfo = NSDictionary()
    var dictlevelInfo = NSDictionary()
    var dictmyInfo = NSDictionary()
    var arrPlayers = NSMutableArray()
    
    @IBOutlet weak var lblPlayer1Name: UILabel!
    @IBOutlet weak var lblPlayer1Bids: UILabel!
    @IBOutlet weak var lblPlayer2Name: UILabel!
    @IBOutlet weak var lblPlayer2Bids: UILabel!
    @IBOutlet weak var lblPlayer3Name: UILabel!
    @IBOutlet weak var lblPlayer3Bids: UILabel!
    @IBOutlet weak var lblPlayer4Name: UILabel!
    @IBOutlet weak var lblPlayer4Bids: UILabel!
    
    @IBOutlet weak var lblMyBids: UILabel!
    @IBOutlet weak var lblLongestBid: UILabel!
    @IBOutlet weak var lblCurrentBid: UILabel!
    @IBOutlet weak var lblCurrentBidLength: UILabel!
    @IBOutlet weak var txtJackpotAmount: UITextField!
    
    @IBOutlet weak var btnBid : UIButton!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var vwTimer : UIView!
    @IBOutlet weak var lbltimerSeconds: UILabel!
    var iBattleLevelType = Int()
    
    @IBOutlet weak var btnQuiteBattle : UIButton!
    @IBOutlet weak var CTheightofQuitBtn : NSLayoutConstraint!
    @IBOutlet weak var lblNoJakpotFound: UILabel!


    
    //New Enhancement
    var strjackpotUniqueId = String()
    var strlevelUniqueId = String()
    var strgameUniqueId = String()
    
    @IBOutlet weak var lblBattleRequired: UILabel!
    @IBOutlet weak var CTheightoflblBattleRequired : NSLayoutConstraint!
    var iwinsToUnlockNextLevel = NSNumber()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        vwBattleList.isHidden = true
        vwBattleGame.isHidden = true
        vwJoinBattle.layer.cornerRadius = 5.0
        lblNoJakpotFound.isHidden = true
        // Do any additional setup after loading the view.
        
        lblBattleRequired.isHidden = true
        CTheightoflblBattleRequired.constant = 0
        
        CTheightofQuitBtn.constant = 0
        btnQuiteBattle.isHidden = true
        
        self.tblBattleBoard.estimatedRowHeight = 65.0
        self.tblBattleBoard.rowHeight = UITableViewAutomaticDimension
        
        self.vwBattleGame1.layer.borderWidth = 1.0
        self.vwBattleGame1.layer.borderColor = UIColor.black.cgColor

        self.vwBattleGame2.layer.borderWidth = 1.0
        self.vwBattleGame2.layer.borderColor = UIColor.black.cgColor
 
        self.vwBattleGame3.layer.borderWidth = 1.0
        self.vwBattleGame3.layer.borderColor = UIColor.black.cgColor
        
        self.vwBattleGame4.layer.borderWidth = 1.0
        self.vwBattleGame4.layer.borderColor = UIColor.black.cgColor
        
        self.vwBattleGame1.isHidden = true
        self.vwBattleGame2.isHidden = true
        self.vwBattleGame3.isHidden = true
        self.vwBattleGame4.isHidden = true
        self.vwTimer.isHidden = true

        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        var underlineAttributedString = NSAttributedString(string: "Battle #21", attributes: underlineAttribute)
        lblBattleNO.attributedText = underlineAttributedString
        
        underlineAttributedString = NSAttributedString(string: "Prize: 50 Bids", attributes: underlineAttribute)
        lblPrizeNO.attributedText = underlineAttributedString
        
        //New Updation as per new Services
       // update_level_screen
        NotificationCenter.default.addObserver(self, selector: #selector(self.update_level_screen(_:)), name: NSNotification.Name(rawValue: "update_level_screen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.update_battle_screen(_:)), name: NSNotification.Name(rawValue: "update_battle_screen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.battle_game_quitted(_:)), name: NSNotification.Name(rawValue: "battle_quitted"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.show_error_popup(_:)), name: NSNotification.Name(rawValue: "show_error_popup"), object: nil)

        //Battel Screen
        NotificationCenter.default.addObserver(self, selector: #selector(self.response_place_normal_battle_level_bid(_:)), name: NSNotification.Name(rawValue: "response_place_normal_battle_level_bid"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.update_normal_battle_level_player_list(_:)), name: NSNotification.Name(rawValue: "update_normal_battle_level_player_list"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.normal_battle_main_jackpot_finished(_:)), name: NSNotification.Name(rawValue: "normal_battle_main_jackpot_finished"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.jackpot_doomsday_over(_:)), name: NSNotification.Name(rawValue: "jackpot_doomsday_over"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.battleScreenHeader(_:)), name: NSNotification.Name(rawValue: "battleScreenHeader"), object: nil)

        btnBack.isHidden = true
    }
    
    //MARK: Update_level_screen
    func update_level_screen(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            // print("response_battle:>\(data)")
            dictBattleList = NSMutableDictionary(dictionary: (data["levels"] as! NSDictionary))
            self.lblBattleRequired.isHidden = true
            self.CTheightoflblBattleRequired.constant = 0

            if  dictBattleList.count > 0
            {
                arrAdvanceBattleList = NSMutableArray(array: (dictBattleList["advance"] as! NSArray))
                arrBattelList = NSMutableArray(array: (dictBattleList["normal"] as! NSArray))
                
                if arrBattelList.count > 0 || arrAdvanceBattleList.count > 0
                {
                    lblNoJakpotFound.isHidden = true
                    tblBattleBoard.isHidden = false
                    

                    self.vwJoinBattle.isHidden = true
                    self.vwBattleGame.isHidden = true
                    self.vwBattleList.isHidden = false
                    
                    self.vwBattleGame1.isHidden = true
                    self.vwBattleGame2.isHidden = true
                    self.vwBattleGame3.isHidden = true
                    self.vwBattleGame4.isHidden = true

                    tblBattleBoard.reloadData()
                }
                else
                {
                    tblBattleBoard.isHidden = true
                    lblNoJakpotFound.isHidden = false
                    
                    if appDelegate.strGameJackpotID.characters.count == 0
                    {
                        lblNoJakpotFound.text = "No Associated Jackpot Found To Play Bid Battle"
                    }
                    else
                    {
                        lblNoJakpotFound.text = "The Jackpot you are playing in does not have any advance battle level associated to it"
                    }
                }
            }
            else
            {
                tblBattleBoard.isHidden = true
                lblNoJakpotFound.isHidden = false
                
                if appDelegate.strGameJackpotID.characters.count == 0
                {
                    lblNoJakpotFound.text = "No Associated Jackpot Found To Play Bid Battle"
                }
                else
                {
                    lblNoJakpotFound.text = "The Jackpot you are playing in does not have any advance battle level associated to it"
                }
            }
        }
        else
        {
            tblBattleBoard.isHidden = true
            lblNoJakpotFound.isHidden = false
            
            if appDelegate.strGameJackpotID.characters.count == 0
            {
                lblNoJakpotFound.text = "No Associated Jackpot Found To Play Bid Battle"
            }
            else
            {
                lblNoJakpotFound.text = "The Jackpot you are playing in does not have any advance battle level associated to it"
            }
        }
    }

    func update_battle_screen(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            if let strscenename = data["scene"] as? String
            {
                if(data.count > 0)
                {
                    if  strscenename == "game"
                    {
                        vwTimer.isHidden = true
                        vwBattleGame.isHidden = false
                        vwJoinBattle.isHidden = true
                        vwBattleList.isHidden = true
                        btnBack.isHidden = false
                        
                        //Jackpot Timer
                        /*
                         "jackpot_timer":{
                         "name":"First Jackpo",
                         "amount":"2,000",
                         "gameClock":"00:05:00",
                         "doomsdayClock":"00:00:30"
                         },
                         */
                        if let dictJackpotTimer = data["jackpot_timer"] as? NSDictionary
                        {
                            txtGameClock.text = "\(dictJackpotTimer["gameClock"]!)"
                            txtDoomdsDayClock.text = "\(dictJackpotTimer["doomsdayClock"]!)"
                            txtJackpotAmount.text = "$\(dictJackpotTimer.object(forKey: "amount")!)"

                            appDelegate.strGameClockTime  = txtGameClock.text!
                            appDelegate.strDoomdsDayClock = txtDoomdsDayClock.text!
                        }
                        
                        //Handle Timer
                        /*
                         "header":{
                         "jackpotUniqueId":"Gpj65X5itoG7n65TvxrY",
                         "levelUniqueId":"zvsVhpJYOLlwxQfOqwiG",
                         "gameUniqueId":"lPdEHPmLcPcuUlbBRsGF",
                         "levelName":"Level 1",
                         "prizeValue":10,
                         "prizeType":"BID",
                         "gameClock":"00:05:00"
                         },
                        */
                        if let dictheader = data["header"] as? NSDictionary
                        {
                            txtBattleClock.text = "\(dictheader["gameClock"]!)"
                            lblPrizeNO.text = "Prize: \(dictheader.object(forKey: "prizeValue")!) Bids"
                            lblBattleNO.text = "\(dictheader.object(forKey: "levelName")!)"
                            self.strjackpotUniqueId = "\(dictheader["jackpotUniqueId"]!)"
                            self.strlevelUniqueId = "\(dictheader["levelUniqueId"]!)"
                            self.strgameUniqueId = "\(dictheader["gameUniqueId"]!)"
                        }

                        
                        if(self.iBattleLevelType == 1)
                        {
                            self.lblBattleRequired.text = "Wins to Unlock \(self.lblBattleNO.text!): \(self.iwinsToUnlockNextLevel)"
                            self.lblBattleRequired.isHidden = false
                            self.CTheightoflblBattleRequired.constant = 21
                        }
                        else
                        {
                            self.lblBattleRequired.isHidden = true
                            self.CTheightoflblBattleRequired.constant = 0
                        }
                        //My Info
                        /*
                         "my_info":{
                         "bidBank":10
                         },
                         */
                        if let dictMyInfo = data["my_info"] as? NSDictionary
                        {
                            lblMyBids.text = "My Battle Bids: \(dictMyInfo.object(forKey: "bidBank")!)"
                        }
                        
                        if let arrplayers = data["players"] as? NSArray
                        {
                            arrPlayers = NSMutableArray(array: arrplayers)
                            let iKeyuserid = (appDelegate.arrLoginData[kkeyuser_id]!) as! Int
                            let namePredicate = NSPredicate(format: "%K = %@", "userId","\(iKeyuserid)")
                            let temparray = arrPlayers.filter { namePredicate.evaluate(with: $0) } as NSArray
                            if temparray.count > 0
                            {
                                arrPlayers.remove(temparray[0])
                            }
                            print("arrPlayers:>\(arrPlayers)")
                            
                            for iIndexofPlayer in 0..<arrPlayers.count
                            {
                                let dict = self.arrPlayers[iIndexofPlayer] as! NSDictionary
                                
                                switch iIndexofPlayer
                                {
                                case 0:
                                    self.vwBattleGame1.isHidden = false
                                    self.lblPlayer1Name.text = "\(dict["name"]!)"
                                    self.lblPlayer1Bids.text = "\(dict["remainingBids"]!) Bids"
                                    break
                                case 1:
                                    self.vwBattleGame2.isHidden = false
                                    self.lblPlayer2Name.text = "\(dict["name"]!)"
                                    self.lblPlayer2Bids.text = "\(dict["remainingBids"]!) Bids"
                                    break
                                case 2:
                                    self.vwBattleGame3.isHidden = false
                                    self.lblPlayer3Name.text = "\(dict["name"]!)"
                                    self.lblPlayer3Bids.text = "\(dict["remainingBids"]!) Bids"
                                    break
                                case 3:
                                    self.vwBattleGame4.isHidden = false
                                    self.lblPlayer4Name.text = "\(dict["name"]!)"
                                    self.lblPlayer4Bids.text = "\(dict["remainingBids"]!) Bids"
                                    break
                                default:
                                    break
                                }
                            }
                        }

                        //Handle Battle Timer
                        if let dictbids = data["bids"] as? NSDictionary
                        {
                            /*
                             "bids":{
                             "currentBidDuration":null,
                             "currentBidUser":null,
                             "longestBidDuration":null,
                             "longestBidUser":null
                             },
                             */
                            if let latestValue = dictbids["longestBidUser"] as? String
                            {
                                lblLongestBid.text = "Longest Bid: \(latestValue)  \(dictbids["longestBidDuration"]!)"
                            }
                            else
                            {
                                if let longestBidDuration = dictbids["longestBidDuration"] as? String
                                {
                                    lblLongestBid.text = "Longest Bid: \(longestBidDuration)"
                                }
                                else
                                {
                                    lblLongestBid.text = "Longest Bid: "
                                }
                            }
                            
                            if let currentBidDuration = dictbids["currentBidDuration"] as? String
                            {
                                lblCurrentBidLength.text = "Current Bid Length: \(currentBidDuration)"
                            }
                            else
                            {
                                lblCurrentBidLength.text = "Current Bid Length: "
                            }
                            
                            if let latestValue = dictbids["currentBidUser"] as? String
                            {
                                lblCurrentBid.text = "Current Bid: \(latestValue)"
                            }
                            else
                            {
                                lblCurrentBid.text = "Current Bid: "
                            }
                        }
                        
                        //Footer 
                        if let dictfooter = data["footer"] as? NSDictionary
                        {
                            /*
                             "footer":{
                             "showBidButton":true,
                             "showQuitButton":true
                             }                           
                             */
                            if(dictfooter["showBidButton"] as!  NSNumber == 1)
                            {
                                btnBid.backgroundColor = UIColor.black
                                btnBid.isEnabled = true
                            }
                            else
                            {
                                btnBid.isEnabled = false
                                btnBid.backgroundColor = UIColor.darkGray
                            }
                            
                            if(dictfooter["showQuitButton"] as!  NSNumber == 1)
                            {
                                btnQuiteBattle.isHidden = false
                                CTheightofQuitBtn.constant = 40
                            }
                            else
                            {
                                btnQuiteBattle.isHidden = true
                                CTheightofQuitBtn.constant = 0
                            }
                        }
                    }
                    else if strscenename == "countdown"
                    {
                        vwBattleList.isHidden = true
                        vwBattleGame.isHidden = true
                        vwJoinBattle.isHidden = true
                        vwTimer.isHidden = false
                        
                        lbltimerSeconds.text = "\(data["time"] as! Int)"
                    }
                    else if strscenename == "winner"
                    {
                        /*
                         winner: {
                         
                         lastBidUser: 'ABC',
                         lastBidDuration: 02:22:11,
                         longestBidUser: 'ABCDD',
                         longestBidDuration: 02:55:11,
                         bothAreSame: false
                         }

                            */
                        var strmessage = String()
                            if let dictTemp = data["data"] as? NSDictionary
                            {
                                if dictTemp["bothAreSame"] as! Bool == true
                                {
                                    if let dictlastBidWinner = dictTemp["lastBidWinner"] as? NSDictionary
                                    {
                                        strmessage = "Battle Won info:\nLastBidWinner: \((dictlastBidWinner["name"]!))\nLongestBidWinner: \((dictlastBidWinner["name"]!))"
                                    }
                                }
                                else
                                {
                                    var strlastBidWinner = String()
                                    if let dictlastBidWinner = dictTemp["lastBidWinner"] as? NSDictionary
                                    {
                                        strlastBidWinner = "LastBidWinner: \((dictlastBidWinner["name"]!))"
                                    }
                                    if let dictlongestBidWinner = dictTemp["longestBidWinner"] as? NSDictionary
                                    {
                                        strmessage = "Battle Won info:\n\(strlastBidWinner)\nLongestBidWinner: \((dictlongestBidWinner["name"]!))"
                                    }
                                }
                            }
                            else
                            {
                                strmessage = "Battle Finished"
                            }
                    
                        let alertView = UIAlertController(title: Application_Name, message: strmessage, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default)
                        { (action) in
                            
                            self.vwJoinBattle.isHidden = true
                            self.vwBattleGame.isHidden = true
                            self.vwBattleList.isHidden = false
                            
                            self.vwBattleGame1.isHidden = true
                            self.vwBattleGame2.isHidden = true
                            self.vwBattleGame3.isHidden = true
                            self.vwBattleGame4.isHidden = true
                            self.btnBack.isHidden = true

                            let myJSON = [
                                "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
                                "jackpotUniqueId" : appDelegate.strGameJackpotID
                            ]
                            
                            SocketIOManager.sharedInstance.socket.emitWithAck("request_battle_levels",  myJSON).timingOut(after: 0) {data in
                            }
                        }
                        alertView.addAction(OKAction)
                        
                        self.present(alertView, animated: true, completion: nil)

                    }
                }
            }
        }
    }
    
    
    
    func response_place_normal_battle_level_bid(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            //print("response_place_normal_battle_level_bid:>\(data)")
            lblMyBids.text = "My Battle Bids: \(data["availableBids"]!)"
        }
    }

    
    //MARK: Update Battle
    func update_normal_battle_level_player_list(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
          //  print("response_place_normal_battle_level_bid:>\(data)")
            arrPlayers = NSMutableArray(array: (data["players"] as! NSArray))

            let iKeyuserid = (appDelegate.arrLoginData[kkeyuser_id]!) as! Int
            let namePredicate = NSPredicate(format: "%K = %d", "id",iKeyuserid)
            let temparray = arrPlayers.filter { namePredicate.evaluate(with: $0) } as NSArray
            if temparray.count > 0
            {
                arrPlayers.remove(temparray[0])
            }
            print("arrPlayers:>\(arrPlayers)")
            
            for iIndexofPlayer in 0..<arrPlayers.count
            {
                let dict = self.arrPlayers[iIndexofPlayer] as! NSDictionary
                
                switch iIndexofPlayer
                {
                case 0:
                    self.vwBattleGame1.isHidden = false
                    self.lblPlayer1Name.text = "\(dict["name"]!)"
                    self.lblPlayer1Bids.text = "\(dict["remainingBids"]!) Bids"
                    break
                case 1:
                    self.vwBattleGame2.isHidden = false
                    self.lblPlayer2Name.text = "\(dict["name"]!)"
                    self.lblPlayer2Bids.text = "\(dict["remainingBids"]!) Bids"
                    break
                case 2:
                    self.vwBattleGame3.isHidden = false
                    self.lblPlayer3Name.text = "\(dict["name"]!)"
                    self.lblPlayer3Bids.text = "\(dict["remainingBids"]!) Bids"
                    break
                case 3:
                    self.vwBattleGame4.isHidden = false
                    self.lblPlayer4Name.text = "\(dict["name"]!)"
                    self.lblPlayer4Bids.text = "\(dict["remainingBids"]!) Bids"
                    break
                default:
                    break
                }
            }
        }
    }

    

    func normal_battle_main_jackpot_finished(_ notification: Notification)
    {
        self.tabBarController?.selectedIndex = 0
    }
    
    //MARK: Hide or Show Battle Bid Button
    override func viewWillAppear(_ animated: Bool)
    {
        appDelegate.bisHomeScreen = false
        appDelegate.iScreenIndex = 2
        
        self.navigationController?.isNavigationBarHidden = true
        
        txtGameClock.text = appDelegate.strGameClockTime
        txtDoomdsDayClock.text = appDelegate.strDoomdsDayClock
        
        /*
            Doomsday Clock Expiration- when the Doomsday clock expired, the Battle page did not immediately refresh to eliminate Normal Battles.  I could still see them on the screen.  I did not try and play a Normal Battle, so I don’t know if it would let me, because I tested the Advanced Battles instead.  After I played the first Advanced Battle, the Battle Level Screen was refreshed to eliminate Normal Battles, but it was only after I played the Advanced Battle.
         */
        if appDelegate.bDoomsDayClockOver == true
        {
            if vwBattleList.isHidden == false
            {
                let myJSON = [
                    "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
                    "jackpotUniqueId" : appDelegate.strGameJackpotID
                ]
                SocketIOManager.sharedInstance.socket.emitWithAck("request_battle_levels",  myJSON).timingOut(after: 0) {data in
                }
            }
        }
    }

    //MARK: Battle Screen
    @IBAction func JoinBattleButtonPressed()
    {
        vwJoinBattle.isHidden = true
        vwBattleList.isHidden = false
        lblNoJakpotFound.isHidden = false
        tblBattleBoard.isHidden = true
        
        let myJSON = [
            "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
            "jackpotUniqueId" : appDelegate.strGameJackpotID
        ]
        
        SocketIOManager.sharedInstance.socket.emitWithAck("request_battle_levels",  myJSON).timingOut(after: 0) {data in
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Join Battle Level
    @IBAction func btnJoinPressed(sender: UIButton)
    {
        var dict = NSDictionary()
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblBattleBoard)
        let indexPath = self.tblBattleBoard.indexPathForRow(at: buttonPosition)

        if  indexPath?.section == 0 && self.arrBattelList.count > 0
        {
            dict =  self.arrBattelList[(indexPath?.row)!] as! NSDictionary
            iwinsToUnlockNextLevel = dict["winsToUnlockNextLevel"] as! NSNumber
            iBattleLevelType = 1
        }
        else
        {
            dict = self.arrAdvanceBattleList[(indexPath?.row)!] as! NSDictionary
            iBattleLevelType = 2
        }
        
        if dict["isLocked"] as! Bool == true
        {
            App_showAlert(withMessage: "You can not enter in locked battle", inView: self)
        }
        else
        {
           /* btnBack.isHidden = false
            vwBattleList.isHidden = true
            vwBattleGame.isHidden = false*/
            if iBattleLevelType == 1
            {
                    let myJSON = [
                        "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
                        "jackpotUniqueId" : appDelegate.strGameJackpotID,
                        "levelUniqueId" : "\(dict["uniqueId"]!)"
                    ]
                    SocketIOManager.sharedInstance.socket.emitWithAck("join_battle",  myJSON).timingOut(after: 0) {data in
                    }
            }
            else
            {
                let alertView = UIAlertController(title: Application_Name, message: "\(dict["levelName"]!) will cost “\(dict["minBidsToPut"] as! NSNumber) amount of Bids to play”", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Confirm", style: .default)
                { (action) in
                    let myJSON = [
                        "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
                        "jackpotUniqueId" : appDelegate.strGameJackpotID,
                        "levelUniqueId" : "\(dict["uniqueId"]!)"
                    ]
                    SocketIOManager.sharedInstance.socket.emitWithAck("join_battle",  myJSON).timingOut(after: 0) {data in
                    }
                }
                let CancelAction = UIAlertAction(title: "Cancel", style: .default)
                { (action) in
                }
                alertView.addAction(OKAction)
                alertView.addAction(CancelAction)
                self.present(alertView, animated: true, completion: nil)
            }
        }
        /*
        btnBack.isHidden = false
        vwBattleList.isHidden = true
        vwBattleGame.isHidden = false*/
    }
    
    //MARK: Advance battlle
    

    //MARK: Place a Bid and Quit Battle
    @IBAction func btnBidAction()
    {
        /* place_battle_bid
         {
         userId: 2,
         jackpotUniqueId: 'abcd',
         levelUniqueId: 'abcdefg
         gameUniqueId: 'abcccccc'
         }
         */
        let myJSON = [
            "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
            "jackpotUniqueId" : "\(strjackpotUniqueId)",
            "levelUniqueId" : "\(strlevelUniqueId)",
            "gameUniqueId" : "\(strgameUniqueId)"
        ]
        
        print("place_battle_bid:>\(myJSON)")
        
        SocketIOManager.sharedInstance.socket.emitWithAck("place_battle_bid",  myJSON).timingOut(after: 0) {data in
            if (data.count > 0)
            {
                print("data:>\(data)")
                App_showAlert(withMessage: ((data[0] as? NSDictionary)!.object(forKey: "body") as! NSDictionary).object(forKey: "message") as! String, inView: self)
            }
        }
    }
    
    @IBAction func btnBackAction()
    {
        vwBattleList.isHidden = false
        vwBattleGame.isHidden = true
        btnBack.isHidden = true
    }

    @IBAction func btnQuiteGameAction()
    {
        /* quit_battle
         When user clicks on Quit Game button, emit quit_battle with the following data:
         
         {
         userId: 2,
         jackpotUniqueId: 'abcd',
         levelUniqueId: 'abcdefg
         gameUniqueId: 'abcccccc'
         }
         
         After quitting from the game, listen the event battle_quitted and navigate user to the levels listing page.
         */
        let myJSON = [
            "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
            "jackpotUniqueId" : "\(strjackpotUniqueId)",
            "levelUniqueId" : "\(strlevelUniqueId)",
            "gameUniqueId" : "\(strgameUniqueId)"
        ]
        print("quit_battle:>\(myJSON)")
        
        SocketIOManager.sharedInstance.socket.emitWithAck("quit_battle",  myJSON).timingOut(after: 0) {data in
            if (data.count > 0)
            {
                print("data:>\(data)")
                App_showAlert(withMessage: ((data[0] as? NSDictionary)!.object(forKey: "body") as! NSDictionary).object(forKey: "message") as! String, inView: self)
            }
        }
    }
    
    func battle_game_quitted(_ notification: Notification)
    {
        App_showAlert(withMessage:"You have quitted battle successfully", inView: self)
        btnQuiteBattle.isHidden = true
        CTheightofQuitBtn.constant = 0
        vwBattleList.isHidden = false
        vwBattleGame.isHidden = true
        btnBack.isHidden = true
    }
    
    func jackpot_doomsday_over(_ notification: Notification)
    {
        vwBattleGame.isHidden = true
        vwJoinBattle.isHidden = true
        vwBattleList.isHidden = false
        vwTimer.isHidden = true

        let myJSON = [
            "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
            "jackpotUniqueId" : appDelegate.strGameJackpotID
        ]
        
        SocketIOManager.sharedInstance.socket.emitWithAck("request_battle",  myJSON).timingOut(after: 0) {data in
        }
    }
    func show_error_popup(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            // print("response_battle:>\(data)")
            App_showAlert(withMessage:"\(data["message"]!)", inView: self)
        }
    }
    
    //MARK: App Header
    func battleScreenHeader(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            if let dictJackpotTimer = data["header"] as? NSDictionary
            {
                txtGameClock.text = "\(dictJackpotTimer["gameClock"]!)"
                txtDoomdsDayClock.text = "\(dictJackpotTimer["doomsdayClock"]!)"
                txtJackpotAmount.text = "$\(dictJackpotTimer.object(forKey: "amount")!)"
                
                appDelegate.strGameClockTime  = txtGameClock.text!
                appDelegate.strDoomdsDayClock = txtDoomdsDayClock.text!
            }
        }
    }
}

extension BattleVC : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if arrBattelList.count > 0 && arrAdvanceBattleList.count > 0
        {
            return 2
        }
        else
        {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 0 && self.arrBattelList.count > 0
        {
            return "NORMAL"
        }
        else
        {
            return "ADVANCE"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 && self.arrBattelList.count > 0
        {
            return self.arrBattelList.count
        }
        else
        {
            return self.arrAdvanceBattleList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BattleCell") as! BattleCell

        if  indexPath.section == 0 && self.arrBattelList.count > 0
        {
            let dict = self.arrBattelList[indexPath.row] as! NSDictionary
            cell.lblLevel.text = "\(dict["levelName"]!)"
            
            cell.lblBids.text = "Jackpot: \(dict["prizeValue"]!) Bids"
            cell.lblPlayersCount.text = "Players: \(dict["playersCount"]!)"
            cell.lblActivePlayersCount.text = "Active: \(dict["activePlayersCount"]!)"
            /*
             {
             defaultAvailableBids: 10,
             isLastLevel: false,
             isLocked: false,
             levelName: "Level 1",
             order: 1,
             prizeType:"BID",
             prizeValue: 20
             playersCount: 20,
             activePlayersCount: 15
             }
             */
            if dict["isLocked"] as! Bool == true
            {
                cell.imgLock.isHidden = false
                cell.btnJoin.isHidden = true
            }
            else
            {
                cell.imgLock.isHidden = true
                cell.btnJoin.isHidden = false
            }
            cell.btnJoin.tag = indexPath.row
            cell.btnJoin.addTarget(self, action: #selector(btnJoinPressed(sender:)), for: .touchUpInside)
        }
        else if self.arrAdvanceBattleList.count > 0
        {
            let dict = self.arrAdvanceBattleList[indexPath.row] as! NSDictionary
            cell.lblLevel.text = "\(dict["levelName"]!)"
            
            cell.lblBids.text = "Jackpot: \(dict["prizeValue"]!) Bids"
            cell.lblPlayersCount.text = "Players: \(dict["playersCount"]!)"
            cell.lblActivePlayersCount.text = "Active: \(dict["activePlayersCount"]!)"
            if dict["isLocked"] as! Bool == true
            {
                cell.imgLock.isHidden = false
                cell.btnJoin.isHidden = true
            }
            else
            {
                cell.imgLock.isHidden = true
                cell.btnJoin.isHidden = false
            }
            cell.btnJoin.tag = indexPath.row
            cell.btnJoin.addTarget(self, action: #selector(btnJoinPressed(sender:)), for: .touchUpInside)
        }
        
        cell.selectionStyle = .none
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var dict = NSDictionary()
        if  indexPath.section == 0 && self.arrBattelList.count > 0
        {
            dict =  self.arrBattelList[indexPath.row] as! NSDictionary
            iBattleLevelType = 1
            iwinsToUnlockNextLevel = dict["winsToUnlockNextLevel"] as! NSNumber
        }
        else
        {
            dict = self.arrAdvanceBattleList[indexPath.row] as! NSDictionary
            iBattleLevelType = 2
        }
        
        if dict["isLocked"] as! Bool == true
        {
            App_showAlert(withMessage: "You can not enter in locked battle", inView: self)
        }
        else
        {
            btnBack.isHidden = false
            vwBattleList.isHidden = true
            vwBattleGame.isHidden = false
//
//                    let myJSON = [
//                        "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
//                        "jackpotUniqueId" : appDelegate.strGameJackpotID,
//                        "levelUniqueId" : "\(dict["uniqueId"]!)"
//                    ]
//                    SocketIOManager.sharedInstance.socket.emitWithAck("join_battle",  myJSON).timingOut(after: 0) {data in
//                    }

            if iBattleLevelType == 1
            {
                let myJSON = [
                    "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
                    "jackpotUniqueId" : appDelegate.strGameJackpotID,
                    "levelUniqueId" : "\(dict["uniqueId"]!)"
                ]
                SocketIOManager.sharedInstance.socket.emitWithAck("join_battle",  myJSON).timingOut(after: 0) {data in
                }
            }
            else
            {
                let alertView = UIAlertController(title: Application_Name, message: "\(dict["levelName"]!) will cost “\(dict["minBidsToPut"] as! NSNumber) amount of Bids to play”", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Confirm", style: .default)
                { (action) in
                    let myJSON = [
                        "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
                        "jackpotUniqueId" : appDelegate.strGameJackpotID,
                        "levelUniqueId" : "\(dict["uniqueId"]!)"
                    ]
                    SocketIOManager.sharedInstance.socket.emitWithAck("join_battle",  myJSON).timingOut(after: 0) {data in
                    }
                }
                let CancelAction = UIAlertAction(title: "Cancel", style: .default)
                { (action) in
                }
                alertView.addAction(OKAction)
                alertView.addAction(CancelAction)
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
}
class BattleCell: UITableViewCell
{
    @IBOutlet weak var lblLevel : UILabel!
    @IBOutlet weak var imgLock : UIImageView!
    @IBOutlet weak var lblBids : UILabel!
    @IBOutlet weak var btnJoin : UIButton!
    @IBOutlet weak var lblPlayersCount : UILabel!
    @IBOutlet weak var lblActivePlayersCount : UILabel!
}
class UnderlinedLabel: UILabel
{
    override var text: String?
        {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.characters.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}
