//
//  MenuViewController.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/4.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userAvatarImageView: avatarImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        
        self.menuTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "menuCell"
        let cell:MenuTableViewCell = self.menuTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MenuTableViewCell
        
        if indexPath.row == 0 {
            cell.menuImage.image = UIImage(named:"Icon_home")
            cell.menuName.text = "今 天"
            cell.nemuNumber.text = "3"
        }else if indexPath.row == 1 {
            cell.menuImage.image = UIImage(named:"Icon_calendar")
            cell.menuName.text = "日 程"
        }else if indexPath.row == 2 {
            cell.menuImage.image = UIImage(named:"Icon_followee")
            cell.menuName.text = "关 注"
            cell.nemuNumber.text = "123"
        }else if indexPath.row == 3 {
            cell.menuImage.image = UIImage(named:"Icon_follower")
            cell.menuName.text = "被 关 注"
            cell.nemuNumber.text = "5200"
        }else if indexPath.row == 4 {
            cell.menuImage.image = UIImage(named:"Icon_profile")
            cell.menuName.text = "我"
        }else if indexPath.row == 5 {
            cell.menuImage.image = UIImage(named:"Icon_setting")
            cell.menuName.text = "设 置"
        }else if indexPath.row == 6 {
            cell.menuImage.image = UIImage(named:"Icon_logout")
            cell.menuName.text = "登 出"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
