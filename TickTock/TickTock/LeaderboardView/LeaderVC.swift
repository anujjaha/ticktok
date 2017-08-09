
//
//  LeaderVC.swift
//  TickTock
//
//  Created by Yash on 26/03/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class LeaderVC: UIViewController {

    @IBOutlet weak var tblLeaderBoard : UITableView!
    @IBOutlet weak var btnGame : UIButton!
    @IBOutlet weak var btnAllTime : UIButton!
    @IBOutlet weak var btnCategory : UIButton!

    @IBOutlet weak var txtGameClock: UITextField!
    @IBOutlet weak var txtDoomdsDayClock: UITextField!

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
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        txtGameClock.text = appDelegate.strGameClockTime
        txtDoomdsDayClock.text = appDelegate.strDoomdsDayClock
        

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
        return 10
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

