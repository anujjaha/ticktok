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

        SocketIOManager.sharedInstance.socket.on("connect") {data, ack in
            print("socket connected")
            
            //            socket.emit("get", ["url": "/test"]) // I get the sails error
            
            SocketIOManager.sharedInstance.socket.emitWithAck("post",  ["url": "/api/home?user_id=\(appDelegate.arrLoginData[kkeyuserid]!)"]).timingOut(after: 0) {data in
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
            
            let iincrementSeconds: Int = Int(data["increment"] as! NSNumber)
            lblGameClock.addTimeCounted(byTime: TimeInterval(iincrementSeconds))
            
            lblcurrentBid.text = "Current Bid: \(data["current_bid_name"]!)"
            
            if ("\(data["last_bid_user_id"]!)" == "\(appDelegate.arrLoginData[kkeyuserid]!)")
            {
                btnBid.isEnabled = false
            }
            else
            {
                btnBid.isEnabled = true
            }
        }
    }
    
    func setViewLayoutwithData()
    {
        if (self.dataofHome.count > 0)
        {
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
                let bisPlaced = (self.dictHomeData.object(forKey: "body") as! NSDictionary).object(forKey: "status") as! String
                if(bisPlaced == "Fail")
                {
                }
                else
                {
                    
                }
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
