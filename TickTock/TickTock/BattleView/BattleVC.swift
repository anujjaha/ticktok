//
//  BattleVC.swift
//  TickTock
//
//  Created by Yash on 26/03/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class BattleVC: UIViewController
{
    @IBOutlet weak var vwJoinBattle : UIView!
    @IBOutlet weak var vwBattleList : UIView!
    @IBOutlet weak var tblBattleBoard : UITableView!
    @IBOutlet weak var vwBattleGame : UIView!

    @IBOutlet weak var vwBattleGame1 : UIView!
    @IBOutlet weak var vwBattleGame2 : UIView!
    @IBOutlet weak var vwBattleGame3 : UIView!
    @IBOutlet weak var vwBattleGame4 : UIView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        vwBattleList.isHidden = true
        vwBattleGame.isHidden = true
        vwJoinBattle.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
        
        self.tblBattleBoard.estimatedRowHeight = 60.0 ;
        self.tblBattleBoard.rowHeight = UITableViewAutomaticDimension
        
        self.vwBattleGame1.layer.borderWidth = 1.0
        self.vwBattleGame1.layer.borderColor = UIColor.black.cgColor

        self.vwBattleGame2.layer.borderWidth = 1.0
        self.vwBattleGame2.layer.borderColor = UIColor.black.cgColor
 
        self.vwBattleGame3.layer.borderWidth = 1.0
        self.vwBattleGame3.layer.borderColor = UIColor.black.cgColor
        
        self.vwBattleGame4.layer.borderWidth = 1.0
        self.vwBattleGame4.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func JoinBattleButtonPressed()
    {
        vwJoinBattle.isHidden = true
        vwBattleList.isHidden = false
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

extension BattleVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BattleCell") as! BattleCell
        cell.lblLevel.text = "Level \(indexPath.row+1)"
        
        if (indexPath.row > 0)
        {
            cell.imgLock.isHidden = false
        }
        else
        {
            cell.imgLock.isHidden = true
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        vwBattleList.isHidden = true
        vwBattleGame.isHidden = false
    }
}
class BattleCell: UITableViewCell
{
    @IBOutlet weak var lblLevel : UILabel!
    @IBOutlet weak var imgLock : UIImageView!
}
