//
//  HomeVC.swift
//  TickTock
//
//  Created by Kevin on 26/03/17.
//  Copyright © 2017 Kevin. All rights reserved.
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
    @IBOutlet weak var CTLeadingofBidBtn : NSLayoutConstraint!
    @IBOutlet weak var CTTrailingofBidBtn: NSLayoutConstraint!

    
//    var socket = SocketIOClient(socketURL: URL(string: "http://35.154.46.190:1337")!, config: [.log(true), .forcePolling(true), .connectParams(["__sails_io_sdk_version":"0.11.0"])])
    var dictHomeData = NSDictionary()
    var dataofHome = NSDictionary()
    var gameId = Int()
    var strjackpotUniqueId = String()
    
    @IBOutlet weak var vwNoGame : UIView!

    
    
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

        //New Change only need to handle one event
        NotificationCenter.default.addObserver(self, selector: #selector(self.update_home_screen(_:)), name: NSNotification.Name(rawValue: "update_home_screen"), object: nil)

        SocketIOManager.sharedInstance.establishConnection()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        appDelegate.bisHomeScreen = true
        self.navigationController?.isNavigationBarHidden = true
    }

    //MARK: Handle Home Screen Data in one Event
    func update_home_screen(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            if let strscenename = data["scene"] as? String
            {
                /*
                 scene = game;
                 */
                if  strscenename == "game"
                {
                    if let dictheader = data["header"] as? NSDictionary
                    {
                        txtGameClock.text =  "\((dictheader).object(forKey: "gameClock")!)"
                        txtDoomdsDayClock.text = "\((dictheader).object(forKey: "doomsdayClock")!)"
                        lblGameTitle.text = "\((dictheader).object(forKey: kkeyname)!)"
                        txtAmount.text = "$\((dictheader).object(forKey: kkeyamount)!)"
                        
                        appDelegate.strGameClockTime  = txtGameClock.text!
                        appDelegate.strDoomdsDayClock = txtDoomdsDayClock.text!
                        
                        strjackpotUniqueId = "\((dictheader).object(forKey: "uniqueId")!)"
                        appDelegate.strGameJackpotID = strjackpotUniqueId
                    }
                    if let dictfooter = data["footer"] as? NSDictionary
                    {
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
                            appDelegate.bShowQuitGameButton = true
                        }
                        else
                        {
                            appDelegate.bShowQuitGameButton = false
                        }
                    }
                    
                    if let dictplayers = data["players"] as? NSDictionary
                    {
                        lblActivePlayers.text = "Active Players: \(dictplayers["activePlayers"]!)"
                        lblAverageBidBank.text = "Average Bid Bank: \(dictplayers["averageBidBank"]!)"
                        lblPlayersRemaining.text = "Players Remaining: \(dictplayers["playersRemaining"]!)"
                    }
                    
                    if let dictmyinfo = data["my_info"] as? NSDictionary
                    {
                        lblUserBattleWon.text = "\(dictmyinfo["battlesWon"]!)"
                        lblUserBattleStreak.text = "\(dictmyinfo["battleStreak"]!)"
                        lblLongestBid.text = "Longest Bid: \(dictmyinfo["myLongestBid"]!)"
                        lblUserBidBank.text = "\(dictmyinfo["bidBank"] as! NSNumber)"
                        UserDefaults.standard.set("\(dictmyinfo["bidBank"] as! NSNumber)", forKey: kUserBidBank)
                        UserDefaults.standard.synchronize()
                    }
                    
                    if let dictbids = data["bids"] as? NSDictionary
                    {
                        if let currentBidUser = (dictbids).object(forKey: "currentBidUser") as? String
                        {
                            lblcurrentBid.text = "Current Bid: \(currentBidUser)"
                        }
                        else
                        {
                            lblcurrentBid.text = "Current Bid:"
                        }
                        
                        if let latestValue = dictbids["longestBidDuration"] as? String
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
                                lblLongestBid.text = "Longest Bid:"
                            }
                        }
                        
                        if let lastBidDuration = dictbids["currentBidDuration"] as? String
                        {
                            lblcurrentBidLength.text = "Current Bid Length: \(lastBidDuration)"
                        }
                        else
                        {
                            lblcurrentBidLength.text = "Current Bid Length:"
                        }
                    }
                }
                else if strscenename == "no_jackpot"
                {
                    self.tabBarController?.selectedIndex = 0
                    txtGameClock.text = "00:00:00"
                    txtDoomdsDayClock.text = "00:00:00"
                    vwNoGame.isHidden = false
                    vwGame.isHidden = true
                    vwPlayers.isHidden = true
                    self.btnBid.isHidden = true
                }
                else if strscenename == "winner"
                {
                    var strmessage = String()
                    
                    if let dictwinner = data["winner"] as? NSDictionary
                    {
                        strmessage = "Game Won info:\nLastBidWinner: \((dictwinner["lastBidWinner"]!))\nLongestBidWinner: \((dictwinner["longestBidWinner"]!))"
                    }
                    else
                    {
                        strmessage = "Game Finished"
                    }
                    
                    let alertView = UIAlertController(title: Application_Name, message: strmessage, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    { (action) in
                        
                        self.vwNoGame.isHidden = false
                        self.vwGame.isHidden = true
                        self.vwPlayers.isHidden = true
                        self.btnBid.isHidden = true
                        appDelegate.bShowQuitGameButton = false
                        
                        SocketIOManager.sharedInstance.closeConnection()
                        SocketIOManager.sharedInstance.establishConnection()
                    }
                    alertView.addAction(OKAction)
                    self.present(alertView, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: Handle Server Listen Events
    func handleGameJoinedNotification(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            vwNoGame.isHidden = true
            vwGame.isHidden = false
            vwPlayers.isHidden = false
            self.btnBid.isHidden = false


           // print("handleGameJoinedNotificationdata:>\(data)")
            lblGameTitle.text = "\((data["jackpotInfo"] as! NSDictionary).object(forKey: kkeyname)!)"
            txtAmount.text = "$\((data["jackpotInfo"] as! NSDictionary).object(forKey: kkeyamount)!)"
            lblUserBidBank.text = "\((data["userInfo"] as! NSDictionary).object(forKey: kkeyavailableBids)!)"
            
            UserDefaults.standard.set("\((data["userInfo"] as! NSDictionary).object(forKey: kkeyavailableBids)!)", forKey: kUserBidBank)
            UserDefaults.standard.synchronize()

            strjackpotUniqueId = "\((data["jackpotInfo"] as! NSDictionary).object(forKey: "uniqueId")!)"
            appDelegate.strGameJackpotID = strjackpotUniqueId
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
            
            if let currentBidUser = self.dataofHome.object(forKey: "current_bid_by") as? String
            {
                lblcurrentBid.text = "Current Bid: \(currentBidUser)"
                
            }
            else
            {
                lblcurrentBid.text = "Current Bid:"
            }
            lblcurrentBidLength.text = "Current Bid Length: \((self.dataofHome.object(forKey: "current_bid_time"))!)"
            lblLongestBid.text = "Longest Bid: \((self.dataofHome.object(forKey: "longest_bid_by"))!)"

            
            lblGameTitle.text = "\((self.dataofHome.object(forKey: "title")) as! String)"
            
            lblUserBidBank.text = "\((self.dataofHome.object(forKey: "bid_bank")) as! NSNumber)"
            UserDefaults.standard.set("\((self.dataofHome.object(forKey: "bid_bank")) as! NSNumber)", forKey: kUserBidBank)
            UserDefaults.standard.synchronize()

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

//        SocketIOManager.sharedInstance.socket.emitWithAck("place_bid",  myJSON).timingOut(after: 0) {data in
        SocketIOManager.sharedInstance.socket.emitWithAck("place_jackpot_bid",  myJSON).timingOut(after: 0) {data in
            if (data.count > 0)
            {
                print("data:>\(data)")
                App_showAlert(withMessage: ((data[0] as? NSDictionary)!.object(forKey: "body") as! NSDictionary).object(forKey: "message") as! String, inView: self)
            }
        }
    }
    

    @IBAction func btnQuiteGameAction()
    {
        let myJSON = [
            "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
            "jackpotUniqueId" : strjackpotUniqueId
        ]
        
        //  print("data:>\(myJSON)")
        SocketIOManager.sharedInstance.socket.emitWithAck("quit_jackpot_game",  myJSON).timingOut(after: 0) {data in
            if (data.count > 0)
            {
                print("data:>\(data)")
                App_showAlert(withMessage: ((data[0] as? NSDictionary)!.object(forKey: "body") as! NSDictionary).object(forKey: "message") as! String, inView: self)
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
