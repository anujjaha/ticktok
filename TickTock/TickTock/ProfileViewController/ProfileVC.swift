//
//  ProfileVC.swift
//  TickTock
//
//  Created by Yash on 26/03/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController
{
    @IBOutlet weak var vwProfile : UIView!
    @IBOutlet weak var vwGameState : UIView!
    @IBOutlet weak var segmentPG : UISegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        vwProfile.isHidden = false
        vwGameState.isHidden = true
        
        segmentPG.setFontSize(fontSize: 16)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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

