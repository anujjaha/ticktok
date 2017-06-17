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
    
    @IBOutlet weak var lblDoomdsDayClock: MZTimerLabel!
    @IBOutlet weak var lblGameClock: MZTimerLabel!

    @IBOutlet weak var txtGameClock: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    
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

    
    @IBOutlet weak var btnBid : UIButton!

    
//    var socket = SocketIOClient(socketURL: URL(string: "http://35.154.46.190:1337")!, config: [.log(true), .forcePolling(true), .connectParams(["__sails_io_sdk_version":"0.11.0"])])
    var dictHomeData = NSDictionary()
    var dataofHome = NSDictionary()
    var gameId = Int()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.vwGame.layer.borderWidth = 1.0
        self.vwGame.layer.borderColor = UIColor.black.cgColor

        self.vwPlayers.layer.borderWidth = 1.0
        self.vwPlayers.layer.borderColor = UIColor.black.cgColor
        
        csofscrvwHieght.constant = 322
        
        lblDoomdsDayClock.layer.borderColor = UIColor.black.cgColor
        lblDoomdsDayClock.layer.borderWidth = 1.0
        
        lblGameClock.layer.borderColor = UIColor.black.cgColor
        lblGameClock.layer.borderWidth = 1.0

        showProgress(inView: self.view)

        SocketIOManager.sharedInstance.socket.on("connect") {data, ack in
            print("socket connected")
            
            //            socket.emit("get", ["url": "/test"]) // I get the sails error

            SocketIOManager.sharedInstance.socket.emitWithAck("post",  ["url": "/api/home?user_id=\(appDelegate.arrLoginData[kkeyuserid]!)"]).timingOut(after: 0) {data in
                
                hideProgress()
                
                if (data.count > 0)
                {

                    print("data:>\(data)")
                    self.dictHomeData = (data[0] as? NSDictionary)!
                    print("self.dictHomeData:>\(self.dictHomeData)")
                    self.dataofHome = (self.dictHomeData.object(forKey: "body") as! NSDictionary).object(forKey: "data") as! NSDictionary
                    print("self.dataofHome:>\(self.dataofHome)")
                    self.setViewLayoutwithData()
                    self.GetGameUpdates()
                }
            }
            
            //            socket.emitWithAck("/api/home",  ["user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)"]).timingOut(after: 0) {data in
            //                print("data:>\(data)")
            //            }
        }
        
    NotificationCenter.default.addObserver(self, selector: #selector(self.handleGameUpdateNotification(_:)), name: NSNotification.Name(rawValue: "callGameUpdateNotification"), object: nil)

        SocketIOManager.sharedInstance.establishConnection()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }

    func GetGameUpdates()
    {
        SocketIOManager.sharedInstance.socket.on("game_updates") {data, ack in
            print("data:>\(data)")
        }
    }
    
    func handleGameUpdateNotification(_ notification: Notification)
    {
        if let data = notification.object as? [String: AnyObject]
        {
            print("data:>\(data)")
            
            var ighours: Int = Int(data["g_hours"] as! NSNumber)
            var igmins: Int = Int(data["g_mins"] as! NSNumber)
            let igsecs: Int = Int(data["g_secs"] as! NSNumber)
            ighours = ighours*3600
            igmins = igmins*60
            let iincrementSeconds = ighours+igmins+igsecs
            lblGameClock.reset()
            lblGameClock.setCountDownTime(TimeInterval(iincrementSeconds))
            lblGameClock.start()

            //            let iincrementSeconds: Int = Int(data["increment"] as! NSNumber)
//            lblGameClock.addTimeCounted(byTime: TimeInterval(iincrementSeconds))
            
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
            
            var idhours: Int = Int((self.dataofHome.object(forKey: "d_hours")) as! NSNumber)
            var idmins: Int = Int((self.dataofHome.object(forKey: "d_mins")) as! NSNumber)
            let idsecs: Int = Int((self.dataofHome.object(forKey: "d_secs")) as! NSNumber)
            
            gameId = Int((self.dataofHome.object(forKey: "id")) as! NSNumber)
            print("gameId:>\(gameId)")

            idhours = idhours*3600
            idmins = idmins*60
            
            let timevalue = idhours+idmins+idsecs
            
            lblDoomdsDayClock.timerType = MZTimerLabelTypeTimer
            lblDoomdsDayClock.setCountDownTime(TimeInterval(timevalue))
            lblDoomdsDayClock.start()
            
            var ighours: Int = Int((self.dataofHome.object(forKey: "g_hours")) as! NSNumber)
            var igmins: Int = Int((self.dataofHome.object(forKey: "g_mins")) as! NSNumber)
            let igsecs: Int = Int((self.dataofHome.object(forKey: "g_secs")) as! NSNumber)
            
            ighours = ighours*3600
            igmins = igmins*60
            
            let gametimevalue = ighours+igmins+igsecs
            lblGameClock.timerType = MZTimerLabelTypeTimer
            lblGameClock.setCountDownTime(TimeInterval(gametimevalue))
            lblGameClock.start()
        }
    }
    
    @IBAction func btnBidAction()
    {
        print ("/api/jackpot/new-bid?user_id=\(appDelegate.arrLoginData[kkeyuserid]!)&game_id=\(self.gameId)")
        SocketIOManager.sharedInstance.socket.emitWithAck("post",  ["url": "/api/jackpot/new-bid?user_id=\(appDelegate.arrLoginData[kkeyuserid]!)&game_id=\(self.gameId)"]).timingOut(after: 0) {data in
            if (data.count > 0)
            {
                print("data:>\(data)")
                let bisPlaced = ((data[0] as? NSDictionary)!.object(forKey: "body") as! NSDictionary).object(forKey: "status") as! String
               /* if(bisPlaced == "Fail")
                {
                    
                }
                else
                {*/
                    App_showAlert(withMessage: ((data[0] as? NSDictionary)!.object(forKey: "body") as! NSDictionary).object(forKey: "message") as! String, inView: self)
                //}
            }
        }
    }

    override func didReceiveMemoryWarning() {
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
