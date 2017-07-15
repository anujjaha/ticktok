//
//  SettingsVC.swift
//  TickTock
//
//  Created by Yash on 26/03/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController
{
    var arrSettings = NSMutableArray()
    @IBOutlet weak var tblSetting: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblSetting.estimatedRowHeight = 47.0 ;
        self.tblSetting.rowHeight = UITableViewAutomaticDimension;
        
        var dictemp = NSMutableDictionary()
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
        
        tblSetting.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
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
}

