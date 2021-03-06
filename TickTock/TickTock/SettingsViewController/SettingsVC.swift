//
//  SettingsVC.swift
//  TickTock
//
//  Created by Kevin on 26/03/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController
{
    var arrSettings = NSMutableArray()
    @IBOutlet weak var tblSetting: UITableView!
    
    @IBOutlet weak var txtGameClock: UITextField!
    @IBOutlet weak var txtDoomdsDayClock: UITextField!
    @IBOutlet weak var txtJackpotAmount: UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblSetting.estimatedRowHeight = 47.0 ;
        self.tblSetting.rowHeight = UITableViewAutomaticDimension;
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SettingsVCHeader(_:)), name: NSNotification.Name(rawValue: "SettingsVCHeader"), object: nil)

    }
    //MARK: App Header
    func SettingsVCHeader(_ notification: Notification)
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

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        appDelegate.iScreenIndex = 5

        self.navigationController?.isNavigationBarHidden = true
        txtGameClock.text = appDelegate.strGameClockTime
        txtDoomdsDayClock.text = appDelegate.strDoomdsDayClock
        
        arrSettings = NSMutableArray()
        var dictemp = NSMutableDictionary()
        if appDelegate.bShowQuitGameButton == true
        {
            for index in 0..<5
            {
                switch index
                {
                case 0:
                    dictemp = NSMutableDictionary()
                    dictemp.setValue("Privacy Policy", forKey:kkeyname)
                    dictemp.setValue("privacy_icon", forKey:kkeyimage)
                    break
                case 1:
                    dictemp = NSMutableDictionary()
                    dictemp.setValue("Push Notification", forKey:kkeyname)
                    dictemp.setValue("notification_icon", forKey:kkeyimage)
                    break
                case 2:
                    dictemp = NSMutableDictionary()
                    dictemp.setValue("FAQ", forKey:kkeyname)
                    dictemp.setValue("faq_icon", forKey:kkeyimage)
                    break
                case 3:
                    dictemp = NSMutableDictionary()
                    dictemp.setValue("Log Out", forKey:kkeyname)
                    dictemp.setValue("logout_icon", forKey:kkeyimage)
                    break
                case 4:
                    dictemp = NSMutableDictionary()
                    dictemp.setValue("Quit Game", forKey:kkeyname)
                    dictemp.setValue("quit_game_icon", forKey:kkeyimage)
                    break
                    
                default:
                    break
                }
                arrSettings.add(dictemp)
            }
        }
        else
        {
            for index in 0..<4
            {
                switch index
                {
                case 0:
                    dictemp = NSMutableDictionary()
                    dictemp.setValue("Privacy Policy", forKey:kkeyname)
                    dictemp.setValue("privacy_icon", forKey:kkeyimage)
                    break
                case 1:
                    dictemp = NSMutableDictionary()
                    dictemp.setValue("Push Notification", forKey:kkeyname)
                    dictemp.setValue("notification_icon", forKey:kkeyimage)
                    break
                case 2:
                    dictemp = NSMutableDictionary()
                    dictemp.setValue("FAQ", forKey:kkeyname)
                    dictemp.setValue("faq_icon", forKey:kkeyimage)
                    break
                case 3:
                    dictemp = NSMutableDictionary()
                    dictemp.setValue("Log Out", forKey:kkeyname)
                    dictemp.setValue("logout_icon", forKey:kkeyimage)
                    break
                    
                default:
                    break
                }
                arrSettings.add(dictemp)
            }
        }
        tblSetting.reloadData()
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
extension SettingsVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrSettings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
        cell.lblName.text = (self.arrSettings[indexPath.row] as AnyObject).object(forKey: kkeyname) as? String
        cell.imgIcon.image = UIImage(named: ((self.arrSettings[indexPath.row] as AnyObject).object(forKey: kkeyimage) as? String)!)
        
        if indexPath.row == 1 {
            cell.imgArrow.isHidden = true
            cell.swpush.isHidden = false
        }
        else
        {
            cell.imgArrow.isHidden = false
            cell.swpush.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 1
        {
            return 45
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
        case 0:
            let storyTab = UIStoryboard(name: "Main", bundle: nil)
            let objPrivacyVC = storyTab.instantiateViewController(withIdentifier: "PrivacyVC") as! PrivacyVC
            objPrivacyVC.iPrivacy = 1
            self.navigationController?.pushViewController(objPrivacyVC, animated: true)
            break
        case 2:
            let storyTab = UIStoryboard(name: "Main", bundle: nil)
            let objPrivacyVC = storyTab.instantiateViewController(withIdentifier: "PrivacyVC") as! PrivacyVC
            objPrivacyVC.iPrivacy = 2
            self.navigationController?.pushViewController(objPrivacyVC, animated: true)
            break
        case 3:
            UserDefaults.standard.set("", forKey: kkeyLoginData)
            UserDefaults.standard.set(false, forKey: kkeyisUserLogin)
            SocketIOManager.sharedInstance.closeConnection()

            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let nav = UINavigationController(rootViewController: homeViewController)
            nav.isNavigationBarHidden = true
            appdelegate.window!.rootViewController = nav
            break
        case 4:
            let myJSON = [
                "userId": "\(appDelegate.arrLoginData[kkeyuser_id]!)",
                "jackpotUniqueId" : appDelegate.strGameJackpotID
            ]
            
            //  print("data:>\(myJSON)")
            SocketIOManager.sharedInstance.socket.emitWithAck("quit_jackpot_game",  myJSON).timingOut(after: 0) {data in
                if (data.count > 0)
                {
                    print("data:>\(data)")
//                    App_showAlert(withMessage: ((data[0] as? NSDictionary)!.object(forKey: "body") as! NSDictionary).object(forKey: "message") as! String, inView: self)
                    
                    self.tabBarController?.selectedIndex = 0
                }
            }

            break

        default:
            break
        }
        
        /*
        if indexPath.row == 3
        {
            UserDefaults.standard.set("", forKey: kkeyLoginData)
            UserDefaults.standard.set(false, forKey: kkeyisUserLogin)
            
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let nav = UINavigationController(rootViewController: homeViewController)
            nav.isNavigationBarHidden = true
            appdelegate.window!.rootViewController = nav
        }
         */
    }
}
class SettingsCell: UITableViewCell
{
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var imgIcon : UIImageView!
    @IBOutlet weak var swpush : UISwitch!
    @IBOutlet weak var imgArrow : UIImageView!
}

