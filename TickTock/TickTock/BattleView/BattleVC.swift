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

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        vwBattleList.isHidden = true
        vwBattleGame.isHidden = true
        vwJoinBattle.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
        
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

        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        var underlineAttributedString = NSAttributedString(string: "Battle #21", attributes: underlineAttribute)
        lblBattleNO.attributedText = underlineAttributedString
        
        underlineAttributedString = NSAttributedString(string: "Prize: 50 Bids", attributes: underlineAttribute)
        lblPrizeNO.attributedText = underlineAttributedString
        
        
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

        
        
    }
    
    //MARK: Hadnle Notification of battle
    func response_battle(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
           // print("response_battle:>\(data)")
            arrBattelList = NSMutableArray(array: (data["battleLevelsList"] as! NSArray))
            tblBattleBoard.reloadData()
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
                let lastBidWinner = (data["lastBidWinner"] as! NSDictionary)
                let longestBidWinner = (data["longestBidWinner"] as! NSDictionary)

                strmessage = "Battle Won info:\nLastBidWinner: \((lastBidWinner["name"]!))\nLongestBidWinner: \((longestBidWinner["name"]!))"
            }
            else
            {
                strmessage = "Battle finished"
            }
        }
        else
        {
            strmessage = "Battle finished"
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        appDelegate.bisHomeScreen = false
        self.navigationController?.isNavigationBarHidden = true
        
        txtGameClock.text = appDelegate.strGameClockTime
        txtDoomdsDayClock.text = appDelegate.strDoomdsDayClock
    }

    @IBAction func JoinBattleButtonPressed()
    {
        vwJoinBattle.isHidden = true
        vwBattleList.isHidden = false
        
        let myJSON = [
            "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
            "jackpotUniqueId" : appDelegate.strGameJackpotID
        ]
        
        //  print("data:>\(myJSON)")
        SocketIOManager.sharedInstance.socket.emitWithAck("request_battle",  myJSON).timingOut(after: 0) {data in
        }
        
     //   SocketIOManager.sharedInstance.socket.emitWithAck("needsAck", "test").onAck {data in
          //  print("got ack with data: (data)")
        //}
        
              
        //        SocketIOManager.sharedInstance.socket.emitWithAck("request_battle", myJSON).timingOut(after: 0, callback: { data in
//            print("CONNECTED FOR SURE")
//            
//            if (data.count > 0)
//            {
//                print("data:>\(data)")
//            }
//        })

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnJoinPressed(sender: UIButton)
    {
        let dict = self.arrBattelList[sender.tag] as! NSDictionary
        
        let myJSON = [
            "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
            "jackpotUniqueId" : appDelegate.strGameJackpotID,
            "levelUniqueId" : "\(dict["uniqueId"]!)",
            "battleType" : "NORMAL"
        ]
        SocketIOManager.sharedInstance.socket.emitWithAck("request_join_normal_battle_level",  myJSON).timingOut(after: 0) {data in
        }
        
        vwBattleList.isHidden = true
        vwBattleGame.isHidden = false
    }

    //MARK: Place a Bid
    @IBAction func btnBidAction()
    {
        if(dictjackpotInfo.count > 0)
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
    }

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrBattelList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BattleCell") as! BattleCell
        
        let dict = self.arrBattelList[indexPath.row] as! NSDictionary
        cell.lblLevel.text = "\(dict["levelName"]!)"
        
        cell.lblBids.text = "Jackpot: \(dict["prizeValue"]!) Bids"
        
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
        /*
        if (indexPath.row > 0)
        {
            cell.imgLock.isHidden = false
        }
        else
        {
            cell.imgLock.isHidden = true
        }
 */
        cell.btnJoin.tag = indexPath.row
        cell.btnJoin.addTarget(self, action: #selector(btnJoinPressed(sender:)), for: .touchUpInside)

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
        vwBattleList.isHidden = true
        vwBattleGame.isHidden = false
        let dict = self.arrBattelList[indexPath.row] as! NSDictionary

        let myJSON = [
            "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
            "jackpotUniqueId" : appDelegate.strGameJackpotID,
            "levelUniqueId" : "\(dict["uniqueId"]!)",
            "battleType" : "NORMAL"
        ]
        SocketIOManager.sharedInstance.socket.emitWithAck("request_join_normal_battle_level",  myJSON).timingOut(after: 0) {data in
        }
    }
}
class BattleCell: UITableViewCell
{
    @IBOutlet weak var lblLevel : UILabel!
    @IBOutlet weak var imgLock : UIImageView!
    @IBOutlet weak var lblBids : UILabel!
    @IBOutlet weak var btnJoin : UIButton!

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
