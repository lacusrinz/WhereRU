//
//  MapViewController.swift
//  WhereRU
//
//  Created by RInz on 14-9-25.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, MAMapViewDelegate {

    var mapView: MAMapView?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMapView()
    }
    
    func initMapView() {
        mapView = MAMapView(frame: self.view.bounds)
        mapView!.delegate = self
        self.view.addSubview(mapView!)
        
        mapView!.showsUserLocation = true
        mapView!.userTrackingMode = MAUserTrackingMode.Follow
        
        mapView!.setZoomLevel(15.1, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
