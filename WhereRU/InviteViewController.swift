//
//  InviteViewController.swift
//  WhereRU
//
//  Created by RInz on 15/2/27.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class InviteViewController: UITableViewController, SWTableViewCellDelegate, CreateEventViewControllerDelegate, ViewEventViewControllerDelegate, YALTabBarInteracting {

    private var tableData:Array<Event>?
    private var rowsCount:NSInteger = 0
    private var selectedRowNumber:Int = 0
    
    private var emptyMessageLabel:UILabel?
    
    private var documentPath:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TSMessage.setDefaultViewController(self)
        
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]
        self.tabBarController?.tabBar.translucent = false
        self.navigationController?.navigationBar.translucent = false
        self.tableView.backgroundColor = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        self.tableView.tableFooterView = UIView()
        
        self.tableData = Array<Event>()
        
        self.tableView.addLegendHeaderWithRefreshingTarget(self, refreshingAction: "updateEvents")
        self.tableView.header.beginRefreshing()
        
        self.emptyMessageLabel = UILabel(frame: CGRectMake(0, self.tableView.frame.origin.y/2-5, self.tableView.frame.width, 10))
        self.emptyMessageLabel!.text = "您还没有收到任何邀请\n点击右下角的笔去邀请好友吧！"
        self.emptyMessageLabel!.numberOfLines = 2
        self.emptyMessageLabel!.textAlignment = NSTextAlignment.Center
        self.emptyMessageLabel!.textColor = UIColor.redColor()
        
        documentPath = Utility.filePath("invite.plist")
        
        var fileManage:NSFileManager = NSFileManager()
        if fileManage.fileExistsAtPath(documentPath!) {
            var allObjs:[NSDictionary] = NSKeyedUnarchiver.unarchiveObjectWithFile(documentPath!) as! [NSDictionary]
            println("read:\(allObjs)")
            for allObj in allObjs {
                var obj:AVObject = AVObject(className: "Event")
                obj.objectFromDictionary(allObj as [NSObject : AnyObject])
                var event:Event = Event()
                event.obj = obj
                
                //FIXME: cannot work when offline
                var ownerRelation = obj.objectForKey("owner") as! AVRelation
                var ownerQuery = ownerRelation.query()
                event.owner = ownerQuery.getFirstObject() as? AVUser
                
                var participatersRelation = obj.objectForKey("participater") as! AVRelation
                var participatersQuery = participatersRelation.query()
                participatersQuery.findObjectsInBackgroundWithBlock({ (part:[AnyObject]!, error:NSError!) -> Void in
                    event.participants = part as? [AVUser]
                })
                
                event.needLocation = obj.objectForKey("needLocation") as! Bool
                event.acceptMemberCount = obj.objectForKey("acceptMemberCount") as? Int
                event.refuseMemberCount = obj.objectForKey("refuseMemberCount") as? Int
                event.date = obj.objectForKey("date") as? NSDate
                event.eventID = obj.objectId as String
                var point:AVGeoPoint = obj.objectForKey("coordinate") as! AVGeoPoint
                event.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                event.message = obj.objectForKey("message") as? String
                self.tableData!.append(event)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - YALTabBarInteracting
    func extraRightItemDidPressed() {
        self.performSegueWithIdentifier("createEvent", sender: self)
    }
    
    // MARK: - MJRefresh func
    func updateEvents() {
        var allObjs:Array = [NSDictionary]()
        
        var query:AVQuery? = AVQuery(className: "Event")
        query!.whereKey("owner", equalTo: AVUser.currentUser())
        query!.whereKey("date", greaterThanOrEqualTo: NSDate())
        query!.orderByAscending("date")
        query!.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError?) -> Void in
            if (error != nil) {
                TSMessage.showNotificationWithTitle("错误", subtitle: error!.localizedDescription, type: TSMessageNotificationType.Error)
                self.tableView.header.endRefreshing()
            } else {
                if objects.count != 0 {
                    self.tableData!.removeAll(keepCapacity: true)
                    for (var i=0; i<objects.count; ++i) {
                        var event:Event = Event()
                        var obj = objects[i] as! AVObject
                        event.obj = obj
                        
                        var ownerRelation = obj.objectForKey("owner") as! AVRelation
                        var ownerQuery = ownerRelation.query()
                        event.owner = ownerQuery.getFirstObject() as? AVUser
                        
                        var participatersRelation = obj.objectForKey("participater") as! AVRelation
                        var participatersQuery = participatersRelation.query()
                        participatersQuery.findObjectsInBackgroundWithBlock({ (part:[AnyObject]!, error:NSError!) -> Void in
                            event.participants = part as? [AVUser]
                        })
                        
                        event.needLocation = obj.objectForKey("needLocation") as! Bool
                        event.acceptMemberCount = obj.objectForKey("acceptMemberCount") as? Int
                        event.refuseMemberCount = obj.objectForKey("refuseMemberCount") as? Int
                        event.date = obj.objectForKey("date") as? NSDate
                        event.eventID = obj.objectId as String
                        var point:AVGeoPoint = obj.objectForKey("coordinate") as! AVGeoPoint
                        event.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                        event.message = obj.objectForKey("message") as? String
                        self.tableData!.append(event)
                        //prepare archive
                        allObjs.append(obj.dictionaryForObject())
                    }
                    self.tableView.reloadData();
                    //archive
                    NSKeyedArchiver.archiveRootObject(allObjs, toFile: self.documentPath!)
                }
                self.tableView.header.endRefreshing()
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableData != nil{
            if tableData!.count == 0 {
                self.tableView.backgroundView = self.emptyMessageLabel
            } else {
                self.tableView.backgroundView = UIView()
            }
            return tableData!.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:NSString = "InviteTableViewCell"
        var cell:InviteTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier as String, forIndexPath: indexPath) as! InviteTableViewCell
        
        cell.backgroundColor  = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        cell.eventMessage.text = (self.tableData![indexPath.row] as Event).message
        var date:String = NSDateFormatter.localizedStringFromDate((self.tableData![indexPath.row] as Event).date!, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        cell.eventDatetime.text = date
        cell.numberOfAccept.text = "\((self.tableData![indexPath.row] as Event).acceptMemberCount!)"
        cell.numberOfRefuse.text = "\((self.tableData![indexPath.row] as Event).refuseMemberCount!)"
        
        cell.rightUtilityButtons = self.rightButtonsForOwner() as [AnyObject]
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(!tableView.editing) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        selectedRowNumber = indexPath.row
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        performSegueWithIdentifier("viewEvent", sender: self)
    }

    // MARK: - SWTableViewCell Delegate
    func rightButtonsForOwner()->NSArray {
        var rightUtilityButtons:NSMutableArray = NSMutableArray()
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.orangeColor(), title: "修改")
        return rightUtilityButtons
    }
    

    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        cell.hideUtilityButtonsAnimated(true)
        if index == 0{
            selectedRowNumber = self.tableView.indexPathForCell(cell)!.row
            performSegueWithIdentifier("editEvent", sender: self)
        }
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createEvent"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let createEventViewController = navigationController.viewControllers[0] as! CreateEventViewController
            createEventViewController.delegate = self
        }
        if segue.identifier == "editEvent"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let createEventViewController = navigationController.viewControllers[0] as! CreateEventViewController
            createEventViewController.delegate = self
            createEventViewController.event = self.tableData![selectedRowNumber] as Event
        }
        if segue.identifier == "viewEvent"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let viewEventViewController = navigationController.viewControllers[0] as! ViewEventViewController
            viewEventViewController.delegate = self
            viewEventViewController.event = self.tableData![selectedRowNumber] as Event
        }
    }
    
    func CreateEventViewControllerDidBack(_: CreateEventViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func CreateEventViewControllerDone(_: CreateEventViewController) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            self.tableView.header.beginRefreshing()
        })
    }
    
    func ViewEventViewControllerDidBack(_: ViewEventViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }


}
