//
//  CreateEventViewController.swift
//  WhereRU
//
//  Created by RInz on 14/12/7.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

protocol CreateEventViewControllerDelegate{
    func CreateEventViewControllerDidBack(CreateEventViewController)
    func CreateEventViewControllerDone(CreateEventViewController)
}

class CreateEventViewController: UIViewController,  MAMapViewDelegate, AMapSearchDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate, AddParticipantsTableViewDelegate, CreateEventDetailViewControllerDelegate {

    @IBOutlet weak var locationMapView: MAMapView!
    @IBOutlet weak var myAvatarImageView: avatarImageView!
    @IBOutlet weak var eventTextView: UITextView!
    @IBOutlet weak var participatorCollectionView: UICollectionView!
    @IBOutlet weak var locationSearchBar: UISearchBar!

    
    var search:AMapSearchAPI?
    var delegate:CreateEventViewControllerDelegate?
    var clLocationManager:CLLocationManager?
    var displayController:UISearchDisplayController?
    var tips:[AMapTip]?
    var createAnnotationLongPress:UILongPressGestureRecognizer?
    var deleteParticipatorByPanGesture:UILongPressGestureRecognizer?
    var addParticipatorByTapGesture:UITapGestureRecognizer?
    
    var participators:[Friend]?
    var event:Event?
    
    var eventsURL:String = "http://54.255.168.161/events/"
    var eventsAddParticipantsURL:String = "http://54.255.168.161/events/"
    var authToken:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0{
            self.clLocationManager = CLLocationManager()
            self.clLocationManager?.requestAlwaysAuthorization()
        }
        
        locationMapView.delegate = self
        locationMapView.showsUserLocation = true
        locationMapView.userTrackingMode = MAUserTrackingMode.Follow
        locationMapView.setZoomLevel(15.1, animated: true)
        
        myAvatarImageView.setImageWithURL(NSURL(string: User.shared.avatar!), placeholderImage: UIImage(named: "default_avatar"), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
        createAnnotationLongPress = UILongPressGestureRecognizer(target: self, action: "addAnnotationOnMapByLongPress:")
        createAnnotationLongPress!.delegate = self
        createAnnotationLongPress!.minimumPressDuration = 0.5
        self.view.addGestureRecognizer(createAnnotationLongPress!)
        
        deleteParticipatorByPanGesture = UILongPressGestureRecognizer(target: self, action: "deleteParticipator:")
        deleteParticipatorByPanGesture!.delegate = self
        participatorCollectionView.addGestureRecognizer(deleteParticipatorByPanGesture!)
        
        addParticipatorByTapGesture = UITapGestureRecognizer(target: self, action: "addParticipator:")
        addParticipatorByTapGesture!.delegate = self
        participatorCollectionView.addGestureRecognizer(addParticipatorByTapGesture!)
        
        eventTextView.layer.borderColor = UIColor.blackColor().CGColor
        eventTextView.layer.borderWidth = 1
        
        participatorCollectionView.delegate = self
        participatorCollectionView.dataSource = self
        
        locationSearchBar.delegate = self
        
        search = AMapSearchAPI(searchKey: "2e461f0bd5c6040de56f9e8aae0bceaf", delegate: self)
        
        displayController = UISearchDisplayController(searchBar: locationSearchBar, contentsController: self)
        displayController?.delegate = self
        displayController?.searchResultsDataSource = self
        displayController?.searchResultsDelegate = self
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_bar_background"), forBarMetrics: UIBarMetrics.Default)
//        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        tips = []
        participators = []
        event = Event()
        authToken = User.shared.token
    }
    
    func searchGeocodeWithKey(key:NSString, adcode:String?){
        if key.length == 0{
            return
        }
        var geo:AMapGeocodeSearchRequest = AMapGeocodeSearchRequest()
        geo.address = key
        if(adcode != nil && countElements(adcode!)>0){
            geo.city = [adcode!]
        }
        self.search?.AMapGeocodeSearch(geo)
    }
    
    func searchReGeocodeWithCoordinate(coordinate:CLLocationCoordinate2D){
        self.clear()
        var regeo = AMapReGeocodeSearchRequest()
        regeo.location = AMapGeoPoint.locationWithLatitude(CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        regeo.requireExtension = true
        self.search?.AMapReGoecodeSearch(regeo)
    }
    
    func searchTipsWithKey(key:NSString){
        if (key.length == 0)
        {
            return;
        }
        
        var tips = AMapInputTipsSearchRequest()
        tips.keywords = key;
        self.search?.AMapInputTipsSearch(tips)
    }
    
    func clear(){
        self.locationMapView.removeAnnotations(self.locationMapView.annotations)
    }
    
    func clearAndSearchGeocodeWithKey(key:NSString, adcode:String?){
        self.clear()
        self.searchGeocodeWithKey(key, adcode: adcode)
    }
    
    //MARK: - MAMapViewDelegate
    func mapView(mapView: MAMapView!, didAddAnnotationViews views: [AnyObject]!) {
        var view:MAAnnotationView = views[0] as MAAnnotationView
        self.locationMapView.selectAnnotation(view.annotation, animated: true)
    }
    
    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKindOfClass(GeocodeAnnotation){
            let geoCellIdentifier = "geoCellIdentifier"
            var poiAnnotationView:MAPinAnnotationView? = self.locationMapView.dequeueReusableAnnotationViewWithIdentifier(geoCellIdentifier) as MAPinAnnotationView?
            if poiAnnotationView == nil{
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: geoCellIdentifier)
            }
            poiAnnotationView?.canShowCallout = true
            poiAnnotationView?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIView
            return poiAnnotationView
        }
        if annotation.isKindOfClass(ReGeocodeAnnotation){
            let invertGeoIdentifier = "invertGeoIdentifier"
            var poiAnnotationView:MAPinAnnotationView? = self.locationMapView.dequeueReusableAnnotationViewWithIdentifier(invertGeoIdentifier) as MAPinAnnotationView?
            if poiAnnotationView == nil{
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: invertGeoIdentifier)
            }
            poiAnnotationView?.animatesDrop = true
            poiAnnotationView?.canShowCallout = true
            poiAnnotationView?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIView
            return poiAnnotationView
        }
        return nil
    }
    
    func onGeocodeSearchDone(request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        if response.geocodes.count == 0{
            return
        }
        var annotations = [GeocodeAnnotation]()
        (response.geocodes as NSArray).enumerateObjectsUsingBlock { (obj:AnyObject!, idx:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            var geocodeAnnotation:GeocodeAnnotation = GeocodeAnnotation(geocode: obj as AMapGeocode)
            annotations.append(geocodeAnnotation)
        }
        if annotations.count == 1{
            println((annotations[0].coordinate as CLLocationCoordinate2D).latitude)
            println((annotations[0].coordinate as CLLocationCoordinate2D).longitude)
            self.locationMapView.setCenterCoordinate(annotations[0].coordinate, animated: true)
        }else{
            self.locationMapView.setVisibleMapRect(CommonUtility.minMapRectForAnnotations(annotations), animated: true)
        }
        self.locationMapView .addAnnotations(annotations)
    }
    
    func onReGeocodeSearchDone(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if response.regeocode != nil{
            println(request.location.latitude)
            println(request.location.longitude)
            var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
            var reGeocodeAnnotation:ReGeocodeAnnotation = ReGeocodeAnnotation(reGeocode: response.regeocode, coordinate: coordinate)
            self.locationMapView.addAnnotation(reGeocodeAnnotation)
        }
    }
    
    func onInputTipsSearchDone(request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        self.tips = response.tips as? [AMapTip]
        self.displayController?.searchResultsTableView.reloadData()
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var key = searchBar.text;
        self.clearAndSearchGeocodeWithKey(key, adcode:nil)
        self.displayController?.setActive(false, animated: false)
        self.locationSearchBar.placeholder = key;
    }
    
    //MARK: - UISearchDisplayDelegate
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.searchTipsWithKey(searchString)
        return true
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("tips number:\(self.tips!.count)")
        return self.tips!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tipCellIdentifier = "tipCellIdentifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(tipCellIdentifier) as? UITableViewCell
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: tipCellIdentifier)
        }
        var tip:AMapTip = self.tips![indexPath.row]
        cell?.textLabel?.text = tip.name
        cell?.detailTextLabel?.text = tip.adcode
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var tip:AMapTip = self.tips![indexPath.row]
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
        var cell: ParticipatorCollectionViewCell = participatorCollectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as ParticipatorCollectionViewCell
        
        if indexPath.row == participators!.count{
            cell.participatorAvatarImage.image = UIImage(named: "plus")
            cell.participatorAvatarImage.layer.borderWidth = 0
            cell.isParticipator = false
        }else{
            cell.participatorAvatarImage.setImageWithURL(NSURL(string: participators![indexPath.row].avatar!), placeholderImage: UIImage(named: "default_avatar"), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            cell.participatorAvatarImage.layer.borderWidth = 1
            cell.isParticipator = true
        }
        
        return cell
    }
    
    //MARK: - Handle Gesture
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func addAnnotationOnMapByLongPress(longPress: UILongPressGestureRecognizer) {
        if longPress.state == UIGestureRecognizerState.Began{
            var coordinate:CLLocationCoordinate2D = self.locationMapView.convertPoint(createAnnotationLongPress!.locationInView(self.view), toCoordinateFromView: self.locationMapView)
            self.searchReGeocodeWithCoordinate(coordinate)
        }
    }
    
    func deleteParticipator(sender:UIPanGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Ended{
            var initPoint:CGPoint = sender.locationInView(participatorCollectionView)
            var panCellPath:NSIndexPath? = participatorCollectionView.indexPathForItemAtPoint(initPoint)
            if panCellPath != nil{
                var cell:ParticipatorCollectionViewCell = participatorCollectionView.cellForItemAtIndexPath(panCellPath!) as ParticipatorCollectionViewCell
                if cell.isParticipator{
                    var array:[NSIndexPath] = [panCellPath!]
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
    
    func addParticipator(sender:UITapGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Ended{
            var initPoint:CGPoint = sender.locationInView(participatorCollectionView)
            var tapCellPath:NSIndexPath? = participatorCollectionView.indexPathForItemAtPoint(initPoint)
            if tapCellPath != nil{
                var cell:ParticipatorCollectionViewCell = participatorCollectionView.cellForItemAtIndexPath(tapCellPath!) as ParticipatorCollectionViewCell
                if !cell.isParticipator{
                    //test data
//                    var D:Participant = Participant()
//                    D.nickname = "D"
//                    D.avatar = ""
//                    self.participators?.append(D)
//                    self.participatorCollectionView.insertItemsAtIndexPaths([tapCellPath!])
//                    self.participatorCollectionView.reloadData()
                    self.performSegueWithIdentifier("addParticipant", sender: self)
                }
            }
        }
    }


    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addParticipant"{
            let navigationController:UINavigationController = segue.destinationViewController as UINavigationController
            let addParticipantsTableViewController:AddParticipantsTableViewController = navigationController.viewControllers[0] as AddParticipantsTableViewController
            addParticipantsTableViewController.delegate = self
        }
        if segue.identifier == "createEventDetail"{
            let navigationController:UINavigationController = segue.destinationViewController as UINavigationController
            let createEventDetailViewController:CreateEventDetailViewController = navigationController.viewControllers[0] as CreateEventDetailViewController
            createEventDetailViewController.delegate = self
//            if event?.date != nil{
            createEventDetailViewController.date = self.event?.date
            createEventDetailViewController.need = self.event!.needLocation
//            }
        }
    }

    @IBAction func Back(sender: AnyObject) {
        self.delegate?.CreateEventViewControllerDidBack(self)
    }
    
    // MARK: - addParticipantsDelegate
    func AddParticipantsDidDone(controller: AddParticipantsTableViewController, _ friends: [Friend]) {
        for friend in friends{
            var needAdd:Bool = true
            for participator in participators!{
                if participator.to_user == friend.to_user{
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
    
    // MARK: - createEventDetailViewControllerDelegate
    func CreateEventDetailViewControllerDone(controller: CreateEventDetailViewController, _ date: String, _ needLocation: Bool) {
        event?.date = date
        event?.needLocation = needLocation
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Main Login
    @IBAction func CreateNewEvent(sender: AnyObject) {
        
        SVProgressHUD.show()

        if self.locationMapView.annotations.count > 0{
            var params:NSMutableDictionary = NSMutableDictionary(capacity: 8)
            params.setObject(User.shared.id, forKey: "owner")
            params.setObject((self.locationMapView.annotations[0].coordinate as CLLocationCoordinate2D).latitude, forKey: "latitude")
            params.setObject((self.locationMapView.annotations[0].coordinate as CLLocationCoordinate2D).longitude, forKey: "longitude")
            params.setObject(event!.date!, forKey: "startdate")
            params.setObject(event!.needLocation, forKey: "needLocation")
            params.setObject(self.eventTextView.text!, forKey: "message")
            params.setObject(User.shared.nickname!, forKey: "createdBy")
            params.setObject(User.shared.nickname!, forKey: "modifiedBy")
            
            var manager = AFHTTPRequestOperationManager()
            manager.requestSerializer.setValue("Token "+authToken!, forHTTPHeaderField: "Authorization")
            
            manager.POST(eventsURL,
                parameters: params,
                success: { (operation:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                    var response = JSONValue(object)
                    self.event!.eventID = response["id"].integer!
                    
                    var participantsParams:Dictionary = Dictionary<String, String>()
                    for p:Friend in self.participators!{
                        participantsParams[p.to_user!] = p.to_user!//.setObject(p.to_user!, forKey: p.to_user!)
                    }
                    var url = "http://54.255.168.161/events/\(self.event!.eventID)/set_participants/"
                    manager.POST(url,
                        parameters: participantsParams,
                        success: { (operation:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                            SVProgressHUD.showSuccessWithStatus("")
                            self.delegate?.CreateEventViewControllerDone(self)
                        },
                        failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                            println("set participant failed:"+error.description)
                    })
                },
                failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    println("create event failed:"+error.description)
            })
        }else{
            //todo
        }
    }
    
}
