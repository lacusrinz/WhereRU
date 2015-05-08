//
//  MapDetailViewController.swift
//  WhereRU
//
//  Created by RInz on 15/1/25.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

//protocol MapDetailViewControllerDelegate{
//    func MapDetailViewControllerBack()
//}

class MapDetailViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate {
    
    @IBOutlet weak var mapView: MAMapView!
    var coordinate:CLLocationCoordinate2D?
    var myLocationCoordinate:CLLocationCoordinate2D?
    var search:AMapSearchAPI?
    var route:AMapRoute?
    var searchType:AMapSearchType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]
        
//        initToolBar()
        
        mapView.frame = self.view.bounds
        mapView.delegate = self
        mapView.setZoomLevel(17.1, animated: true)
        
//        mapView.showsUserLocation = true
//        mapView.userTrackingMode = MAUserTrackingModeNone
        
//        self.search = AMapSearchAPI(searchKey: MAMapServices.sharedServices().apiKey, delegate: self)
    }
    
//    func initToolBar(){
//        var flexbleItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
//        var busButton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_car"), style: .Bordered, target: self, action: "searchNaviDrive")
//        var carButton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_bus"), style: .Bordered, target: self, action: "searchNaviBus")
//        var walkButton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_walk"), style: .Bordered, target: self, action: "searchNaviWalk")
//        var timeLabel:UIBarButtonItem = UIBarButtonItem(title: "约5分钟", style: .Bordered, target: self, action: nil)
//        self.toolbarItems = [flexbleItem, busButton, flexbleItem, timeLabel, flexbleItem, carButton, flexbleItem, walkButton, flexbleItem]
//        self.navigationController?.toolbar.barStyle = .Default
//        self.navigationController?.toolbar.translucent = false
//        self.navigationController?.toolbar.tintColor = UIColor.redColor()
//        self.navigationController?.setToolbarHidden(false, animated: false)
//    }
    
    override func viewDidAppear(animated: Bool) {
        var point: MAPointAnnotation = MAPointAnnotation()
        point.coordinate = coordinate!
        point.title = "A"
        mapView.setCenterCoordinate(point.coordinate, animated: true)
        mapView.addAnnotation(point)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
//        if updatingLocation{
//            mapView.showsUserLocation = false
//            println("location:\(userLocation.description)")
//            myLocationCoordinate = userLocation.location.coordinate
//            
////            var point: MAPointAnnotation = MAPointAnnotation()
////            point.coordinate = myLocationCoordinate!
////            point.title = "Me"
////            mapView.addAnnotation(point)
//            var mapPoints = Array<MAMapPoint>()
//            mapPoints.append(MAMapPointForCoordinate(myLocationCoordinate!))
//            mapPoints.append(MAMapPointForCoordinate(coordinate!))
//            self.mapView.visibleMapRect = CommonUtility.minMapRectForMapPoints(mapPoints, count: 2)
////            self.searchNaviDrive()
//        }
//    }
    
//    func searchNaviDrive(){
//        var navi:AMapNavigationSearchRequest = AMapNavigationSearchRequest()
//        self.searchType = .NaviDrive
//        navi.searchType = .NaviDrive
//        navi.requireExtension = true
//        
//        navi.destination = AMapGeoPoint.locationWithLatitude(CGFloat(coordinate!.latitude), longitude: CGFloat(coordinate!.longitude))
//        navi.origin = AMapGeoPoint.locationWithLatitude(CGFloat(myLocationCoordinate!.latitude), longitude: CGFloat(myLocationCoordinate!.longitude))
//
//        self.search?.AMapNavigationSearch(navi)
//    }
//    
//    func searchNaviWalk(){
//        var navi:AMapNavigationSearchRequest = AMapNavigationSearchRequest()
//        navi.searchType = .NaviWalking
//        navi.searchType = .NaviWalking
//        navi.requireExtension = true
//        navi.destination = AMapGeoPoint.locationWithLatitude(CGFloat(coordinate!.latitude), longitude: CGFloat(coordinate!.longitude))
//        navi.origin = AMapGeoPoint.locationWithLatitude(CGFloat(myLocationCoordinate!.latitude), longitude: CGFloat(myLocationCoordinate!.longitude))
//        self.search?.AMapNavigationSearch(navi)
//    }
//    
//    func searchNaviBus(){
//        var navi:AMapNavigationSearchRequest = AMapNavigationSearchRequest()
//        self.searchType = .NaviBus
//        navi.searchType = .NaviBus
//        navi.requireExtension = true
//        navi.destination = AMapGeoPoint.locationWithLatitude(CGFloat(coordinate!.latitude), longitude: CGFloat(coordinate!.longitude))
//        navi.origin = AMapGeoPoint.locationWithLatitude(CGFloat(myLocationCoordinate!.latitude), longitude: CGFloat(myLocationCoordinate!.longitude))
//        self.search?.AMapNavigationSearch(navi)
//    }
//    
//    func presentCurrentCourse(){
//        var polylines:NSArray?
//        polylines = nil
//        /* 公交导航. */
//        if (self.searchType == .NaviBus)
//        {
//            polylines = CommonUtility.polylinesForPath((self.route!.transits as NSArray)[0] as? AMapPath)
//        }
//        /* 步行，驾车导航. */
//        else
//        {
//            println("My Path:\((self.route!.paths as NSArray)[0])")
//            polylines = CommonUtility.polylinesForPath((self.route!.paths as NSArray)[0] as? AMapPath)
//            println("My Polylines lalala: \(polylines)")
//        }
//        self.mapView.addOverlays(polylines)
//        
//        self.mapView.visibleMapRect = CommonUtility.mapRectForOverlays(polylines!)
//    }
    
    //MARK: - AMapSearchDelegate
//    func onNavigationSearchDone(request: AMapNavigationSearchRequest!, response: AMapNavigationSearchResponse!) {
//        if let route = response.route{
//            self.route = route
//            println("route:\(self.route)")
//            self.presentCurrentCourse()
//        }
//    }
    
    //MARK: - MAMapViewDelegate
//    func mapView(mapView: MAMapView!, viewForOverlay overlay: MAOverlay!) -> MAOverlayView! {
//        if overlay.isKindOfClass(LineDashPolyline){
//            var overlayView:MAPolylineView = MAPolylineView(polyline: (overlay as LineDashPolyline).polyline)
//            overlayView.lineWidth = 4
//            overlayView.strokeColor = UIColor.redColor()
//            return overlayView
//        }
//        if overlay.isKindOfClass(MAPolyline){
//            var overlayView:MAPolylineView = MAPolylineView(polyline: overlay as MAPolyline)
//            overlayView.lineWidth = 8
//            overlayView.strokeColor = UIColor.blackColor()
//            return overlayView
//        }
//        return nil
//    }
    
    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKindOfClass(MAPointAnnotation){
            let pointReuseIndetifier = "pointReuseIndetifier"
            var poiAnnotationView:MAPinAnnotationView? = self.mapView.dequeueReusableAnnotationViewWithIdentifier(pointReuseIndetifier) as! MAPinAnnotationView?
            if poiAnnotationView == nil{
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            poiAnnotationView?.animatesDrop = true
            poiAnnotationView?.canShowCallout = false
            poiAnnotationView?.draggable = false;
            return poiAnnotationView
        }
        return nil
    }
}