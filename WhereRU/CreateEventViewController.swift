//
//  CreateEventViewController.swift
//  WhereRU
//
//  Created by RInz on 14/12/7.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

protocol CreateEventViewControllerDelegate {
    func CreateEventViewControllerDidBack(_: CreateEventViewController)
    func CreateEventViewControllerDone(_: CreateEventViewController)
}

class CreateEventViewController: UIViewController,  MAMapViewDelegate, AMapSearchDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate, AddParticipantsViewDelegate, HSDatePickerViewControllerDelegate {

    @IBOutlet weak var locationMapView: MAMapView!
    @IBOutlet weak var myAvatarImageView: avatarImageView!
    @IBOutlet weak var eventTextView: UITextView!
    @IBOutlet weak var participatorCollectionView: UICollectionView!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var search:AMapSearchAPI?
    private var clLocationManager:CLLocationManager?
    private var displayController:UISearchDisplayController?
    private var tips:[AMapTip]?
    private var deleteParticipatorByPanGesture:UILongPressGestureRecognizer?
    private var addParticipatorByTapGesture:UITapGestureRecognizer?
    
    var participators:[AVUser]?
    var oldParticipators:[AVUser]?
    var event:Event?
    var delegate:CreateEventViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AVPush.setProductionMode(false)
        
        TSMessage.setDefaultViewController(self)
        
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        self.navigationController?.navigationBar.translucent = false
        
        if (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0 {
            self.clLocationManager = CLLocationManager()
            self.clLocationManager?.requestAlwaysAuthorization()
        }
        
        locationMapView.frame = CGRectMake(locationMapView.frame.origin.x, locationMapView.frame.origin.y, self.view.bounds.width, locationMapView.frame.size.height)
        var compassSize:CGSize = locationMapView.compassSize
        locationMapView.compassOrigin = CGPointMake(locationMapView.frame.size.width-compassSize.width, locationMapView.frame.size.height-compassSize.height)
        locationMapView.showsScale = false
        
        locationMapView.delegate = self
        locationMapView.setZoomLevel(15.1, animated: true)
        
        var avatarObject: AnyObject! = AVUser.currentUser().objectForKey("avatarFile")
        if avatarObject != nil {
            myAvatarImageView.image = UIImage(data: avatarObject.getData())
        } else {
            myAvatarImageView.image = UIImage(named: "default_avatar")
        }
        
        
        //Enable touch POI
        self.locationMapView.touchPOIEnabled = true
        
        deleteParticipatorByPanGesture = UILongPressGestureRecognizer(target: self, action: "deleteParticipator:")
        deleteParticipatorByPanGesture!.delegate = self
        participatorCollectionView.addGestureRecognizer(deleteParticipatorByPanGesture!)
        
        addParticipatorByTapGesture = UITapGestureRecognizer(target: self, action: "addParticipator:")
        addParticipatorByTapGesture!.delegate = self
        participatorCollectionView.addGestureRecognizer(addParticipatorByTapGesture!)
        
        eventTextView.layer.borderColor = UIColor.blackColor().CGColor
        eventTextView.layer.borderWidth = 1
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY年MM月dd hh:mm"
        timeButton.setTitle(dateFormatter.stringFromDate(NSDate()), forState: UIControlState.Normal)
        
        participatorCollectionView.delegate = self
        participatorCollectionView.dataSource = self
        
        locationSearchBar.delegate = self
        locationSearchBar.tintColor = UIColor.blackColor()
        
        search = AMapSearchAPI(searchKey: MAMapServices.sharedServices().apiKey, delegate: self)
        
        displayController = UISearchDisplayController(searchBar: locationSearchBar, contentsController: self)
        displayController?.delegate = self
        displayController?.searchResultsDataSource = self
        displayController?.searchResultsDelegate = self
        
        self.doneButton.setAttributedTitle(NSAttributedString(string: "完成", attributes:NSDictionary(object: UIColor.redColor(), forKey: NSForegroundColorAttributeName) as? [String : AnyObject]), forState: .Normal)
        
        tips = []
        participators = [AVUser]()
        
        if let myEvent = event {
            self.doneButton.setAttributedTitle(NSAttributedString(string: "更新", attributes:NSDictionary(object: UIColor.redColor(), forKey: NSForegroundColorAttributeName) as? [String : AnyObject]), forState: .Normal)
            eventTextView.text = myEvent.message
            
            participators = myEvent.participants
            oldParticipators = myEvent.participants
        }
    }
    
    override func viewDidLayoutSubviews() {
        //
    }
    
    @IBAction func chooseTime(sender: AnyObject) {
        let hsdpvc:HSDatePickerViewController = HSDatePickerViewController()
        hsdpvc.delegate = self
        hsdpvc.date = NSDate()
        hsdpvc.confirmButtonTitle = "确定"
        hsdpvc.backButtonTitle = "返回"
        presentViewController(hsdpvc, animated: true, completion: nil)
    }
    
    @IBAction func setNeedLocation(sender: AnyObject) {
        let switchButton:UISwitch = sender as! UISwitch
        if  self.event != nil {
            if switchButton.on {
                self.event!.needLocation = true
            } else {
                self.event!.needLocation = false
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if event != nil && event!.coordinate != nil {
            let point: MAPointAnnotation = MAPointAnnotation()
            point.coordinate = event!.coordinate!
            point.title = "目的地"
            self.locationMapView.setCenterCoordinate(point.coordinate, animated: true)
            self.locationMapView.addAnnotation(point)
        } else if event == nil {
            event = Event()
            locationMapView.showsUserLocation = true
            locationMapView.userTrackingMode = MAUserTrackingModeFollow
        }
    }
    
    //MARK: - HSDatePickerDelegate
    func hsDatePickerPickedDate(date: NSDate!) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY年MM月dd hh:mm"
        self.timeButton.setTitle(dateFormatter.stringFromDate(date), forState: UIControlState.Normal)
        self.event!.date = date
    }

    
    //MARK: - MAMAP Util func
    func searchGeocodeWithKey(key:NSString, adcode:String?) {
        if key.length == 0 {
            return
        }
        let geo:AMapGeocodeSearchRequest = AMapGeocodeSearchRequest()
        geo.address = key as String
        if(adcode != nil && (adcode!).characters.count>0) {
            geo.city = [adcode!]
        }
        self.search?.AMapGeocodeSearch(geo)
    }
    
    func annotationForTouchPoi(touchPoi:MATouchPoi?) -> MAPointAnnotation? {
        if (touchPoi == nil) {
            return nil;
        }
        let annotation:MAPointAnnotation = MAPointAnnotation()
        annotation.coordinate = touchPoi!.coordinate
        annotation.title = touchPoi!.name
        return annotation
    }
    
    func searchTipsWithKey(key:NSString) {
        if (key.length == 0) {
            return;
        }
        
        let tips = AMapInputTipsSearchRequest()
        tips.keywords = key as String;
        self.search?.AMapInputTipsSearch(tips)
    }
    
    func clear() {
        self.locationMapView.removeAnnotations(self.locationMapView.annotations)
    }
    
    func clearAndSearchGeocodeWithKey(key:NSString, adcode:String?) {
        self.clear()
        self.searchGeocodeWithKey(key, adcode: adcode)
    }
    
    //MARK: - MAMapViewDelegate
    func mapView(mapView: MAMapView!, didTouchPois pois: [AnyObject]!) {
        if (pois == nil || pois.count == 0) {
            return;
        }
        self.locationMapView.showsUserLocation = false
        if self.locationMapView.annotations.count > 0 {
            self.locationMapView.removeAnnotation(self.locationMapView.annotations[0] as! MAPointAnnotation)
        }
        let annotation:MAPointAnnotation = self.annotationForTouchPoi(pois[0] as? MATouchPoi)!
        self.locationMapView.addAnnotation(annotation)
        self.locationMapView.selectAnnotation(annotation, animated: true)
    }
    
    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKindOfClass(GeocodeAnnotation) {
            let geoCellIdentifier = "geoCellIdentifier"
            var poiAnnotationView:MAPinAnnotationView? = self.locationMapView.dequeueReusableAnnotationViewWithIdentifier(geoCellIdentifier) as! MAPinAnnotationView?
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: geoCellIdentifier)
            }
            poiAnnotationView?.canShowCallout = true
            poiAnnotationView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as UIView
            return poiAnnotationView
        }
        if annotation.isKindOfClass(ReGeocodeAnnotation) {
            let invertGeoIdentifier = "invertGeoIdentifier"
            var poiAnnotationView:MAPinAnnotationView? = self.locationMapView.dequeueReusableAnnotationViewWithIdentifier(invertGeoIdentifier) as! MAPinAnnotationView?
            if poiAnnotationView == nil{
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: invertGeoIdentifier)
            }
            poiAnnotationView?.animatesDrop = true
            poiAnnotationView?.canShowCallout = true
            poiAnnotationView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as UIView
            return poiAnnotationView
        }
        if annotation.isKindOfClass(MAPointAnnotation) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var poiAnnotationView:MAPinAnnotationView? = self.locationMapView.dequeueReusableAnnotationViewWithIdentifier(pointReuseIndetifier) as! MAPinAnnotationView?
            if poiAnnotationView == nil{
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            poiAnnotationView?.animatesDrop = true
            poiAnnotationView?.canShowCallout = true
            poiAnnotationView?.draggable = true;
            poiAnnotationView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as UIView
            return poiAnnotationView
        }
        return nil
    }
    
    func onGeocodeSearchDone(request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        if response.geocodes.count == 0 {
            return
        }
        
        var annotations = [GeocodeAnnotation]()
        (response.geocodes as NSArray).enumerateObjectsUsingBlock { (obj:AnyObject!, idx:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            let geocodeAnnotation:GeocodeAnnotation = GeocodeAnnotation(geocode: obj as! AMapGeocode)
            annotations.append(geocodeAnnotation)
        }
        if annotations.count == 1 {
            print((annotations[0].coordinate as CLLocationCoordinate2D).latitude)
            print((annotations[0].coordinate as CLLocationCoordinate2D).longitude)
            self.locationMapView.setCenterCoordinate(annotations[0].coordinate, animated: true)
        } else {
            self.locationMapView.setVisibleMapRect(CommonUtility.minMapRectForAnnotations(annotations), animated: true)
        }
        self.locationMapView.addAnnotations(annotations)
        self.locationMapView.showsUserLocation = false
    }
    
    func onInputTipsSearchDone(request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        self.tips = response.tips as? [AMapTip]
        self.displayController?.searchResultsTableView.reloadData()
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let key = searchBar.text;
        self.clearAndSearchGeocodeWithKey(key!, adcode:nil)
        self.displayController?.setActive(false, animated: false)
        self.locationSearchBar.placeholder = key;
    }
    
    //MARK: - UISearchDisplayDelegate
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.searchTipsWithKey(searchString!)
        return true
    }
    
    //MARK: - SearchBar UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tips number:\(self.tips!.count)")
        return self.tips!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tipCellIdentifier = "tipCellIdentifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(tipCellIdentifier)
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: tipCellIdentifier)
        }
        let tip:AMapTip = self.tips![indexPath.row]
        cell?.textLabel?.text = tip.name
        cell?.detailTextLabel?.text = tip.adcode
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tip:AMapTip = self.tips![indexPath.row]
        self.clearAndSearchGeocodeWithKey(tip.name, adcode: tip.adcode)
        self.displayController?.setActive(false, animated: false)
        self.locationSearchBar.placeholder = tip.name
    }
    
    // MARK: - CollectionViewDelegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participators!.count+1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier:NSString = "ParticipatorCollectionViewCell"
        var cell: ParticipatorCollectionViewCell = participatorCollectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier as String, forIndexPath: indexPath) as! ParticipatorCollectionViewCell
        
        if indexPath.row == participators!.count{
            cell.participatorAvatarImage.image = UIImage(named: "icon_add")
            cell.participatorAvatarImage.layer.borderWidth = 0
            cell.isParticipator = false
        } else{
            var avatarObject: AnyObject! = participators![indexPath.row].objectForKey("avatarFile")
            if avatarObject != nil {
                var avatarData = avatarObject.getData()
                cell.participatorAvatarImage.image = UIImage(data: avatarData)
            } else {
                cell.participatorAvatarImage.image = UIImage(named: "default_avatar")
            }
            cell.participatorAvatarImage.layer.borderWidth = 1
            cell.isParticipator = true
        }
        
        return cell
    }
    
    //MARK: - Handle Gesture
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func deleteParticipator(sender:UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended{
            let initPoint:CGPoint = sender.locationInView(participatorCollectionView)
            let panCellPath:NSIndexPath? = participatorCollectionView.indexPathForItemAtPoint(initPoint)
            if panCellPath != nil{
                let cell:ParticipatorCollectionViewCell = participatorCollectionView.cellForItemAtIndexPath(panCellPath!) as! ParticipatorCollectionViewCell
                if cell.isParticipator{
                    let array:[NSIndexPath] = [panCellPath!]
                    participatorCollectionView.performBatchUpdates({
                        () -> Void in
                        self.participatorCollectionView.deleteItemsAtIndexPaths(array)
                        self.participators?.removeAtIndex(panCellPath!.row)
                        self.participatorCollectionView.reloadData()
                    }, completion: { (bool) -> Void in
                        //
                    })
                }
            }
        }
    }
    
    func addParticipator(sender:UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended{
            let initPoint:CGPoint = sender.locationInView(participatorCollectionView)
            let tapCellPath:NSIndexPath? = participatorCollectionView.indexPathForItemAtPoint(initPoint)
            if tapCellPath != nil{
                let cell:ParticipatorCollectionViewCell = participatorCollectionView.cellForItemAtIndexPath(tapCellPath!) as! ParticipatorCollectionViewCell
                if !cell.isParticipator{
                    self.performSegueWithIdentifier("addParticipant", sender: self)
                }
            }
        }
    }


    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addParticipant"{
            let navigationController:UINavigationController = segue.destinationViewController as! UINavigationController
            let addParticipantsTableViewController:AddParticipantsViewController = navigationController.viewControllers[0] as! AddParticipantsViewController
            addParticipantsTableViewController.delegate = self
        }
    }

    @IBAction func Back(sender: AnyObject) {
        if let tabBarController = self.tabBarController{
            self.tabBarController!.selectedIndex = 0
        } else{
            self.delegate?.CreateEventViewControllerDidBack(self)
        }
    }
    
    // MARK: - addParticipantsDelegate
    func AddParticipantsDidDone(controller: AddParticipantsViewController, _ friends: [AVUser]) {
        for friend in friends{
            var needAdd:Bool = true
            for participator in participators!{
                if participator == friend{
                    needAdd = false
                }
            }
            if needAdd{
                self.participators?.append(friend)
            }
        }
        self.participatorCollectionView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Main Logic
    @IBAction func CreateNewEvent(sender: AnyObject) {
        if let eventid = event!.eventID{
            SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Clear)
            
            event!.obj!.setObject(AVGeoPoint(latitude: (self.locationMapView.annotations[0].coordinate as CLLocationCoordinate2D).latitude, longitude: (self.locationMapView.annotations[0].coordinate as CLLocationCoordinate2D).longitude), forKey: "coordinate")
            event!.obj!.setObject(event!.date!, forKey: "date")
            event!.obj!.setObject(event!.needLocation, forKey: "needLocation")
            event!.obj!.setObject(self.eventTextView.text!, forKey: "message")
            event!.obj!.setObject(event!.acceptMemberCount!, forKey: "acceptMemberCount")
            event!.obj!.setObject(event!.refuseMemberCount!, forKey: "refuseMemberCount")
            
            let ownerRelation:AVRelation = event!.obj!.relationforKey("owner")
            ownerRelation.addObject(AVUser.currentUser())
            
            let participatorsRelation:AVRelation = event!.obj!.relationforKey("participater")
            for participator:AVUser in self.oldParticipators! {
                participatorsRelation.removeObject(participator)
            }
            for participator:AVUser in self.participators! {
                participatorsRelation.addObject(participator)
            }
            
            event!.obj!.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                if success {
                    let query:AVQuery = AVQuery(className: "UserStatusForEvent")
                    query.whereKey("event", equalTo: self.event!.obj)
                    query.deleteAllInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                        if success {
                            for participator:AVUser in self.participators! {
                                let status:AVObject = AVObject(className: "UserStatusForEvent")
                                let userRelation:AVRelation = status.relationforKey("user")
                                userRelation.addObject(participator)
                                let eventRelation:AVRelation = status.relationforKey("event")
                                eventRelation.addObject(self.event!.obj)
                                status.save()
                            }
                            
                            let pushQuery:AVQuery = AVInstallation.query()
                            pushQuery.whereKey("deviceOwner", containedIn: self.participators)
                            
                            let push:AVPush = AVPush()
                            push.setQuery(pushQuery)
                            push.setMessage("您收到了新的邀约！请注意查收")
                            push.sendPushInBackground()
                            
                            SVProgressHUD.showSuccessWithStatus("跟新成功！")
                            self.delegate!.CreateEventViewControllerDone(self)
                        }
                    })
                }
            })

        } else{
            if self.eventTextView.text.isEmpty && event?.date == nil{
                TSMessage.showNotificationWithTitle("出错啦！", subtitle: "请添加您要说的话\n请设置时间", type: .Error)
            } else if self.eventTextView.text == ""{
                TSMessage.showNotificationWithTitle("出错啦！", subtitle: "请添加您要说的话", type: .Error)
            } else if event?.date == nil{
                TSMessage.showNotificationWithTitle("出错啦！", subtitle: "请设置时间", type: .Error)
            } else{
                SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Clear)
                let params:NSMutableDictionary = NSMutableDictionary(capacity: 8)
                params.setObject(AVGeoPoint(latitude: (self.locationMapView.annotations[0].coordinate as CLLocationCoordinate2D).latitude, longitude: (self.locationMapView.annotations[0].coordinate as CLLocationCoordinate2D).longitude), forKey: "coordinate")
                params.setObject(event!.date!, forKey: "date")
                params.setObject(event!.needLocation, forKey: "needLocation")
                params.setObject(self.eventTextView.text!, forKey: "message")
                params.setObject(0, forKey: "acceptMemberCount")
                params.setObject(0, forKey: "refuseMemberCount")
                
                let newEvent:AVObject = AVObject(className: "Event", dictionary: params as [NSObject : AnyObject])
                let ownerRelation:AVRelation = newEvent.relationforKey("owner")
                ownerRelation.addObject(AVUser.currentUser())
                
                let participatorsRelation:AVRelation = newEvent.relationforKey("participater")
                for participator:AVUser in self.participators! {
                    participatorsRelation.addObject(participator)
                }
                
                newEvent.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                    if success {
                        for participator:AVUser in self.participators! {
                            let status:AVObject = AVObject(className: "UserStatusForEvent")
                            let userRelation:AVRelation = status.relationforKey("user")
                            userRelation.addObject(participator)
                            let eventRelation:AVRelation = status.relationforKey("event")
                            eventRelation.addObject(newEvent)
                            status.save()
                        }
                        
                        let pushQuery:AVQuery = AVInstallation.query()
                        pushQuery.whereKey("deviceOwner", containedIn: self.participators)
                        let push:AVPush = AVPush()
                        push.setQuery(pushQuery)
                        push.setMessage("您收到了新的邀约！请注意查收")
                        push.sendPushInBackground()
                        
                        SVProgressHUD.showSuccessWithStatus("创建成功！")
                        self.delegate!.CreateEventViewControllerDone(self)
                    }
                })
            }
        }
    }
    
}
