//
//  EventViewController.swift
//  WhereRU
//
//  Created by RInz on 14/10/26.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class EventViewController: UITableViewController, SWTableViewCellDelegate, CreateEventViewControllerDelegate, ViewEventViewControllerDelegate, YALTabBarInteracting {
    
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
        
        
        self.tableData = Array<Event>()
    }
    
    override func viewDidAppear(animated: Bool) {
        updateEvents()
    }
    
    //MARK: - UITableView Delegate
    override func numberOfSectionsInTableView(tableView: UITableView)->NSInteger {
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
        return 60
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(!tableView.editing){
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        selectedRowNumber = indexPath.row
        performSegueWithIdentifier("viewEvent", sender: self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:NSString = "eventTableViewCell"
        var cell:EventTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier as String, forIndexPath: indexPath) as! EventTableViewCell
//        cell.leftUtilityButtons = self.leftButtonsForParticipant()

        cell.backgroundColor  = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        cell.delegate = self
        
        cell.eventMessage.text = (self.tableData![indexPath.row] as Event).Message
        cell.eventDateTime.text = (self.tableData![indexPath.row] as Event).date
        cell.numberOfAccept.text = "\((self.tableData![indexPath.row] as Event).AcceptMemberCount!)"
        
        cell.eventStatus.hidden = true
        
        self.manager.requestSerializer.setValue("Token "+self.authToken!, forHTTPHeaderField: "Authorization")
        var url = String(format: eventStatusURL, (self.tableData![indexPath.row] as Event).eventID!)
        self.manager.GET(url,
            parameters: nil,
            success: { (operation:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            println("Get event status failed \(error.description)")
        }
        
        return cell
    }
    
    // MARK: - SWTableViewCell Delegate
    func leftButtonsForParticipant()->NSArray {
        var leftUtilityButtons:NSMutableArray = NSMutableArray()
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.greenColor(), icon: UIImage(named: "icon_accept"))
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), icon: UIImage(named: "icon_delete"))
        return leftUtilityButtons
    }
    
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
        cell.hideUtilityButtonsAnimated(true)
        var id = (cell as! EventTableViewCell).cellParticipant
        var selectedRowNumber = self.tableView.indexPathForCell(cell)!.row
        var row_event = self.tableData![selectedRowNumber] as Event
        
        if index == 0{
            SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Clear)
            
            var params:NSMutableDictionary = NSMutableDictionary(capacity: 3)
            params.setObject(row_event.eventID!, forKey:    "event")
            params.setObject(User.shared.id, forKey: "participant")
            params.setObject(1, forKey: "status")
            var url = String(format: updateEventStatusURL, id)
            
            self.manager.requestSerializer.setValue("Token "+self.authToken!, forHTTPHeaderField: "Authorization")
            
            self.manager.PUT(url,
                parameters: params,
                success: { (operation:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                    
                    var params2:NSMutableDictionary = NSMutableDictionary(capacity: 7)
                    params2.setObject(row_event.owner, forKey: "owner")
                    params2.setObject(row_event.coordinate!.latitude, forKey: "latitude")
                    params2.setObject(row_event.coordinate!.longitude, forKey: "longitude")
                    params2.setObject(row_event.date!, forKey: "startdate")
                    params2.setObject(row_event.Message!, forKey: "message")
                    params2.setObject(row_event.AcceptMemberCount!+1, forKey: "AcceptMemberCount")
                    params2.setObject(row_event.RefuseMemberCount!, forKey: "RefuseMemberCount")
                    var url2 = String(format: updateEventURL, row_event.eventID!)
                    self.manager.PUT(url2,
                        parameters: params2,
                        success: { (operation:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                            SVProgressHUD.dismiss()
                            //
                        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        println("put number failed:\(error.description)")
                    })
    
                },
                failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    println("Update event status failed: \(error.description)")
            })
        }else{
            SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Clear)
            
            var params:NSMutableDictionary = NSMutableDictionary(capacity: 3)
            params.setObject(row_event.eventID!, forKey: "event")
            params.setObject(User.shared.id, forKey: "participant")
            params.setObject(0, forKey: "status")
            var url = String(format: updateEventStatusURL, id)
            
            self.manager.requestSerializer.setValue("Token "+self.authToken!, forHTTPHeaderField: "Authorization")
            
            self.manager.PUT(url,
                parameters: params,
                success: { (operation:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                    
                    var params2:NSMutableDictionary = NSMutableDictionary(capacity: 7)
                    params2.setObject(row_event.owner, forKey: "owner")
                    params2.setObject(row_event.coordinate!.latitude, forKey: "latitude")
                    params2.setObject(row_event.coordinate!.longitude, forKey: "longitude")
                    params2.setObject(row_event.date!, forKey: "startdate")
                    params2.setObject(row_event.Message!, forKey: "message")
                    params2.setObject(row_event.AcceptMemberCount!, forKey: "AcceptMemberCount")
                    params2.setObject(row_event.RefuseMemberCount!+1, forKey: "RefuseMemberCount")
                    var url2 = String(format: updateEventURL, row_event.eventID!)
                    self.manager.PUT(url2,
                        parameters: params2,
                        success: { (operation:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                            SVProgressHUD.dismiss()
                            //
                        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                            //
                    })
                    
                },
                failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    println("Update event status failed: \(error.description)")
            })
        }
    }
    
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    // MARK: - SVPullToRefresh func
    func updateEvents() {
        var query:AVQuery? = AVQuery(className: "Event_invited")
        query!.whereKey("owner", equalTo: AVUser.currentUser())
        query!.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError?) -> Void in
            if (error != nil){
            }else{
                println(objects[0])
            }
        }

    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
