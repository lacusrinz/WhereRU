//
//  FollowingViewController.swift
//  WhereRU
//
//  Created by RInz on 14/11/3.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class FollowingViewController: UIViewController, SWTableViewCellDelegate, AddFollowingViewControllerDelegate {

    @IBOutlet weak var followingTableView: UITableView!
    
    var tableData = [AVUser]()
    var myFriendsObj:AVObject?
    var myFriends:[AVUser]?
    var list:[AnyObject]?
    
    private var documentPath:String?
    
    private var emptyMessageLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as? [String : AnyObject]

        self.followingTableView.backgroundColor = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        self.followingTableView.tableFooterView = UIView()
        self.followingTableView.delegate = self
        self.followingTableView.dataSource = self
        
        self.tabBarController?.tabBar.translucent = false
        self.navigationController?.navigationBar.translucent = false
        
//        self.followingTableView.addLegendHeaderWithRefreshingTarget(self, refreshingAction: "updateFellowing")
//        self.followingTableView.header.beginRefreshing()
        
        self.emptyMessageLabel = UILabel(frame: CGRectMake(0, self.followingTableView.frame.origin.y/2-5, self.followingTableView.frame.width, 10))
        self.emptyMessageLabel!.text = "点击右上角按钮，快去添加好友吧！"
        self.emptyMessageLabel!.numberOfLines = 2
        self.emptyMessageLabel!.textAlignment = NSTextAlignment.Center
        self.emptyMessageLabel!.textColor = UIColor.redColor()
        
        documentPath = Utility.filePath("friends.plist")
        
//        var fileManage:NSFileManager = NSFileManager()
//        if fileManage.fileExistsAtPath(documentPath!) {
//            var allObjs:[NSDictionary] = NSKeyedUnarchiver.unarchiveObjectWithFile(documentPath!) as! [NSDictionary]
//            var allFriends = [AVUser]()
//            for allObj in allObjs {
//                var obj:AVUser = AVUser()
//                obj.objectFromDictionary(allObj as [NSObject : AnyObject])
//                allFriends.append(obj)
//            }
//            self.myFriends = allFriends
//            self.tableData = allFriends
//        }
        
        self.list = [AnyObject]()
        let theCollation: UILocalizedIndexedCollation = UILocalizedIndexedCollation.currentCollation()
        
        var temp: [ChineseNameIndex] = Array()
        var nameArray: [String] = ["Jone白飞","andy Lili","张冲","林峰","kylin","王磊","emily","陈标","billy","韦丽"]
        
        for var i: Int = 0; i < nameArray.count; ++i {
            let item: ChineseNameIndex = ChineseNameIndex()
            item.name = nameArray[i]
            item.lastName = (nameArray[i] as NSString).substringToIndex(1)
            item.originIndex = i
            temp.append(item)
        }
        
        for item: ChineseNameIndex in temp {
            let sect: Int = theCollation.sectionForObject(item, collationStringSelector: "getName")
            item.sectionNum = sect
        }

        let highSection = theCollation.sectionTitles.count
        var sectionArrays = [[ChineseNameIndex]]()
        for var i: Int = 0; i <= highSection; ++i {
            let sectionArray: [ChineseNameIndex] = Array()
            sectionArrays.append(sectionArray)
        }
        for item: ChineseNameIndex in temp {
            sectionArrays[item.sectionNum].append(item)
        }
        for sectionArray: [ChineseNameIndex] in sectionArrays {
            let sortedSection = theCollation.sortedArrayFromArray(sectionArray, collationStringSelector: "getName")
            self.list!.append(sortedSection)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        //
    }
    
    func updateFellowing() {
//        var allObjs:Array = [NSDictionary]()
//        var query = AVQuery(className: "Friends")
//        query.whereKey("from", equalTo: AVUser.currentUser())
//        query.findObjectsInBackgroundWithBlock { (obj:[AnyObject]!, error:NSError!) -> Void in
//            if (error == nil && obj.count > 0) {
//                self.myFriendsObj = (obj as! [AVObject])[0] as AVObject
//                var relation:AVRelation = (obj as! [AVObject])[0].objectForKey("to") as! AVRelation
//                var query = relation.query()
//                query.findObjectsInBackgroundWithBlock({ (friends:[AnyObject]!, error:NSError!) -> Void in
//                    if error == nil && friends.count > 0 {
//                        self.myFriends = friends as? [AVUser]
//                        self.tableData = friends as! [AVUser]
//                        self.tableView.reloadData()
//                        
//                        for friend:AVUser in self.myFriends! {
//                            allObjs.append(friend.dictionaryForObject())
//                        }
//                        NSKeyedArchiver.archiveRootObject(allObjs, toFile: self.documentPath!)
//                    }
//                })
//            } else {
//                TSMessage.showNotificationInViewController(self, title: "错误", subtitle: "断网啦", type:TSMessageNotificationType.Error)
//                self.myFriendsObj = nil
//            }
//        }
//        self.tableView.header.endRefreshing()
    }
    
    func rightButtons()->NSArray{
        let rightUtilityButtons:NSMutableArray = NSMutableArray()
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "删除好友")
        return rightUtilityButtons
    }  
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        let selectedRowNumber = self.followingTableView.indexPathForCell(cell)!.row
        let deletedFriend:AVUser = self.tableData[selectedRowNumber] as AVUser
        let toRelation:AVRelation = myFriendsObj!.relationforKey("to")
        toRelation.removeObject(deletedFriend)
        myFriendsObj!.saveInBackgroundWithBlock { (success:Bool, error:NSError!) -> Void in
            if success == true {
                self.tableData.removeAtIndex(selectedRowNumber)
                self.followingTableView.reloadData()
            }
        }
    }
    
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    // MARK: - AddFollowingViewControllerDelegate
    func AddFollowingViewControllerBack(controller: AddFollowingViewController) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            self.followingTableView.mj_header.beginRefreshing()
        })
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addFriends"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let addFollowingViewController = navigationController.viewControllers[0] as! AddFollowingViewController
            addFollowingViewController.delegate = self
            addFollowingViewController.myFriendsObj = self.myFriendsObj
            addFollowingViewController.friends = self.myFriends
        }
    }

}

extension FollowingViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(!tableView.editing) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        var existTitles = [String]()
        var allTitles = UILocalizedIndexedCollation.currentCollation().sectionIndexTitles
        for var i: Int = 0; i < allTitles.count; ++i {
            if (self.list?[i].count > 0) {
                existTitles.append(allTitles[i])
            }
        }
        return existTitles
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.list![section].count > 0) {
            return UILocalizedIndexedCollation.currentCollation().sectionTitles[section]
        }
        return nil
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index)
    }
}

extension FollowingViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView)->NSInteger{
        return self.list!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list![section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.followingTableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "userCell")
        let cell:UserCell = self.followingTableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! UserCell
        cell.name.text = "\(((self.list![indexPath.section] as! [AnyObject])[indexPath.row] as! ChineseNameIndex).name!)"
        return cell
    }
}
