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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.setZoomLevel(15.1, animated: true)
        
        var point: MAPointAnnotation = MAPointAnnotation()
        point.coordinate = coordinate!
        point.title = "目的地"
        mapView.setCenterCoordinate(point.coordinate, animated: true)
        mapView.addAnnotation(point)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
