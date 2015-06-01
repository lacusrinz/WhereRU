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
    var participatorsPaintTimer:NSTimer?
    var participators:[AVUser]?
    var allParticipantsPoints:[ParticipantAnnotation]?
    var allParticipantsAvatars:[UIImage]?
    var eventOwner:AVUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]
        
//        initToolBar()
        
        mapView.frame = self.view.bounds
        mapView.delegate = self
        mapView.setZoomLevel(17.1, animated: true)
        
        mapView.showsUserLocation = true
        
        allParticipantsPoints = [ParticipantAnnotation]()
        allParticipantsAvatars = [UIImage]()
        
        for user in self.participators! {
            var query:AVQuery? = AVQuery(className: "_User")
            query!.whereKey("username", equalTo: user.username)
            var userObj:AVUser = query!.getFirstObject() as! AVUser
            var avatarObject: AnyObject! = userObj.objectForKey("avatarFile")
            if avatarObject != nil {
                var avatarData = avatarObject.getData()
                self.allParticipantsAvatars!.append(UIImage(data: avatarData)!)
            } else {
                self.allParticipantsAvatars!.append(UIImage(named: "default_avatar")!)
            }
        }
        var query:AVQuery? = AVQuery(className: "_User")
        query!.whereKey("username", equalTo: eventOwner!.username)
        var userObj:AVUser = query!.getFirstObject() as! AVUser
        var avatarObject: AnyObject! = userObj.objectForKey("avatarFile")
        if avatarObject != nil {
            var avatarData = avatarObject.getData()
            self.allParticipantsAvatars!.append(UIImage(data: avatarData)!)
        } else {
            self.allParticipantsAvatars!.append(UIImage(named: "default_avatar")!)
        }
    }
    
    func startPaint() {
        self.participatorsPaintTimer = NSTimer(timeInterval: 15, target: self, selector: "paint", userInfo: nil, repeats: true)
    }
    
    func stopPaint() {
        if self.participatorsPaintTimer != nil {
            self.participatorsPaintTimer!.invalidate()
        }
    }
    
    func paint() {
        if self.allParticipantsPoints!.count > 0 {
            mapView.removeAnnotations(self.allParticipantsPoints)
        }
        for var i:Int=0; i<self.participators!.count; i++ {
            if self.participators![i].username != AVUser.currentUser().username {
                var query:AVQuery? = AVQuery(className: "_User")
                query!.whereKey("username", equalTo: self.participators![i].username)
                var userObj:AVUser = query!.getFirstObject() as! AVUser
                var hisCoordinate:AVGeoPoint? = userObj.objectForKey("location") as? AVGeoPoint
                
                if hisCoordinate != nil {
                    var point: ParticipantAnnotation = ParticipantAnnotation()
                    point._coordinate = CLLocationCoordinate2D(latitude: hisCoordinate!.latitude, longitude: hisCoordinate!.longitude)
                    point._avatarImage = self.allParticipantsAvatars![i]
                    point._name = self.participators![i].username
                    allParticipantsPoints!.append(point)
                }
            }
        }
        if eventOwner != AVUser.currentUser() {
            var query:AVQuery? = AVQuery(className: "_User")
            query!.whereKey("username", equalTo: eventOwner!.username)
            var userObj:AVUser = query!.getFirstObject() as! AVUser
            var hisCoordinate:AVGeoPoint? = userObj.objectForKey("location") as? AVGeoPoint
            
            if hisCoordinate != nil {
                var point: ParticipantAnnotation = ParticipantAnnotation()
                point._coordinate = CLLocationCoordinate2D(latitude: hisCoordinate!.latitude, longitude: hisCoordinate!.longitude)
                point._avatarImage = self.allParticipantsAvatars![self.participators!.count]
                allParticipantsPoints!.append(point)
            }
        }
        mapView.addAnnotations(self.allParticipantsPoints)
    }

    
    override func viewDidAppear(animated: Bool) {
        var targetPoint:TargetAnnotation = TargetAnnotation()
        targetPoint._coordinate = coordinate!
        
        mapView.addAnnotation(targetPoint)
        myLocationCoordinate = mapView.userLocation.location.coordinate
        
        var mapPoints = Array<MAMapPoint>()
        mapPoints.append(MAMapPointForCoordinate(myLocationCoordinate!))
        mapPoints.append(MAMapPointForCoordinate(coordinate!))
        self.mapView.setVisibleMapRect(CommonUtility.minMapRectForMapPoints(mapPoints, count: 2), edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
        
        self.startPaint()
        NSRunLoop.currentRunLoop().addTimer(self.participatorsPaintTimer!, forMode: NSDefaultRunLoopMode)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.stopPaint()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation{
            println("location:\(userLocation.description)")
            var userLocationPoint:AVGeoPoint = AVGeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            AVUser.currentUser().setObject(userLocationPoint, forKey: "location")
            AVUser.currentUser().save()
        }
    }
    
    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKindOfClass(ParticipantAnnotation) {
            let customReuseIndetifier = "customReuseIndetifier"
            var customAnnotationView:CustomAnnotationView? = self.mapView.dequeueReusableAnnotationViewWithIdentifier(customReuseIndetifier) as! CustomAnnotationView?
            if customAnnotationView == nil{
                customAnnotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: customReuseIndetifier)
            }
            customAnnotationView!.avatarImageView.image = (annotation as! ParticipantAnnotation)._avatarImage
            customAnnotationView!.name = (annotation as! ParticipantAnnotation)._name
            customAnnotationView!.canShowCallout = false
            customAnnotationView!.draggable = false;
            return customAnnotationView
        }
        if annotation.isKindOfClass(TargetAnnotation) {
            let customReuseIndetifier = "customReuseIndetifier"
            var customAnnotationView:CustomAnnotationView? = self.mapView.dequeueReusableAnnotationViewWithIdentifier(customReuseIndetifier) as! CustomAnnotationView?
            if customAnnotationView == nil{
                customAnnotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: customReuseIndetifier)
            }
            customAnnotationView!.canShowCallout = false
            customAnnotationView!.draggable = false;
            customAnnotationView!.avatarImageView.image = UIImage(named: "icon_target")
            return customAnnotationView
        }
        return nil
    }
    
}
