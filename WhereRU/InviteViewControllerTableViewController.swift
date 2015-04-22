//
//  InviteViewControllerTableViewController.swift
//  WhereRU
//
//  Created by RInz on 15/2/27.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class InviteViewControllerTableViewController: UITableViewController, SWTableViewCellDelegate, CreateEventViewControllerDelegate, ViewEventViewControllerDelegate, YALTabBarInteracting {

    private var tableData:Array<Event>?
    private var rowsCount:NSInteger = 0
    private var manager = AFHTTPRequestOperationManager()
    private var authToken:String?
    private var selectedRowNumber:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]
        self.tabBarController?.tabBar.translucent = false
        self.navigationController?.navigationBar.translucent = false
        self.tableView.backgroundColor = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        self.tableView.tableFooterView = UIView()
        
        self.tableData = Array<Event>()
        
        self.tableView.addLegendHeaderWithRefreshingTarget(self, refreshingAction: "updateEvents")
        self.tableView.header.beginRefreshing()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SVPullToRefresh func
    func updateEvents() {
        var query:AVQuery? = AVQuery(className: "Event_invite")
        query!.whereKey("owner", equalTo: AVUser.currentUser())
        query!.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError?) -> Void in
            if (error != nil) {
            }else {
                if objects.count != 0 {
                    for (var i=0; i<objects.count; ++i) {
                        var event:Event = Event()
                        var obj = objects[i] as! AVObject
                        event.owner = obj.objectForKey("owner") as? AVUser
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
                    self.tableView.reloadData();
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
            return tableData!.count
        }else{
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:NSString = "InviteTableViewCell"
        var cell:InviteTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier as String, forIndexPath: indexPath) as! InviteTableViewCell
        
        cell.backgroundColor  = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        cell.eventMessage.text = (self.tableData![indexPath.row] as Event).message
        cell.eventDatetime.text = "\((self.tableData![indexPath.row] as Event).date)"
        cell.numberOfAccept.text = "\((self.tableData![indexPath.row] as Event).acceptMemberCount!)"
        cell.numberOfRefuse.text = "\((self.tableData![indexPath.row] as Event).refuseMemberCount!)"
        
        cell.rightUtilityButtons = self.rightButtonsForOwner() as [AnyObject]
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(!tableView.editing){
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        selectedRowNumber = indexPath.row
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func ViewEventViewControllerDidBack(_: ViewEventViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }


}
