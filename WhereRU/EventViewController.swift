//
//  EventViewController.swift
//  WhereRU
//
//  Created by RInz on 14/10/26.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class EventViewController: UITableViewController, SWTableViewCellDelegate, CreateEventViewControllerDelegate{
    
    private var tableData:Array<Event>?
    private var rowsCount:NSInteger = 0
    private var eventsURL = "http://54.255.168.161/events/"
    private var manager = AFHTTPRequestOperationManager()
    private var authToken:String?
    private var selectedRowNumber:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableData = Array<Event>()
        
        self.tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.updateEvents()
        }
        tableView.triggerPullToRefresh()

    }
    
    //MARK: - UITableView Delegate
    override func numberOfSectionsInTableView(tableView: UITableView)->NSInteger{
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableData != nil{
            return tableData!.count
        }else{
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(!tableView.editing){
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        selectedRowNumber = indexPath.row
        performSegueWithIdentifier("editEvent", sender: self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:NSString = "eventTableViewCell"
        var cell:EventTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? EventTableViewCell

        cell!.rightUtilityButtons = self.rightButtons()
        cell!.delegate = self
        
        cell?.eventMessage.text = (self.tableData![indexPath.row] as Event).Message
        cell?.eventDateTime.text = (self.tableData![indexPath.row] as Event).date
        
        return cell!
    }
    
    @IBAction func createEvent(sender: AnyObject) {
        performSegueWithIdentifier("createEvent", sender: self)
    }
    
    // MARK: - SWTableViewCell Delegate
    func rightButtons()->NSArray{
        var rightUtilityButtons:NSMutableArray = NSMutableArray()
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.greenColor(), title: "Disable")
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "Archive")
        return rightUtilityButtons
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        print("right button, index:%@",index)
    }
    
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    // MARK: - SVPullToRefresh func
    func updateEvents(){
        self.tableData?.removeAll(keepCapacity: true)
        self.authToken = User.shared.token
        self.manager.requestSerializer.setValue("Token "+self.authToken!, forHTTPHeaderField: "Authorization")
        self.manager.GET(eventsURL,
            parameters: nil,
            success: { (operation:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
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
                    self.tableData!.append(event)
                }
                self.tableView.reloadData()
                self.tableView.pullToRefreshView.stopAnimating()
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                println("get event list:"+error.description)
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
    }
    
    func CreateEventViewControllerDidBack(_: CreateEventViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func CreateEventViewControllerDone(_: CreateEventViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        self.tableView.triggerPullToRefresh()
    }

}
