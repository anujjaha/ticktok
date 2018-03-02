//
//  PrivacyVC.swift
//  TickTock
//
//  Created by Kevin on 07/06/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class PrivacyVC: UIViewController
{
    @IBOutlet weak var wvPrivacy : UIWebView!
    var iPrivacy = Int()
    @IBOutlet weak var lblTitlofScreen: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        wvPrivacy.isOpaque = false
//        wvPrivacy.backgroundColor = UIColor.clear

        if (iPrivacy == 1)
        {
            lblTitlofScreen.text = "Privacy Policy"
            showProgress(inView: self.view)
            request("\(kServerURL)api/privacy-policy", method: .get, parameters:nil).responseJSON { (response:DataResponse<Any>) in
                
                hideProgress()
                switch(response.result)
                {
                case .success(_):
                    if response.result.value != nil
                    {
                        print(response.result.value)
                        if let json = response.result.value
                        {
                            print("json :> \(json)")
                            
                            let dictemp = json as! NSDictionary
                            print("dictemp :> \(dictemp)")
                            
                            if dictemp.count > 0
                            {
                                self.wvPrivacy.loadHTMLString(dictemp["data"] as! String, baseURL: nil)
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
            /*
             let url = NSURL (string: kPrivacyURL)
             let requestObj = NSURLRequest(url: url! as URL);
             wvPrivacy.loadRequest(requestObj as URLRequest)*/
        }
        else
        {
            lblTitlofScreen.text = "FAQ"
            showProgress(inView: self.view)
            request("\(kServerURL)api/faq", method: .get, parameters:nil).responseJSON { (response:DataResponse<Any>) in
                
                hideProgress()
                switch(response.result)
                {
                case .success(_):
                    if response.result.value != nil
                    {
                        print(response.result.value)
                        if let json = response.result.value
                        {
                            print("json :> \(json)")
                            
                            let dictemp = json as! NSDictionary
                            print("dictemp :> \(dictemp)")
                            
                            if dictemp.count > 0
                            {
                                self.wvPrivacy.loadHTMLString(dictemp["data"] as! String, baseURL: nil)
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
            
            /*
             let url = NSURL (string: kFAQURL)
             let requestObj = NSURLRequest(url: url! as URL);
             wvPrivacy.loadRequest(requestObj as URLRequest)*/
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    //MARK : Action
    @IBAction func btnBackPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning()
    {
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
