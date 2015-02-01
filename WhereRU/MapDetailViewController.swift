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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        
        initToolBar()
        
        mapView.frame = self.view.bounds
        mapView.delegate = self
        mapView.setZoomLevel(15.1, animated: true)
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.None
    }
    
    func initToolBar(){
        var flexbleItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        var busButton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_bus"), style: .Bordered, target: self, action: "getNavigation")
        var carButton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_car"), style: .Bordered, target: self, action: "getNavigation")
        var walkButton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_walk"), style: .Bordered, target: self, action: "getNavigation")
        var timeLabel:UIBarButtonItem = UIBarButtonItem(title: "约5分钟", style: .Bordered, target: self, action: nil)
        self.toolbarItems = [flexbleItem, busButton, flexbleItem, timeLabel, flexbleItem, carButton, flexbleItem, walkButton, flexbleItem]
        self.navigationController?.toolbar.barStyle = .Default
        self.navigationController?.toolbar.translucent = false
        self.navigationController?.toolbar.tintColor = UIColor.redColor()
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
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
    
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation{
            mapView.showsUserLocation = false
            println("location:\(userLocation.location)")
            myLocationCoordinate = userLocation.location.coordinate
        }
    }
    
    func getNavigation(){
        //todo
    }

}
