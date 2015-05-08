//
//  ContactViewController.swift
//  WhereRU
//
//  Created by RInz on 14/11/3.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class ContactViewController: UITableViewController, SWTableViewCellDelegate, YALTabBarInteracting, AddContactViewControllerDelegate {

    var tableData = [AVUser]()
    var rowsCount:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]
        
        var query = AVQuery(className: "Friends")
        query.whereKey("from", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (obj:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil && obj.count > 0) {
                var relation:AVRelation = (obj as! [AVObject])[0].objectForKey("to") as! AVRelation
                var query = relation.query()
                query.findObjectsInBackgroundWithBlock({ (friends:[AnyObject]!, error:NSError!) -> Void in
                    if error == nil && friends.count > 0 {
                        self.tableData = friends as! [AVUser]
                        self.rowsCount = self.tableData.count
                        self.tableView.reloadData()
                    }
                })
                
            }
        }
        
        
        self.tableView.backgroundColor = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tabBarController?.tabBar.translucent = false
        self.navigationController?.navigationBar.translucent = false
    }
    
    func rightButtons()->NSArray{
        var rightUtilityButtons:NSMutableArray = NSMutableArray()
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.greenColor(), title: "Disable")
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "Archive")
        return rightUtilityButtons
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView)->NSInteger{
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsCount
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO
        if(!tableView.editing){
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:NSString = "contactTableViewCell"
        var cell:ContactTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier as String, forIndexPath: indexPath) as! ContactTableViewCell
        
        //        cell = EventTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        cell.rightUtilityButtons = self.rightButtons() as [AnyObject]
        cell.delegate = self
        
        cell.backgroundColor  = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        cell.name.text = tableData[indexPath.row].username
        var avatarObject: AnyObject! = tableData[indexPath.row].objectForKey("avatarFile")
        if avatarObject != nil {
            var avatarData = avatarObject.getData()
            cell.avatar.image = UIImage(data: avatarData)
        }else {
            cell.avatar.image = UIImage(named: "default_avatar")
        }

        return cell
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        print("right button, index:%@",index)
    }
    
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    // MARK: - AddContactViewControllerDelegate
    func AddContactViewControllerBack(controller: AddContactViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addFriends"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let addContactViewController = navigationController.viewControllers[0] as! AddContactViewController
            addContactViewController.delegate = self
        }
    }

}
