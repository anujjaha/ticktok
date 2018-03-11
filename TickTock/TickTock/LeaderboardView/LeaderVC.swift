
//
//  LeaderVC.swift
//  TickTock
//
//  Created by Kevin on 26/03/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class LeaderVC: UIViewController {

    @IBOutlet weak var tblLeaderBoard : UITableView!
    @IBOutlet weak var btnGame : UIButton!
    @IBOutlet weak var btnAllTime : UIButton!
    @IBOutlet weak var btnCategory : UIButton!

    @IBOutlet weak var txtGameClock: UITextField!
    @IBOutlet weak var txtDoomdsDayClock: UITextField!
    @IBOutlet weak var txtJackpotAmount: UITextField!
    
    @IBOutlet weak var vwSelectCategory: UIView!
    @IBOutlet weak var btnSelectCategory1 : UIButton!
    @IBOutlet weak var btnSelectCategory2 : UIButton!
    @IBOutlet weak var btnSelectCategory3 : UIButton!
    @IBOutlet weak var btnSelectCategory4 : UIButton!

    var arrCategoryData = NSMutableArray()
    var strTypetoFileteLeaderBoard = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tblLeaderBoard.estimatedRowHeight = 30.0 ;
        self.tblLeaderBoard.rowHeight = UITableViewAutomaticDimension;
        
        let attrs = [NSUnderlineStyleAttributeName : 1]
        
        var attributedString = NSMutableAttributedString(string:"")
        var buttonTitleStr = NSMutableAttributedString(string:"Game #", attributes:attrs)
        attributedString.append(buttonTitleStr)
        btnGame.setAttributedTitle(attributedString, for: .normal)

        attributedString = NSMutableAttributedString(string:"")
        buttonTitleStr = NSMutableAttributedString(string:"All Time", attributes:attrs)
        attributedString.append(buttonTitleStr)
        btnAllTime.setAttributedTitle(attributedString, for: .normal)

        attributedString = NSMutableAttributedString(string:"")
        buttonTitleStr = NSMutableAttributedString(string:"Category", attributes:attrs)
        attributedString.append(buttonTitleStr)
        btnCategory.setAttributedTitle(attributedString, for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.LeaderVCHeader(_:)), name: NSNotification.Name(rawValue: "LeaderVCHeader"), object: nil)
        
        //Default We need to load data of battle wins
        btnSelectCategory1.isSelected = true
        strTypetoFileteLeaderBoard = "LAST_BID"
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        txtGameClock.text = appDelegate.strGameClockTime
        txtDoomdsDayClock.text = appDelegate.strDoomdsDayClock
        appDelegate.iScreenIndex = 3
        
        self.getLeaderBoardData()
    }

    //MARK: App Header
    func LeaderVCHeader(_ notification: Notification)
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
    
    //MARK: Select Category
    @IBAction func btnselectCategoryAction(sender : UIButton)
    {
        /*
         LONGEST_BID         = Descending by longest bid duration
         LAST_BID                 = Descending by last bid duration
         TOTAL_WINS            = Descending by total wins
         LONGEST_STREAK = Descending by longest streak
         */
        switch sender.tag
        {
        case 1:
            btnSelectCategory1.isSelected = true
            btnSelectCategory2.isSelected = false
            btnSelectCategory3.isSelected = false
            btnSelectCategory4.isSelected = false
            strTypetoFileteLeaderBoard = "LONGEST_BID"

            break
        case 2:
            btnSelectCategory1.isSelected = false
            btnSelectCategory2.isSelected = true
            btnSelectCategory3.isSelected = false
            btnSelectCategory4.isSelected = false
            strTypetoFileteLeaderBoard = "TOTAL_WINS"
            break
        case 3:
            btnSelectCategory1.isSelected = false
            btnSelectCategory2.isSelected = false
            btnSelectCategory3.isSelected = true
            btnSelectCategory4.isSelected = false
            strTypetoFileteLeaderBoard = "LAST_BID"
            break
        case 4:
            btnSelectCategory1.isSelected = false
            btnSelectCategory2.isSelected = false
            btnSelectCategory3.isSelected = false
            btnSelectCategory4.isSelected = true
            strTypetoFileteLeaderBoard = "LONGEST_STREAK"
            break
        default:
            break
        }
    }
    
    @IBAction func btnSelectCategorytoFilterData(_ sender : UIButton)
    {
        vwSelectCategory.isHidden = false
    }
    
    @IBAction func btnCategoryViewSelected(_ sender : UIButton)
    {
        vwSelectCategory.isHidden = true
    }
    
    @IBAction func btnSelectCategoryViewCancelled(_ sender : UIButton)
    {
        vwSelectCategory.isHidden = true
        self.getLeaderBoardData()
    }


    func getLeaderBoardData()
    {
        let token = "\(appDelegate.arrLoginData["token"]!)"
        let headers = ["Authorization":"Bearer \(token)"]
        
        showProgress(inView: self.view)
        request("\(kServerURL)api/leaderboard?type=\(strTypetoFileteLeaderBoard)", method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    if let json = response.result.value
                    {
                        let dictemp = json as! NSDictionary
                        print("dictemp/user/leaderboard :> \(dictemp)")
                        
                        if dictemp.count > 0
                        {
                            if  let arrTemp = dictemp["data"] as? NSArray
                            {
                                self.arrCategoryData = NSMutableArray(array: arrTemp)
                                self.tblLeaderBoard.reloadData()
                            }
                            else
                            {
                                App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                            }
                        }
                        else
                        {
                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                        }
                    }
                }
                break
                
            case .failure(_):
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
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

extension LeaderVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrCategoryData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderCell") as! LeaderCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}

class LeaderCell: UITableViewCell
{
}

