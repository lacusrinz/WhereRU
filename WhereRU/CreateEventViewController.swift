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
}

class CreateEventViewController: UIViewController,  MAMapViewDelegate, AMapSearchDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate {

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
    
    var participators:[Participant]?
    
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
        
        //test data
        var p1 = Participant()
        p1.nickname="A"
        p1.avatar = ""
        var p2 = Participant()
        p2.nickname="B"
        p2.avatar = ""
        var p3 = Participant()
        p3.nickname="C"
        p3.avatar = ""
        var p4 = Participant()
        p4.nickname="D"
        p4.avatar = ""
        var p5 = Participant()
        p5.nickname="E"
        p5.avatar = ""
        var p6 = Participant()
        p6.nickname="F"
        p6.avatar = ""
        participators = [p1,p2,p3,p4,p5,p6]
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
            self.locationMapView.setCenterCoordinate(annotations[0].coordinate, animated: true)
        }else{
            self.locationMapView.setVisibleMapRect(CommonUtility.minMapRectForAnnotations(annotations), animated: true)
        }
        self.locationMapView .addAnnotations(annotations)
    }
    
    func onReGeocodeSearchDone(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if response.regeocode != nil{
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
        }else{
            cell.participatorAvatarImage.setImageWithURL(NSURL(string: participators![indexPath.row].avatar!), placeholderImage: UIImage(named: "default_avatar"), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            cell.participatorAvatarImage.layer.borderWidth = 1
            cell.isParticipator = true;
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
                    var D:Participant = Participant()
                    D.nickname = "D"
                    D.avatar = ""
                    self.participators?.append(D)
                    self.participatorCollectionView.insertItemsAtIndexPaths([tapCellPath!])
                    self.participatorCollectionView.reloadData()
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func Back(sender: AnyObject) {
        self.delegate?.CreateEventViewControllerDidBack(self)
    }
    
    @IBAction func Done(sender: AnyObject) {
    }
    
    //// MARK: -

}
