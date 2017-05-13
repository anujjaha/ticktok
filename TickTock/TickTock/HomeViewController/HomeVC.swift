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
    
    @IBOutlet weak var txtGameClock: UITextField!
    @IBOutlet weak var txtDoomdsDayClock: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    
    var socket = SocketIOClient(socketURL: URL(string: "http://35.154.46.190:1337")!, config: [.log(true), .forcePolling(true), .connectParams(["__sails_io_sdk_version":"0.11.0"])])
    var dictHomeData = NSDictionary()
    var dataofHome = NSDictionary()

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
        

        socket.on("connect") {data, ack in
            print("socket connected")
            
//            socket.emit("get", ["url": "/test"]) // I get the sails error
            
            self.socket.emitWithAck("post",  ["url": "/api/home?user_id=\(appDelegate.arrLoginData[kkeyuserid]!)"]).timingOut(after: 0) {data in
                if (data.count > 0)
                {
                    print("data:>\(data)")
                    self.dictHomeData = (data[0] as? NSDictionary)!
                    print("self.dictHomeData:>\(self.dictHomeData)")
                    self.dataofHome = (self.dictHomeData.object(forKey: "body") as! NSDictionary).object(forKey: "data") as! NSDictionary
                    print("self.dataofHome:>\(self.dataofHome)")
                }
            }
            
//            socket.emitWithAck("/api/home",  ["user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)"]).timingOut(after: 0) {data in
//                print("data:>\(data)")
//            }
        }
        socket.connect()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
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
