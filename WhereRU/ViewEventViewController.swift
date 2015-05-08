//
//  ViewEventViewController.swift
//  WhereRU
//
//  Created by RInz on 15/1/21.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

protocol ViewEventViewControllerDelegate{
    func ViewEventViewControllerDidBack(ViewEventViewController)
}

class ViewEventViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var avatarImage: avatarImageView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var participantsCollection: UICollectionView!
    @IBOutlet var mapTapGesture: UITapGestureRecognizer!

    
    var participators:[AVUser]?
    var event:Event?
    var delegate:ViewEventViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]
        
        mapTapGesture = UITapGestureRecognizer(target: self, action: "getMap")
        mapTapGesture.delegate = self
        mapImage.addGestureRecognizer(mapTapGesture)
        
        var avatarObject: AnyObject! = event!.owner!.objectForKey("avatarFile")
        self.avatarImage.image = UIImage(data: avatarObject.getData())
        
        message.text = event!.message
        message.layer.borderColor = UIColor.blackColor().CGColor
        message.layer.borderWidth = 1
        message.editable = false
        participators = []
        
        participantsCollection.delegate = self
        participantsCollection.dataSource = self
        
        participators = event!.participants
        
        var longitude = NSString(string: "\(event!.coordinate!.longitude)").substringToIndex(7)
        var latitude = NSString(string: "\(event!.coordinate!.latitude)").substringToIndex(7)
        var width = NSString(string: "\(self.mapImage.frame.width)").substringToIndex(3)
        var height = NSString(string: "\(self.mapImage.frame.height)").substringToIndex(3)
        
        var imageURL = "http://restapi.amap.com/v3/staticmap?location=\(longitude),\(latitude)&zoom=15&size=\(width)*\(height)&scale=2&markers=mid,,A:\(longitude),\(latitude)&key=992a5459adc4de286ea6e3acdda61f9f"
        mapImage.setImageWithURL(NSURL(string: imageURL), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func Back(sender: AnyObject) {
        self.delegate?.ViewEventViewControllerDidBack(self)
    }
    
    // MARK: - CollectionViewDelegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participators!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier:NSString = "ParticipatorCollectionViewCell"
        var cell: ParticipatorCollectionViewCell = participantsCollection.dequeueReusableCellWithReuseIdentifier(cellIdentifier as String, forIndexPath: indexPath) as! ParticipatorCollectionViewCell

        var avatarObj:AnyObject! = participators![indexPath.row].objectForKey("avatarFile")
        if avatarObj != nil {
            cell.participatorAvatarImage.image = UIImage(data: avatarObj.getData())
        }else {
            cell.participatorAvatarImage.image = UIImage(named: "default_avatar")
        }
        cell.participatorAvatarImage.layer.borderWidth = 1
        cell.isParticipator = true
        
        return cell
    }
    
    //MARK: - handle gesture
    func getMap(){
        performSegueWithIdentifier("getMap", sender: self)
    }
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "getMap"{
            let navigationController:UINavigationController = segue.destinationViewController as! UINavigationController
            let mapDetailViewController:MapDetailViewController = navigationController.viewControllers[0] as! MapDetailViewController
//            mapDetailViewController.delegate = self
            mapDetailViewController.coordinate = event!.coordinate!
        }
    }
}
