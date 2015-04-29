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
        
        self.tableView.addLegendHeaderWithRefreshingTarget(self, refreshingAction: "updateEvents")
        self.tableView.header.beginRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
        //
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
        cell.backgroundColor  = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        cell.delegate = self
        
        cell.eventMessage.text = (self.tableData![indexPath.row] as Event).message
        cell.eventDateTime.text = "\((self.tableData![indexPath.row] as Event).date)"
        cell.numberOfAccept.text = "\((self.tableData![indexPath.row] as Event).acceptMemberCount!)"
        
        cell.eventStatus.hidden = true
        
        var query:AVQuery = AVQuery(className: "UserStatusForEvent")
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.getFirstObjectInBackgroundWithBlock { (object:AVObject!, error:NSError!) -> Void in
            if object != nil {
                var status: AnyObject! = object.objectForKey("status")
                if status != nil {
                    if status as! Bool == true {
                        cell.eventStatus.image = UIImage(named: "icon_accept_invite")
                        cell.eventStatus.hidden = false
                    }else {
                        cell.eventStatus.image = UIImage(named: "icon_refuse_invite")
                        cell.eventStatus.hidden = false
                    }
                }else {
                    cell.leftUtilityButtons = self.leftButtonsForParticipant() as [AnyObject]
                }
            }else {
                cell.leftUtilityButtons = self.leftButtonsForParticipant() as [AnyObject]
            }
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
            
            row_event.obj!.setObject(row_event.acceptMemberCount!+1, forKey: "acceptMemberCount")
            row_event.obj!.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                if success {
                    var cql:String = "select * from UserStatusForEvent where event = ? and user = ?"
                    var pvalues:[AnyObject!] = [row_event.obj, AVUser.currentUser()]
                    AVQuery.doCloudQueryInBackgroundWithCQL(cql, pvalues: pvalues, callback: { (result:AVCloudQueryResult!, error:NSError!) -> Void in
                        if !(error != nil) {
                            var obj:AVObject = result.results[0] as! AVObject
                            obj.setObject(true, forKey: "status")
                            obj.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                                print("update success!!")
                                SVProgressHUD.dismiss()
                                self.tableView.header.beginRefreshing()
                            })
                        }else {
                            print("\(error.description)")
                        }
                    })
                    
                }else {
                    print("\(error.description)")
                }
            })
        }else{
            SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Clear)
            
            row_event.obj!.setObject(row_event.refuseMemberCount!+1, forKey: "acceptMemberCount")
            row_event.obj!.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                if success {
                    var cql:String = "select * from UserStatusForEvent where event = ? and user = ?"
                    var pvalues:[AnyObject!] = [row_event.obj, AVUser.currentUser()]
                    AVQuery.doCloudQueryInBackgroundWithCQL(cql, pvalues: pvalues, callback: { (result:AVCloudQueryResult!, error:NSError!) -> Void in
                        if !(error != nil) {
                            var obj:AVObject = result.results[0] as! AVObject
                            obj.setObject(false, forKey: "status")
                            obj.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                                print("update success!!")
                                SVProgressHUD.dismiss()
                                self.tableView.header.beginRefreshing()
                            })
                        }else {
                            print("\(error.description)")
                        }
                    })
                }else {
                    print("\(error.description)")
                }
            })
        }
    }
    
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    // MARK: - MJRefresh func
    func updateEvents() {
        self.tableData!.removeAll(keepCapacity: true)
        var query:AVQuery? = AVQuery(className: "Event")
        query!.whereKey("participater", equalTo: AVUser.currentUser())
        query!.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError?) -> Void in
            if (error != nil) {
                //
            }else {
                if objects.count != 0 {
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
                    }
                    self.tableView.reloadData();
                }
                self.tableView.header.endRefreshing()
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
