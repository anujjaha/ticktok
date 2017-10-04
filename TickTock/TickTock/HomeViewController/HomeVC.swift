//
//  HomeVC.swift
//  TickTock
//
//  Created by Yash on 26/03/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class HomeVC: UIViewController
{
    @IBOutlet weak var vwGame : UIView!
    @IBOutlet weak var vwPlayers : UIView!
    @IBOutlet weak var csofscrvwHieght : NSLayoutConstraint!
    
    @IBOutlet weak var txtGameClock: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtDoomdsDayClock: UITextField!

    @IBOutlet weak var lblcurrentBid : UILabel!
    @IBOutlet weak var lblcurrentBidLength : UILabel!
    @IBOutlet weak var lblLongestBid : UILabel!
    @IBOutlet weak var lblPlayersRemaining : UILabel!
    @IBOutlet weak var lblActivePlayers : UILabel!
    @IBOutlet weak var lblAverageBidBank : UILabel!

    @IBOutlet weak var lblUserBidBank : UILabel!
    @IBOutlet weak var lblUserLognestBid : UILabel!
    @IBOutlet weak var lblUserBattleWon : UILabel!
    @IBOutlet weak var lblUserBattleStreak : UILabel!
    
    @IBOutlet weak var lblGameTitle : UILabel!

    @IBOutlet weak var vwGameCompleted : UIView!
    @IBOutlet weak var lblGameWinner1 : UILabel!
    @IBOutlet weak var lblGameWinner2 : UILabel!

    @IBOutlet weak var btnBid : UIButton!

    
//    var socket = SocketIOClient(socketURL: URL(string: "http://35.154.46.190:1337")!, config: [.log(true), .forcePolling(true), .connectParams(["__sails_io_sdk_version":"0.11.0"])])
    var dictHomeData = NSDictionary()
    var dataofHome = NSDictionary()
    var gameId = Int()
    var strjackpotUniqueId = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.vwGame.layer.borderWidth = 1.0
        self.vwGame.layer.borderColor = UIColor.black.cgColor

        self.vwPlayers.layer.borderWidth = 1.0
        self.vwPlayers.layer.borderColor = UIColor.black.cgColor
        
        csofscrvwHieght.constant = 322
        
       // showProgress(inView: self.view)
        
        SocketIOManager.sharedInstance.socket.on("connect") {data, ack in
            
            print("socket connected")
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.handleGameUpdateNotification(_:)), name: NSNotification.Name(rawValue: "callGameUpdateNotification"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.handleGameJoinedNotification(_:)), name: NSNotification.Name(rawValue: "callGameJoinedNotification"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.handleGameUpdateTimerNotification(_:)), name: NSNotification.Name(rawValue: "callGameUpdateTimerNotification"), object: nil)

    
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleGameJackpotDataNotification(_:)), name: NSNotification.Name(rawValue: "callGameJackpotDataNotification"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.handleGameUserPlacedBidNotification(_:)), name: NSNotification.Name(rawValue: "callGameCanPlacedBidNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleGameUserBidsNotification(_:)), name: NSNotification.Name(rawValue: "callGameMyPlacedBidNotification"), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleGameFinishNotification(_:)), name: NSNotification.Name(rawValue: "callGameFinishNotification"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.handleGameQuitNotification(_:)), name: NSNotification.Name(rawValue: "callGameQuitNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.update_available_bid_after_battle_win(_:)), name: NSNotification.Name(rawValue: "update_available_bid_after_battle_win"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.update_jackpot_amount(_:)), name: NSNotification.Name(rawValue: "update_jackpot_amount"), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.update_home_jackpot_battle_info(_:)), name: NSNotification.Name(rawValue: "update_home_jackpot_battle_info"), object: nil)

        
        SocketIOManager.sharedInstance.establishConnection()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        appDelegate.bisHomeScreen = true
        self.navigationController?.isNavigationBarHidden = true
    }

    
    func handleGameUpdateNotification(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            
            lblcurrentBid.text = "Current Bid: \(data["current_bid_name"]!)"
            
            lblcurrentBidLength.text = "Current Bid Length: \(data["current_bid_time"]!)"
            lblLongestBid.text = "Longest Bid: \(data["longest_bid_by"]!)"
            
            if ("\(data["last_bid_user_id"]!)" == "\(appDelegate.arrLoginData[kkeyuserid]!)")
            {
                lblUserBidBank.text = "\(data["remaining_bids"] as! NSNumber)"
                btnBid.isEnabled = false
                btnBid.backgroundColor = UIColor.darkGray
            }
            else
            {
                btnBid.backgroundColor = UIColor.black
                btnBid.isEnabled = true
            }
        }
    }
    
    //MARK: Handle Server Listen Events
    func handleGameJoinedNotification(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
           // print("handleGameJoinedNotificationdata:>\(data)")
            lblGameTitle.text = "\((data["jackpotInfo"] as! NSDictionary).object(forKey: kkeyname)!)"
            txtAmount.text = "$\((data["jackpotInfo"] as! NSDictionary).object(forKey: kkeyamount)!)"
            lblUserBidBank.text = "\((data["userInfo"] as! NSDictionary).object(forKey: kkeyavailableBids)!)"
            strjackpotUniqueId = "\((data["jackpotInfo"] as! NSDictionary).object(forKey: "uniqueId")!)"
            appDelegate.strGameJackpotID = strjackpotUniqueId
        }
    }
    func handleGameUpdateTimerNotification(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            //  print("handleGameUpdateTimerNotificationdata:>\(data)")
            txtGameClock.text = "\(data["gameClockTime"]!)"
            txtDoomdsDayClock.text = "\(data["doomsDayClockTime"]!)"
            
            appDelegate.strGameClockTime  = txtGameClock.text!
            appDelegate.strDoomdsDayClock = txtDoomdsDayClock.text!
            
            if let latestValue = data["longestBidUserName"] as? String
            {
                lblLongestBid.text = "Longest Bid: \(latestValue)  \(data["longestBidDuration"]!)"
            }
            else
            {
                lblLongestBid.text = "Longest Bid: \(data["longestBidDuration"]!)"
                
            }
            
            lblcurrentBidLength.text = "Current Bid Length: \(data["lastBidDuration"]!)"
        }
    }
    func handleGameJackpotDataNotification(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            //print("handleGameJackpotDataNotificationdata:>\(data)")
            if(data.count > 0)
            {
                lblActivePlayers.text = "Active Players: \(data["activePlayers"]!)"
                lblAverageBidBank.text = "Average Bid Bank: \(data["averageBidBank"]!)"
                lblPlayersRemaining.text = "Players Remaining: \(data["remainingPlayers"]!)"
                lblcurrentBid.text = "Current Bid: \((data["currentBidUser"] as! NSDictionary).object(forKey: kkeyname)!)"
                
                if(data["canIBid"] as!  NSNumber == 1)
                {
                    btnBid.backgroundColor = UIColor.black
                    btnBid.isEnabled = true
                }
                else
                {
                    btnBid.isEnabled = false
                    btnBid.backgroundColor = UIColor.darkGray
                }
            }
        }
    }
    func handleGameUserPlacedBidNotification(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
          //  print("handleGameUserPlacedBidNotificationdata:>\(data)")
            if(data.count > 0)
            {
                if(data["canIBid"] as!  NSNumber == 1)
                {
                    btnBid.backgroundColor = UIColor.black
                    btnBid.isEnabled = true

                }
                else
                {
                    btnBid.isEnabled = false
                    btnBid.backgroundColor = UIColor.darkGray
                }
            }
        }
    }
    
    func handleGameUserBidsNotification(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            //print("handleGameUserBidsNotificationdata:>\(data)")
            if(data.count > 0)
            {
                lblUserBidBank.text = "\(data[kkeyavailableBids]!)"
            }
        }
    }

    func update_available_bid_after_battle_win(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            //print("handleGameUserBidsNotificationdata:>\(data)")
            if(data.count > 0)
            {
                lblUserBidBank.text = "\(data[kkeyavailableBids]!)"
            }
        }
    }
    
    func update_home_jackpot_battle_info(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            if(data.count > 0)
            {
                lblUserBattleWon.text = "\(data["battleWins"]!)"
                lblUserBattleStreak.text = "\(data["battleStreak"]!)"
            }
        }
    }
    

    func update_jackpot_amount(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            //print("handleGameUserBidsNotificationdata:>\(data)")
            if(data.count > 0)
            {
                txtAmount.text = "$\(data[kkeyamount] as! String)"
            }
        }
    }

    
    //MARK: Extra Methods
    func setViewLayoutwithData()
    {
        if (self.dataofHome.count > 0)
        {
            lblActivePlayers.text = "Active Players: \((self.dataofHome.object(forKey: "active_players")) as! NSNumber)"
            lblAverageBidBank.text = "Average Bid Bank: \((self.dataofHome.object(forKey: "ave_bid_bank")) as! NSNumber)"
            lblPlayersRemaining.text = "Players Remaining: \((self.dataofHome.object(forKey: "ave_bid_bank")) as! NSNumber)"
            
            lblcurrentBid.text = "Current Bid: \((self.dataofHome.object(forKey: "current_bid_by"))!)"
            lblcurrentBidLength.text = "Current Bid Length: \((self.dataofHome.object(forKey: "current_bid_time"))!)"
            lblLongestBid.text = "Longest Bid: \((self.dataofHome.object(forKey: "longest_bid_by"))!)"

            
            lblGameTitle.text = "\((self.dataofHome.object(forKey: "title")) as! String)"
            
            lblUserBidBank.text = "\((self.dataofHome.object(forKey: "bid_bank")) as! NSNumber)"
            lblUserLognestBid.text = "\(self.dataofHome.object(forKey: "my_longest_bid")!)"
            lblUserBattleWon.text = "\((self.dataofHome.object(forKey: "battle_won")) as! NSNumber)"
            lblUserBattleStreak.text = "\((self.dataofHome.object(forKey: "battle_streak")) as! NSNumber)"

            txtAmount.text = "$\(self.dataofHome.object(forKey: "amount")!)"
        }
    }
    
    //MARK: Place a Bid
    @IBAction func btnBidAction()
    {
        let myJSON = [
            "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
            "jackpotUniqueId" : strjackpotUniqueId
        ]
        
      //  print("data:>\(myJSON)")

        SocketIOManager.sharedInstance.socket.emitWithAck("place_bid",  myJSON).timingOut(after: 0) {data in
            if (data.count > 0)
            {
                print("data:>\(data)")
                App_showAlert(withMessage: ((data[0] as? NSDictionary)!.object(forKey: "body") as! NSDictionary).object(forKey: "message") as! String, inView: self)
            }
        }
    }

    //MARK: Game Finish and Quit Button
    func handleGameFinishNotification(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            print("handleGameFinishNotificationdata:>\(data)")
            if(data.count > 0)
            {
                
            }
        }
    }
    func handleGameQuitNotification(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            print("handleGameQuitNotificationdata:>\(data)")
            if(data.count > 0)
            {
                
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
