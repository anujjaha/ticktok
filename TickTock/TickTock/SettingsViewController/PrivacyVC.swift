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
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        wvPrivacy.isOpaque = false
        wvPrivacy.backgroundColor = UIColor.clear

        if (iPrivacy == 1)
        {
            let url = NSURL (string: kPrivacyURL)
            let requestObj = NSURLRequest(url: url! as URL);
            wvPrivacy.loadRequest(requestObj as URLRequest)
        }
        else
        {
            let url = NSURL (string: kFAQURL)
            let requestObj = NSURLRequest(url: url! as URL);
            wvPrivacy.loadRequest(requestObj as URLRequest)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
