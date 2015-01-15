//
//  EventViewController.swift
//  WhereRU
//
//  Created by RInz on 14/10/26.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class EventViewController: UITableViewController, SWTableViewCellDelegate, CreateEventViewControllerDelegate{
    
    var tableData:Array<Event>?
    var rowsCount:NSInteger = 0
    var eventsURL = "http://54.255.168.161/events/"
    var manager = AFHTTPRequestOperationManager()
    var authToken:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableData = Array<Event>()
        
        self.tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.updateEvents()
        }
//        SVProgressHUD.show()
        tableView.triggerPullToRefresh()

    }
    
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
        //todo
        if(!tableView.editing){
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:NSString = "eventTableViewCell"
        var cell:EventTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? EventTableViewCell

//        cell = EventTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        cell!.rightUtilityButtons = self.rightButtons()
        cell!.delegate = self
        
        cell?.eventMessage.text = (self.tableData![indexPath.row] as Event).Message
        cell?.eventDateTime.text = (self.tableData![indexPath.row] as Event).date
//        cell?.textLabel?.text = (self.tableData![indexPath.row] as Event).Message
        
        return cell!
    }
    
    @IBAction func createEvent(sender: AnyObject) {
        performSegueWithIdentifier("editEvent", sender: self)
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
        manager.requestSerializer.setValue("Token "+self.authToken!, forHTTPHeaderField: "Authorization")
        manager.GET(eventsURL,
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
        if segue.identifier == "editEvent"{
            let navigationController = segue.destinationViewController as UINavigationController
            let createEventViewController = navigationController.viewControllers[0] as CreateEventViewController
            createEventViewController.delegate = self
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
