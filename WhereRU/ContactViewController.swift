//
//  ContactViewController.swift
//  WhereRU
//
//  Created by RInz on 14/11/3.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class ContactViewController: UITableViewController, SWTableViewCellDelegate, YALTabBarInteracting {

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
        //todo
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
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
