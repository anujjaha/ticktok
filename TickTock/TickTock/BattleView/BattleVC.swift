//
//  BattleVC.swift
//  TickTock
//
//  Created by Yash on 26/03/17.
//  Copyright © 2017 Niyati. All rights reserved.
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


    override func viewDidLoad()
    {
        super.viewDidLoad()
        vwBattleList.isHidden = true
        vwBattleGame.isHidden = true
        vwJoinBattle.layer.cornerRadius = 5.0
        lblNoJakpotFound.isHidden = true
        // Do any additional setup after loading the view.
        
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

        NotificationCenter.default.addObserver(self, selector: #selector(self.update_battle_screen(_:)), name: NSNotification.Name(rawValue: "update_level_screen"), object: nil)
        
        
        //Battel Screen
        /*
         export const EVT_EMIT_RESPONSE_BATTLE      						= 'response_battle';
         export const EVT_EMIT_RESPONSE_JOIN_NORMAL_BATTLE_LEVEL 	 	= 'response_join_normal_battle_level';
         export const EVT_EMIT_RESPONSE_PLACE_NORMAL_BATTLE_LEVEL_BID 	= 'response_place_normal_battle_level_bid';
         export const EVT_EMIT_NO_ENOUGH_AVAILABLE_BIDS 					= 'no_enough_available_bids';
         */
        NotificationCenter.default.addObserver(self, selector: #selector(self.response_battle(_:)), name: NSNotification.Name(rawValue: "response_battle"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.response_join_normal_battle_level(_:)), name: NSNotification.Name(rawValue: "response_join_normal_battle_level"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.response_place_normal_battle_level_bid(_:)), name: NSNotification.Name(rawValue: "response_place_normal_battle_level_bid"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.no_enough_available_bids(_:)), name: NSNotification.Name(rawValue: "no_enough_available_bids"), object: nil)

        
        /*
            export const EVT_EMIT_UPDATE_NORMAL_BATTLE_LEVEL_PLAYER_LIST    = 'update_normal_battle_level_player_list';
            export const EVT_EMIT_NORMAL_BATTLE_LEVEL_TIMER                 = 'update_normal_battle_level_timer';
            export const EVT_EMIT_NORMAL_BATTLE_GAME_STARTED                = 'normal_battle_level_game_started';
         */
        NotificationCenter.default.addObserver(self, selector: #selector(self.update_normal_battle_level_player_list(_:)), name: NSNotification.Name(rawValue: "update_normal_battle_level_player_list"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.update_normal_battle_level_timer(_:)), name: NSNotification.Name(rawValue: "update_normal_battle_level_timer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.normal_battle_level_game_started(_:)), name: NSNotification.Name(rawValue: "normal_battle_level_game_started"), object: nil)

        
        /*
         export const EVT_EMIT_HIDE_NBL_PLACE_BID_BUTTON                 = 'hide_normal_battle_level_place_bid_button';
         export const EVT_EMIT_SHOW_NBL_PLACE_BID_BUTTON                 = 'show_normal_battle_level_place_bid_button';
         export const EVT_EMIT_NBL_GAME_FINISHED                         = 'normal_battle_level_game_finished';
         */
        NotificationCenter.default.addObserver(self, selector: #selector(self.hide_normal_battle_level_place_bid_button(_:)), name: NSNotification.Name(rawValue: "hide_normal_battle_level_place_bid_button"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.show_normal_battle_level_place_bid_button(_:)), name: NSNotification.Name(rawValue: "show_normal_battle_level_place_bid_button"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.normal_battle_level_game_finished(_:)), name: NSNotification.Name(rawValue: "normal_battle_level_game_finished"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.update_normal_battle_jackpot_amount(_:)), name: NSNotification.Name(rawValue: "update_normal_battle_jackpot_amount"), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.CallUpdateTimer(_:)), name: NSNotification.Name(rawValue: "callGameUpdateTimerofBattle"), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.normal_battle_main_jackpot_finished(_:)), name: NSNotification.Name(rawValue: "normal_battle_main_jackpot_finished"), object: nil)

        //normal_battle_game_about_to_start
        NotificationCenter.default.addObserver(self, selector: #selector(self.normal_battle_game_about_to_start(_:)), name: NSNotification.Name(rawValue: "normal_battle_game_about_to_start"), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.advance_battle_not_eligible_to_join), name: NSNotification.Name(rawValue: "advance_battle_not_eligible_to_join"), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.something_went_wrong_battle(_:)), name: NSNotification.Name(rawValue: "something_went_wrong_battle"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.show_normal_battle_quit_button(_:)), name: NSNotification.Name(rawValue: "show_normal_battle_quit_button"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.hide_normal_battle_quit_button(_:)), name: NSNotification.Name(rawValue: "hide_normal_battle_quit_button"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.normal_battle_game_quitted(_:)), name: NSNotification.Name(rawValue: "normal_battle_game_quitted"), object: nil)        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.jackpot_doomsday_over(_:)), name: NSNotification.Name(rawValue: "jackpot_doomsday_over"), object: nil)

        
        btnBack.isHidden = true
    }
    
    //MARK: Update_level_screen
    func update_level_screen(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            // print("response_battle:>\(data)")
            dictBattleList = NSMutableDictionary(dictionary: (data["levels"] as! NSDictionary))
            
            if  dictBattleList.count > 0
            {
                arrAdvanceBattleList = NSMutableArray(array: (dictBattleList["advance"] as! NSArray))
                arrBattelList = NSMutableArray(array: (dictBattleList["normal"] as! NSArray))
                
                if arrBattelList.count > 0 || arrAdvanceBattleList.count > 0
                {
                    lblNoJakpotFound.isHidden = true
                    tblBattleBoard.isHidden = false
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
                        
                    }
                }
            }
        }
    }
    //MARK: Hadnle Notification of battle
    func response_battle(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
           // print("response_battle:>\(data)")
            arrBattelList = NSMutableArray(array: (data["battleLevelsList"] as! NSArray))
            
            if arrBattelList.count > 0
            {
                if data["battleType"] as! NSString == "NORMAL"
                {
                    iBattleLevelType = 1
                }
                else
                {
                    iBattleLevelType = 2
                }
                lblNoJakpotFound.isHidden = true
                tblBattleBoard.isHidden = false
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
    
    func CallUpdateTimer(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            txtGameClock.text = "\(data["gameClockTime"]!)"
            txtDoomdsDayClock.text = "\(data["doomsDayClockTime"]!)"
            
            appDelegate.strGameClockTime  = txtGameClock.text!
            appDelegate.strDoomdsDayClock = txtDoomdsDayClock.text!
        }
    }
    
    func response_join_normal_battle_level(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
           // print("response_join_normal_battle_level:>\(data)")
            
            /*
             players =         (
             {
             name = "Ticktock Admin";
             picture = "http://172.31.23.212:9000/images/avatar.jpg";
             totalBids = 0;
             userId = 1;
             }
             );
             */
            
            dictgameInfo = (data["gameInfo"] as! NSDictionary)
            dictjackpotInfo = (data["jackpotInfo"] as! NSDictionary)
            dictlevelInfo = (data["levelInfo"] as! NSDictionary)
            dictmyInfo = (data["myInfo"] as! NSDictionary)
            arrPlayers = NSMutableArray(array: (data["players"] as! NSArray))
            
            let iKeyuserid = (appDelegate.arrLoginData[kkeyuser_id]!) as! Int
            
            let namePredicate = NSPredicate(format: "%K = %d", "userId",iKeyuserid)
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

            //UI Setting
            //            lblGameTitle.text = "\((data["jackpotInfo"] as! NSDictionary).object(forKey: kkeyname)!)"

            lblMyBids.text = "My Battle Bids: \(dictmyInfo.object(forKey: "availableBids")!)"
            lblPrizeNO.text = "Prize: \(dictlevelInfo.object(forKey: "prizeValue")!) Bids"
            lblBattleNO.text = "\(dictjackpotInfo.object(forKey: "name")!)"
            txtJackpotAmount.text = "\(dictjackpotInfo.object(forKey: "amount")!)"
            txtBattleClock.text = "\(dictgameInfo.object(forKey: "duration")!)"
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

    func no_enough_available_bids(_ notification: Notification)
    {
        btnBid.isEnabled = false
        btnBid.backgroundColor = UIColor.darkGray
        App_showAlert(withMessage:"No enough available bids", inView: self)
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

    func update_normal_battle_level_timer(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            /*
             data: [{
             battleClock = "02:00";
             currentBidDuration = "<null>";
             currentBidUserName = "<null>";
             longestBidDuration = 0;
             longestBidUserName = "<null>";
             }]
             */
            
          //  print("update_normal_battle_level_timer:>\(data)")
            txtBattleClock.text = "\(data["battleClock"]!)"
            if let latestValue = data["longestBidUserName"] as? String
            {
                lblLongestBid.text = "Longest Bid: \(latestValue)  \(data["longestBidDuration"]!)"
            }
            else
            {
                lblLongestBid.text = "Longest Bid: \(data["longestBidDuration"]!)"
            }
            
            lblCurrentBidLength.text = "Current Bid Length: \(data["currentBidDuration"]!)"
            
            if let latestValue = data["currentBidUserName"] as? String
            {
                lblCurrentBid.text = "Current Bid: \(latestValue)"
            }
            else
            {
                lblCurrentBid.text = "Current Bid: "
            }
        }
    }
    
    func normal_battle_level_game_started(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
           // print("normal_battle_level_game_started:>\(data)")
            
            vwTimer.isHidden = true
            vwBattleGame.isHidden = false
            vwJoinBattle.isHidden = true
            vwBattleList.isHidden = true
        }
    }
    
    func update_normal_battle_jackpot_amount(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            //print("handleGameUserBidsNotificationdata:>\(data)")
            if(data.count > 0)
            {
                txtJackpotAmount.text = "$\(data[kkeyamount] as! String)"
            }
        }
    }

    func normal_battle_main_jackpot_finished(_ notification: Notification)
    {
        self.tabBarController?.selectedIndex = 0
    }
    
    //MARK: Hide or Show Battle Bid Button
    func hide_normal_battle_level_place_bid_button(_ notification: Notification)
    {
      //  print("hide_normal_battle_level_place_bid_button:")
        btnBid.isEnabled = false
        btnBid.backgroundColor = UIColor.darkGray
    }
    func show_normal_battle_level_place_bid_button(_ notification: Notification)
    {
       // print("hide_normal_battle_level_place_bid_button:")
        
        btnBid.backgroundColor = UIColor.black
        btnBid.isEnabled = true
    }
    func normal_battle_level_game_finished(_ notification: Notification)
    {
        var strmessage = String()
        if let data = notification.object as? [String: AnyObject]
        {
            if(data.count > 0)
            {
                if let lastBidWinner = (data["lastBidWinner"] as? NSDictionary), let longestBidWinner = (data["longestBidWinner"] as? NSDictionary)
                {
                    strmessage = "Battle Won info:\nLastBidWinner: \((lastBidWinner["name"]!))\nLongestBidWinner: \((longestBidWinner["name"]!))"
                }
                else
                {
                    strmessage = "Battle Finished"
                }
            }
            else
            {
                strmessage = "Battle Finished"
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
            
            
            let myJSON = [
                "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
                "jackpotUniqueId" : appDelegate.strGameJackpotID
            ]
            
            //  print("data:>\(myJSON)")
            SocketIOManager.sharedInstance.socket.emitWithAck("request_battle",  myJSON).timingOut(after: 0) {data in
            }
        }
        alertView.addAction(OKAction)
        
        self.present(alertView, animated: true, completion: nil)

    }
    func normal_battle_game_about_to_start(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            if(data.count > 0)
            {
                vwBattleList.isHidden = true
                vwBattleGame.isHidden = true
                vwJoinBattle.isHidden = true
                vwTimer.isHidden = false
                
                lbltimerSeconds.text = "\(data["time"] as! Int)"
            }
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        appDelegate.bisHomeScreen = false
        self.navigationController?.isNavigationBarHidden = true
        
        txtGameClock.text = appDelegate.strGameClockTime
        txtDoomdsDayClock.text = appDelegate.strDoomdsDayClock
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

        if  indexPath?.section == 0
        {
            dict =  self.arrBattelList[(indexPath?.row)!] as! NSDictionary
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
            btnBack.isHidden = false
            vwBattleList.isHidden = true
            vwBattleGame.isHidden = false
            
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
                let iBidAvilable = UserDefaults.standard.value(forKey: kUserBidBank) as! Int
                if dict["minRequiredBids"] as! Int >=  iBidAvilable
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
                    App_showAlert(withMessage:"You Don't Have Enough Bids To Join This Battle", inView: self)
                }
            }
        }
        btnBack.isHidden = false
        vwBattleList.isHidden = true
        vwBattleGame.isHidden = false
    }
    
    //MARK: Advance battlle
    func advance_battle_not_eligible_to_join()
    {
        
    }
    
    func something_went_wrong_battle(_ notification: Notification)
    {
        App_showAlert(withMessage:"Something went wrong. Please try again later", inView: self)
    }
    

    //MARK: Place a Bid
    @IBAction func btnBidAction()
    {
        if(dictjackpotInfo.count > 0)
        {
            if iBattleLevelType == 1
            {
                let myJSON = [
                    "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
                    "jackpotUniqueId" : "\(dictjackpotInfo["uniqueId"]!)",
                    "levelUniqueId" : "\(dictlevelInfo["uniqueId"]!)",
                    "gameUniqueId" : "\(dictgameInfo["uniqueId"]!)"
                ]
                
                print("request_place_normal_battle_level_bid:>\(myJSON)")
                
                SocketIOManager.sharedInstance.socket.emitWithAck("request_place_normal_battle_level_bid",  myJSON).timingOut(after: 0) {data in
                    if (data.count > 0)
                    {
                        print("data:>\(data)")
                        App_showAlert(withMessage: ((data[0] as? NSDictionary)!.object(forKey: "body") as! NSDictionary).object(forKey: "message") as! String, inView: self)
                    }
                }
            }
            else
            {
                let myJSON = [
                    "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
                    "jackpotUniqueId" : "\(dictjackpotInfo["uniqueId"]!)",
                    "levelUniqueId" : "\(dictlevelInfo["uniqueId"]!)",
                    "gameUniqueId" : "\(dictgameInfo["uniqueId"]!)"
                ]
                
                print("request_place_advance_battle_level_bid:>\(myJSON)")
                
                SocketIOManager.sharedInstance.socket.emitWithAck("request_place_advance_battle_level_bid",  myJSON).timingOut(after: 0) {data in
                    if (data.count > 0)
                    {
                        print("data:>\(data)")
                        App_showAlert(withMessage: ((data[0] as? NSDictionary)!.object(forKey: "body") as! NSDictionary).object(forKey: "message") as! String, inView: self)
                    }
                }
                
            }
        }
    }
    
    @IBAction func btnBackAction()
    {
        vwBattleList.isHidden = false
        vwBattleGame.isHidden = true
        btnBack.isHidden = true
    }

    //MARK: Show Quite and hide and Place a Quit Button
    func hide_normal_battle_quit_button(_ notification: Notification)
    {
        btnQuiteBattle.isHidden = true
        CTheightofQuitBtn.constant = 0
    }
    
    func show_normal_battle_quit_button(_ notification: Notification)
    {
        btnQuiteBattle.isHidden = false
        CTheightofQuitBtn.constant = 40
    }
    
    func game_quitted(_ notification: Notification)
    {
        App_showAlert(withMessage:"You have quitted battle successfully", inView: self)
        btnQuiteBattle.isHidden = true
        CTheightofQuitBtn.constant = 0
    }

    @IBAction func btnQuiteGameAction()
    {
        if(dictjackpotInfo.count > 0)
        {
            if iBattleLevelType == 1
            {
                let myJSON = [
                    "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
                    "jackpotUniqueId" : "\(dictjackpotInfo["uniqueId"]!)",
                    "levelUniqueId" : "\(dictlevelInfo["uniqueId"]!)",
                    "gameUniqueId" : "\(dictgameInfo["uniqueId"]!)"
                ]
                
                print("request_place_normal_battle_level_bid:>\(myJSON)")
                
                SocketIOManager.sharedInstance.socket.emitWithAck("quit_normal_battle_game",  myJSON).timingOut(after: 0) {data in
                    if (data.count > 0)
                    {
                        print("data:>\(data)")
                        App_showAlert(withMessage: ((data[0] as? NSDictionary)!.object(forKey: "body") as! NSDictionary).object(forKey: "message") as! String, inView: self)
                    }
                }
            }
            else
            {
                let myJSON = [
                    "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
                    "jackpotUniqueId" : "\(dictjackpotInfo["uniqueId"]!)",
                    "levelUniqueId" : "\(dictlevelInfo["uniqueId"]!)",
                    "gameUniqueId" : "\(dictgameInfo["uniqueId"]!)"
                ]
                
                print("request_place_advance_battle_level_bid:>\(myJSON)")
                
                SocketIOManager.sharedInstance.socket.emitWithAck("quit_advance_battle_game",  myJSON).timingOut(after: 0) {data in
                    if (data.count > 0)
                    {
                        print("data:>\(data)")
                        App_showAlert(withMessage: ((data[0] as? NSDictionary)!.object(forKey: "body") as! NSDictionary).object(forKey: "message") as! String, inView: self)
                    }
                }
            }
        }
    }
    
    func normal_battle_game_quitted(_ notification: Notification)
    {
        App_showAlert(withMessage:"You have quitted battle successfully", inView: self)
        btnQuiteBattle.isHidden = true
        CTheightofQuitBtn.constant = 0
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

    
    
    //MARK: Battle Type 2 Level

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
        if section == 0
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
        if section == 0
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

        if  indexPath.section == 0
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
        else if indexPath.section == 1
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
        if  indexPath.section == 0
        {
            dict =  self.arrBattelList[indexPath.row] as! NSDictionary
            iBattleLevelType = 1
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
                let iBidAvilable = UserDefaults.standard.value(forKey: kUserBidBank) as! Int
                if dict["minRequiredBids"] as! Int >=  iBidAvilable
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
                    App_showAlert(withMessage:"You Don't Have Enough Bids To Join This Battle", inView: self)
                }
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
