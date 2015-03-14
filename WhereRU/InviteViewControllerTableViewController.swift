//
//  InviteViewControllerTableViewController.swift
//  WhereRU
//
//  Created by RInz on 15/2/27.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class InviteViewControllerTableViewController: UITableViewController, SWTableViewCellDelegate, CreateEventViewControllerDelegate, ViewEventViewControllerDelegate {

    private var tableData:Array<Event>?
    private var rowsCount:NSInteger = 0
    private var manager = AFHTTPRequestOperationManager()
    private var authToken:String?
    private var selectedRowNumber:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        self.tabBarController?.tabBar.translucent = false
        self.navigationController?.navigationBar.translucent = false
        self.tableView.backgroundColor = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        self.tableView.tableFooterView = UIView()
        
        self.tableData = Array<Event>()
        
        self.tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.updateEvents()
        }
        var refreshView:UIView = UIView()
        var refreshImage:UIImage = UIImage(named: "icon_refresh")!
        var refreshImageView:UIImageView = UIImageView(image: refreshImage)
        refreshView.addSubview(refreshImageView)
        self.tableView.pullToRefreshView.setCustomView(refreshImageView, forState: 10)
        
        tableView.triggerPullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SVPullToRefresh func
    func updateEvents(){
        self.authToken = User.shared.token
        self.manager.requestSerializer.setValue("Token "+self.authToken!, forHTTPHeaderField: "Authorization")
        self.manager.GET(inviteURL,
            parameters: nil,
            success: { (operation:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                self.tableData?.removeAll(keepCapacity: true)
                var response = JSONValue(object)
                var sum:Int = response["count"].integer!
                for var i=0; i<sum; ++i{
                    var event = Event()
                    event.eventID = response["results"][i]["id"].integer!
                    event.owner = response["results"][i]["owner"].integer!
                    event.participants = response["results"][i]["participants"].string
                    event.coordinate = CLLocationCoordinate2D(latitude: response["results"][i]["latitude"].double!, longitude: response["results"][i]["longitude"].double!)
                    event.date = response["results"][i]["startdate"].string!
                    event.date = event.date?.stringByReplacingOccurrencesOfString("T", withString: " ", options: NSStringCompareOptions.allZeros, range: nil).stringByReplacingOccurrencesOfString(":00Z", withString: "", options: NSStringCompareOptions.allZeros, range: nil)
                    event.needLocation = response["results"][i]["needLocation"].bool!
                    event.Message = response["results"][i]["message"].string
                    event.AcceptMemberCount = response["results"][i]["AcceptMemberCount"].integer
                    event.RefuseMemberCount = response["results"][i]["RefuseMemberCount"].integer
                    self.tableData!.append(event)
                }
                self.tableView.reloadData()
                self.tableView.pullToRefreshView.stopAnimating()
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                println("get event list:"+error.description)
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
        var cell:InviteTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as InviteTableViewCell
        
        cell.backgroundColor  = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        cell.eventMessage.text = (self.tableData![indexPath.row] as Event).Message
        cell.eventDatetime.text = (self.tableData![indexPath.row] as Event).date
        cell.numberOfAccept.text = "\((self.tableData![indexPath.row] as Event).AcceptMemberCount!)"
        cell.numberOfRefuse.text = "\((self.tableData![indexPath.row] as Event).RefuseMemberCount!)"
        
        cell.rightUtilityButtons = self.rightButtonsForOwner()
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
    func rightButtonsForOwner()->NSArray{
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
            let navigationController = segue.destinationViewController as UINavigationController
            let createEventViewController = navigationController.viewControllers[0] as CreateEventViewController
            createEventViewController.delegate = self
        }
        if segue.identifier == "editEvent"{
            let navigationController = segue.destinationViewController as UINavigationController
            let createEventViewController = navigationController.viewControllers[0] as CreateEventViewController
            createEventViewController.delegate = self
            createEventViewController.event = self.tableData![selectedRowNumber] as Event
        }
        if segue.identifier == "viewEvent"{
            let navigationController = segue.destinationViewController as UINavigationController
            let viewEventViewController = navigationController.viewControllers[0] as ViewEventViewController
            viewEventViewController.delegate = self
            viewEventViewController.event = self.tableData![selectedRowNumber] as Event
        }
    }
    
    func CreateEventViewControllerDidBack(_: CreateEventViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        self.tableView.triggerPullToRefresh()
    }
    
    func CreateEventViewControllerDone(_: CreateEventViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        self.tableView.triggerPullToRefresh()
    }
    
    func ViewEventViewControllerDidBack(_: ViewEventViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        self.tableView.triggerPullToRefresh()
    }


}
