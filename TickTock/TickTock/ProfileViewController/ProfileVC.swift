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

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        vwProfile.isHidden = false
        vwGameState.isHidden = true
        
        segmentPG.setFontSize(fontSize: 16)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        txtGameClock.text = appDelegate.strGameClockTime
        txtDoomdsDayClock.text = appDelegate.strDoomdsDayClock
        

      //  self.getProfileData()
    }

    func getProfileData()
    {
        let parameters = [
            "user_id":  "\(appDelegate.arrLoginData[kkeyuserid]!)"
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)user/profile", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
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
                                    self.lblcareer_earnings.text = "\((dictemp2["game"] as! NSDictionary).value(forKey: "career_earnings")!)"
                                    self.lblcarrer_battle_wins.text = "\((dictemp2["game"] as! NSDictionary).value(forKey: "carrer_battle_wins")!)"
                                    self.lblcurrent_battle_streak.text = "\((dictemp2["game"] as! NSDictionary).value(forKey: "current_battle_streak")!)"
                                    self.lbllongest_battle_streak.text = "\((dictemp2["game"] as! NSDictionary).value(forKey: "longest_battle_streak")!)"
                                    self.lbllongest_bid.text = "\((dictemp2["game"] as! NSDictionary).value(forKey: "longest_bid")!)"
                                    
                                    self.lblname.text = "\((dictemp2["personal"] as! NSDictionary).value(forKey: "name")!)"
                                    self.lbldob.text = "\((dictemp2["personal"] as! NSDictionary).value(forKey: "dob")!)"
                                    self.lblgender.text = "\((dictemp2["personal"] as! NSDictionary).value(forKey: "gender")!)"
                                    self.lblcountry.text = "\((dictemp2["personal"] as! NSDictionary).value(forKey: "country")!)"
                                    self.lblEmail.text = "\((dictemp2["personal"] as! NSDictionary).value(forKey: "email")!)"
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

