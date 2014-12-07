//
//  CreateEventViewController.swift
//  WhereRU
//
//  Created by RInz on 14/12/7.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

class CreateEventViewController: UIViewController,  MAMapViewDelegate {

    @IBOutlet weak var locationMapView: MAMapView!
    @IBOutlet weak var myAvatarImageView: avatarImageView!
    @IBOutlet weak var eventTextView: UITextView!
    @IBOutlet weak var participatorCollectionView: UICollectionView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMapView.delegate = self
        locationMapView.showsUserLocation = true
        locationMapView.userTrackingMode = MAUserTrackingMode.Follow
        locationMapView.setZoomLevel(15.1, animated: true)
        
        eventTextView.layer.borderColor = UIColor.blackColor().CGColor
        eventTextView.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
