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
    var myFriendsObj:AVObject?
    var myFriends:[AVUser]?
    
    private var documentPath:String?
    
    private var emptyMessageLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]

        self.tableView.backgroundColor = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tabBarController?.tabBar.translucent = false
        self.navigationController?.navigationBar.translucent = false
        
        self.tableView.addLegendHeaderWithRefreshingTarget(self, refreshingAction: "updateFriends")
        self.tableView.header.beginRefreshing()
        
        self.emptyMessageLabel = UILabel(frame: CGRectMake(0, self.tableView.frame.origin.y/2-5, self.tableView.frame.width, 10))
        self.emptyMessageLabel!.text = "点击右上角按钮，快去添加好友吧！"
        self.emptyMessageLabel!.numberOfLines = 2
        self.emptyMessageLabel!.textAlignment = NSTextAlignment.Center
        self.emptyMessageLabel!.textColor = UIColor.redColor()
        
        documentPath = Utility.filePath("friends.plist")
        
        var fileManage:NSFileManager = NSFileManager()
        if fileManage.fileExistsAtPath(documentPath!) {
            var allObjs:[NSDictionary] = NSKeyedUnarchiver.unarchiveObjectWithFile(documentPath!) as! [NSDictionary]
            var allFriends = [AVUser]()
            for allObj in allObjs {
                var obj:AVUser = AVUser()
                obj.objectFromDictionary(allObj as [NSObject : AnyObject])
                allFriends.append(obj)
            }
            self.myFriends = allFriends
            self.tableData = allFriends
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        //
    }
    
    func updateFriends() {
        var allObjs:Array = [NSDictionary]()
        var query = AVQuery(className: "Friends")
        query.whereKey("from", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (obj:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil && obj.count > 0) {
                self.myFriendsObj = (obj as! [AVObject])[0] as AVObject
                var relation:AVRelation = (obj as! [AVObject])[0].objectForKey("to") as! AVRelation
                var query = relation.query()
                query.findObjectsInBackgroundWithBlock({ (friends:[AnyObject]!, error:NSError!) -> Void in
                    if error == nil && friends.count > 0 {
                        self.myFriends = friends as? [AVUser]
                        self.tableData = friends as! [AVUser]
                        self.tableView.reloadData()
                        
                        for friend:AVUser in self.myFriends! {
                            allObjs.append(friend.dictionaryForObject())
                        }
                        NSKeyedArchiver.archiveRootObject(allObjs, toFile: self.documentPath!)
                    }
                })
            } else {
                TSMessage.showNotificationInViewController(self, title: "错误", subtitle: "断网啦", type:TSMessageNotificationType.Error)
                self.myFriendsObj = nil
            }
        }
        self.tableView.header.endRefreshing()
    }
    
    func rightButtons()->NSArray{
        var rightUtilityButtons:NSMutableArray = NSMutableArray()
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "删除好友")
        return rightUtilityButtons
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView)->NSInteger{
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableData.count == 0 {
            self.tableView.backgroundView = emptyMessageLabel
        } else {
            self.tableView.backgroundView = UIView()
        }
        return self.tableData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(!tableView.editing) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:NSString = "contactTableViewCell"
        var cell:ContactTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier as String, forIndexPath: indexPath) as! ContactTableViewCell
        cell.rightUtilityButtons = self.rightButtons() as [AnyObject]
        cell.delegate = self
        
        cell.backgroundColor  = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        cell.name.text = tableData[indexPath.row].username
        var avatarObject: AnyObject! = tableData[indexPath.row].objectForKey("avatarFile")
        if avatarObject != nil {
            var avatarData = avatarObject.getData()
            cell.avatar.image = UIImage(data: avatarData)
        } else {
            cell.avatar.image = UIImage(named: "default_avatar")
        }

        return cell
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        var selectedRowNumber = self.tableView.indexPathForCell(cell)!.row
        var deletedFriend:AVUser = self.tableData[selectedRowNumber] as AVUser
        var toRelation:AVRelation = myFriendsObj!.relationforKey("to")
        toRelation.removeObject(deletedFriend)
        myFriendsObj!.saveInBackgroundWithBlock { (success:Bool, error:NSError!) -> Void in
            if success == true {
                self.tableData.removeAtIndex(selectedRowNumber)
                self.tableView.reloadData()
            }
        }
    }
    
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    // MARK: - AddContactViewControllerDelegate
    func AddContactViewControllerBack(controller: AddContactViewController) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            self.tableView.header.beginRefreshing()
        })
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addFriends"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let addContactViewController = navigationController.viewControllers[0] as! AddContactViewController
            addContactViewController.delegate = self
            addContactViewController.myFriendsObj = self.myFriendsObj
            addContactViewController.friends = self.myFriends
        }
    }

}
