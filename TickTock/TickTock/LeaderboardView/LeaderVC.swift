
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
    @IBOutlet weak var btnCategroyName : UIButton!

    @IBOutlet weak var vwSelectGame: UIView!
    @IBOutlet weak var tblSelectGame: UITableView!
    var arrGameData = NSMutableArray()
    @IBOutlet weak var btnGameName : UIButton!
    var strGameTitle = String()

    var arrCategoryData = NSMutableArray()
    var strTypetoFileteLeaderBoard = String()
    var strSelectedGameIDtoFilterLeaderBoard = String()
    var arrGameSelected = NSMutableArray()

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
        strTypetoFileteLeaderBoard = "LONGEST_STREAK"
        btnGameName.setTitle("", for: .normal)
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
            strTypetoFileteLeaderBoard = "LONGEST_STREAK"
            btnCategroyName.setTitle("Battle Streak", for: .normal)
            break
        case 2:
            btnSelectCategory1.isSelected = false
            btnSelectCategory2.isSelected = true
            btnSelectCategory3.isSelected = false
            btnSelectCategory4.isSelected = false
            strTypetoFileteLeaderBoard = "TOTAL_WINS"
            btnCategroyName.setTitle("Battle Wins", for: .normal)
            break
        case 3:
            btnSelectCategory1.isSelected = false
            btnSelectCategory2.isSelected = false
            btnSelectCategory3.isSelected = true
            btnSelectCategory4.isSelected = false
            strTypetoFileteLeaderBoard = "LONGEST_BID"
            btnCategroyName.setTitle("Longest Bid Duration", for: .normal)
            break
        case 4:
            btnSelectCategory1.isSelected = false
            btnSelectCategory2.isSelected = false
            btnSelectCategory3.isSelected = false
            btnSelectCategory4.isSelected = true
            strTypetoFileteLeaderBoard = "LAST_BID"
            btnCategroyName.setTitle("Last Bid Duration", for: .normal)
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
        self.getLeaderBoardData()
    }
    
    @IBAction func btnSelectCategoryViewCancelled(_ sender : UIButton)
    {
        vwSelectCategory.isHidden = true
    }

    //MARK : Select Game Actions
    @IBAction func btnGameSelectCalled(_ sender : UIButton)
    {
        btnGameName.setTitle(strGameTitle, for: .normal)

        if (self.strSelectedGameIDtoFilterLeaderBoard.isEmpty)
        {
            App_showAlert(withMessage: "Please select game", inView: self)
        }
        else
        {
            vwSelectGame.isHidden = true
            self.getLeaderBoardData()
        }
    }
    
    @IBAction func btnAddGameView(_ sender : UIButton)
    {
        self.loadJackpotGameData()
    }
    
    @IBAction func btnGameCancelled(_ sender : UIButton)
    {
        strGameTitle = ""
        btnGameName.setTitle(strGameTitle, for: .normal)
        strSelectedGameIDtoFilterLeaderBoard = ""
        vwSelectGame.isHidden = true
        self.getLeaderBoardData()
    }
    @IBAction func btnAllTimeCalled(_ sender : UIButton)
    {
        strSelectedGameIDtoFilterLeaderBoard = ""
        strGameTitle = ""
        btnGameName.setTitle(strGameTitle, for: .normal)
        self.getLeaderBoardData()
    }

    func loadJackpotGameData()
    {
        //http://18.221.196.29:9000/api/jackpots/dropdown
        let token = "\(appDelegate.arrLoginData["token"]!)"
        let headers = ["Authorization":"Bearer \(token)"]
        
        showProgress(inView: self.view)
        request("\(kServerURL)api/jackpots/dropdown", method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
                        print("api/jackpots/dropdown :> \(dictemp)")
                        
                        if dictemp.count > 0
                        {
                            if  let arrTemp = dictemp["data"] as? NSArray
                            {
                                self.vwSelectGame.isHidden = false
                                self.arrGameData = NSMutableArray(array: arrTemp)
                                
                                for _ in 0..<self.arrGameData.count
                                {
                                    self.arrGameSelected.add(kNO)
                                }
                                self.tblSelectGame.reloadData()
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
    

    func getLeaderBoardData()
    {
        let token = "\(appDelegate.arrLoginData["token"]!)"
        let headers = ["Authorization":"Bearer \(token)"]
        
        var strRequestString = String()
        if (self.strSelectedGameIDtoFilterLeaderBoard.isEmpty)
        {
            strRequestString = "\(kServerURL)api/leaderboard?type=\(strTypetoFileteLeaderBoard)"
        }
        else
        {
            //18.221.196.29:9000/api/leaderboard?jackpot_id=2&type=LAST_BID
            strRequestString = "\(kServerURL)api/leaderboard?jackpot_id=\(strSelectedGameIDtoFilterLeaderBoard)&type=\(strTypetoFileteLeaderBoard)"
        }
        
        showProgress(inView: self.view)
        request(strRequestString, method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
    
    @IBAction func GameSelect(_ sender: Any, event: Any)
    {
        let touches = (event as AnyObject).allTouches!
        let touch = touches?.first!
        let currentTouchPosition = touch?.location(in: self.tblSelectGame)
        var indexPath = self.tblSelectGame.indexPathForRow(at: currentTouchPosition!)!
        
        self.arrGameSelected = NSMutableArray()
        for _ in 0..<self.arrGameData.count
        {
            self.arrGameSelected.add(kNO)
        }
        
        self.strSelectedGameIDtoFilterLeaderBoard = ""
        strGameTitle = ""
        
        if self.arrGameSelected[indexPath.row] as! String == kNO
        {
            self.arrGameSelected.replaceObject(at: indexPath.row, with: kYES)
            let dictofData = arrGameData[indexPath.row] as! NSDictionary
            self.strSelectedGameIDtoFilterLeaderBoard = "\(dictofData["id"]!)"
            self.strGameTitle = "\(dictofData["title"]!)"
        }
        else
        {
            self.arrGameSelected.replaceObject(at: indexPath.row, with: kNO)
        }
        
        tblSelectGame.reloadData()
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
        if tableView == tblSelectGame
        {
             return arrGameData.count
        }
        return arrCategoryData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var mainCell  = UITableViewCell()
        if tableView == tblSelectGame
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameCell
            /*
                "id": 4,
                "title": "Test Battle #1",
                "uniqueId": "EGES1NU69byBSNIhxp8s",
                "amount": 100
            */
            let dictofData = arrGameData[indexPath.row] as! NSDictionary
            cell.lblGameTitle.text = "\(dictofData["title"]!)"
            cell.btnGameSelect.addTarget(self, action: #selector(self.GameSelect(_:event:)), for: .touchUpInside)
            cell.btnGameSelect.tag = indexPath.row
            
            if self.arrGameSelected[indexPath.row] as! String == kNO
            {
                cell.btnGameSelect.isSelected = false
            }
            else
            {
                cell.btnGameSelect.isSelected = true
            }
            
            mainCell = cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderCell") as! LeaderCell
            
            let dictofData = arrCategoryData[indexPath.row] as! NSDictionary
            
            cell.lblUsername.text = "\(dictofData["username"]!)"
            cell.lblScore.text = "\(dictofData["score"]!)"
            cell.lblRank.text = "\(dictofData["rank"]!)"
            
            if let strimageLink = dictofData.value(forKey: "photo")
            {
                let strURL : String = (strimageLink as AnyObject).replacingOccurrences(of: " ", with: "%20")
                let url2 = URL(string: strURL)
                if url2 != nil {
                    cell.imgProfile.sd_setImage(with: url2, placeholderImage: UIImage(named: "profile_pic"))
                }
            }
            mainCell = cell
        }
        mainCell.preservesSuperviewLayoutMargins = false
        mainCell.separatorInset = UIEdgeInsets.zero
        mainCell.layoutMargins = UIEdgeInsets.zero
        return mainCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}

class LeaderCell: UITableViewCell
{
    @IBOutlet weak var lblScore : UILabel!
    @IBOutlet weak var lblRank : UILabel!
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var lblUsername : UILabel!
}
class GameCell: UITableViewCell
{
    @IBOutlet weak var lblGameTitle : UILabel!
    @IBOutlet weak var btnGameSelect : UIButton!
}

