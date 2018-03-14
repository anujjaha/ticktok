//
//  ProfileVC.swift
//  TickTock
//
//  Created by Kevin on 26/03/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController
{
    @IBOutlet weak var vwProfile : UIView!
    @IBOutlet weak var vwGameState : UIView!
    @IBOutlet weak var segmentPG : UISegmentedControl!
    
    @IBOutlet weak var lblcareer_earnings : UILabel!
    @IBOutlet weak var lblcarrer_battle_wins : UILabel!
    @IBOutlet weak var lblcurrent_battle_streak : UILabel!
    @IBOutlet weak var lbllongest_battle_streak : UILabel!
    @IBOutlet weak var lbllongest_bid : UILabel!
    
    @IBOutlet weak var lblname : UILabel!
    @IBOutlet weak var lblgender : UILabel!
    @IBOutlet weak var lbldob : UILabel!
    @IBOutlet weak var lblcountry : UILabel!
    @IBOutlet weak var lblEmail : UILabel!

    @IBOutlet weak var txtGameClock: UITextField!
    @IBOutlet weak var txtDoomdsDayClock: UITextField!
    @IBOutlet weak var txtJackpotAmount: UITextField!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblWalletBallance: UILabel!
    
    @IBOutlet weak var imgUserProfile: UIImageView!


    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        vwProfile.isHidden = false
        vwGameState.isHidden = true
        
        segmentPG.setFontSize(fontSize: 16)

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.ProfileVCHeader(_:)), name: NSNotification.Name(rawValue: "ProfileVCHeader"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        txtGameClock.text = appDelegate.strGameClockTime
        txtDoomdsDayClock.text = appDelegate.strDoomdsDayClock
        appDelegate.iScreenIndex = 4
        self.getProfileData()
    }
    
    //MARK: btn Edit Profile
    @IBAction func btnEditProfileAction()
    {
    }
    
    //MARK: App Header
    func ProfileVCHeader(_ notification: Notification)
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

    func getProfileData()
    {
        let token = "\(appDelegate.arrLoginData["token"]!)"
        let headers = ["Authorization":"Bearer \(token)"]

        
        showProgress(inView: self.view)
        request("\(kServerURL)api/me/profile", method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value)
                    
                    if let json = response.result.value
                    {
                        let dictemp = json as! NSDictionary
                        print("dictemp/user/profile :> \(dictemp)")
                        
                        if dictemp.count > 0
                        {
                            if  let dictemp2 = dictemp["data"] as? NSDictionary
                            {
                                if (dictemp2.count > 0)
                                {
                                    self.lblcareer_earnings.text = "\(dictemp2["careerEarnings"]!)"
                                    self.lblcarrer_battle_wins.text = "\(dictemp2["careerBattleWins"]!)"
//                                    self.lblcurrent_battle_streak.text = "\((dictemp2["game"] as! NSDictionary).value(forKey: "current_battle_streak")!)"
                                    self.lbllongest_battle_streak.text = "\(dictemp2["longestBattleStreak"]!)"
                                    self.lbllongest_bid.text = "\(dictemp2["longestBids"]!)"
                                    
                                    self.lblname.text = "\(dictemp2["name"]!)"
                                    
                                    if let strbirthDate = dictemp2["birthDate"] as? String
                                    {
                                          self.lbldob.text = strbirthDate
                                    }
                                    else
                                    {
                                        self.lbldob.text = ""
                                    }
                                    
                                    if let strGender = dictemp2["gender"] as? String
                                    {
                                            self.lblgender.text = strGender
                                    }
                                    else
                                    {
                                        self.lblgender.text = ""
                                    }
                                    
//                                    self.lblcountry.text = "\((dictemp2["personal"] as! NSDictionary).value(forKey: "country")!)"
                                    self.lblEmail.text = "\(dictemp2["email"]!)"
                                    
                                    self.lblUsername.text = "\(dictemp2["username"]!)"
                                    self.lblWalletBallance.text = "\(dictemp2["walletBalance"]!)"
                                    
                                    if let strimageLink = dictemp2.value(forKey: "photo")
                                    {
                                        let strURL : String = (strimageLink as AnyObject).replacingOccurrences(of: " ", with: "%20")
                                        let url2 = URL(string: strURL)
                                        if url2 != nil {
                                            self.imgUserProfile.sd_setImage(with: url2, placeholderImage: UIImage(named: "profile_pic"))
                                        }
                                    }
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
                        else
                        {
                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                        }
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }
    
    
    @IBAction func indexChanged(sender : UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
        case 0:
            vwProfile.isHidden = false
            vwGameState.isHidden = true
        case 1:
            vwProfile.isHidden = true
            vwGameState.isHidden = false
        default:
            break;
        }  //Switch
    } // indexChanged for the Segmented Control
    
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

extension UISegmentedControl {
    
    func setFontSize(fontSize: CGFloat)
    {
        let boldTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName as NSObject : UIColor.black,
            NSFontAttributeName as NSObject : UIFont.init(name: "Lato", size: fontSize)!,
            ]
        
        self.setTitleTextAttributes(boldTextAttributes, for: .normal)
        self.setTitleTextAttributes(boldTextAttributes, for: .highlighted)
        self.setTitleTextAttributes(boldTextAttributes, for: .selected)
    }
}

