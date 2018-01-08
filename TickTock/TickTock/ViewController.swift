//
//  ViewController.swift
//  TickTock
//
//  Created by Kevin on 23/03/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var txtUsername : UITextField!
    @IBOutlet weak var txtPassword : UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnLoginNowPressed()
    {
        /*
         "url": "http://35.154.46.190:1337/api/user/login",
         */
        
        if (self.txtUsername.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else if (self.txtPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else
        {
            let parameters = [
                "email":  "\(self.txtUsername.text!)",
                "password": "\(self.txtPassword.text!)"
            ]
            
            showProgress(inView: self.view)
            print("parameters:>\(parameters)")
            request("\(kServerURL)auth/login", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
                
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
                            print("dictemp :> \(dictemp)")
                            
                            if dictemp.count > 0
                            {
                                if  let dictemp2 = dictemp["data"] as? NSDictionary
                                {
                                    if (dictemp2.count > 0)
                                    {
                                        print("dictemp2 :> \(dictemp2)")
                                        appDelegate.arrLoginData = dictemp2
                                        
                                        let data = NSKeyedArchiver.archivedData(withRootObject: appDelegate.arrLoginData)
                                        UserDefaults.standard.set(data, forKey: kkeyLoginData)
                                        UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
                                        
                                        let storyTab = UIStoryboard(name: "Main", bundle: nil)
                                        let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
                                        self.navigationController?.pushViewController(tabbar, animated: true)
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
            
            /*request("\(kServerURL)login.php", method: .post, parameters:parameters).responseString{ response in
             debugPrint(response)
             }*/
        }
        /*let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
         let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
         self.navigationController?.pushViewController(tabbar, animated: true)*/
    }
    
    @IBAction func btnSignupPressed()
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let tabbar = storyTab.instantiateViewController(withIdentifier: "SignUpVC")
        self.navigationController?.pushViewController(tabbar, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("nextView") as NextViewController
    self.presentViewController(nextViewController, animated:true, completion:nil)*/
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat
        {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}


