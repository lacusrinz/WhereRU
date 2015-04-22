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
    
    private var authToken:String?
    private var manager = AFHTTPRequestOperationManager()
    
    var participators:[Friend]?
    var event:Event?
    var delegate:ViewEventViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]
        
        mapTapGesture = UITapGestureRecognizer(target: self, action: "getMap")
        mapTapGesture.delegate = self
        mapImage.addGestureRecognizer(mapTapGesture)
        
        authToken = User.shared.token
        if event!.owner != User.shared.id{
            self.manager.requestSerializer.setValue("Token "+authToken!, forHTTPHeaderField: "Authorization")
            var url = ""//String(format: friendByIdURL, event!.owner)
            self.manager.GET(url,
                parameters: nil,
                success: { (request:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                }) { (request:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    println("get owner avatar failed: \(error.description)")
            }
        }else{
             self.avatarImage.setImageWithURL(NSURL(string: User.shared.avatar!), placeholderImage: UIImage(named: "default_avatar"), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        }
        
        message.text = event!.message
        message.layer.borderColor = UIColor.blackColor().CGColor
        message.layer.borderWidth = 1
        message.editable = false
        participators = []
        
        participantsCollection.delegate = self
        participantsCollection.dataSource = self
        
        self.manager.requestSerializer.setValue("Token "+authToken!, forHTTPHeaderField: "Authorization")
        var url = String(format: participantsInEventURL, event!.eventID!)
        self.manager.GET(url,
            parameters: nil,
            success: { (request:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                self.participantsCollection.reloadData()
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("Get Participants Failed: \(error.description)")
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var longitude = NSString(string: "\(event!.coordinate!.longitude)").substringToIndex(7)
        var latitude = NSString(string: "\(event!.coordinate!.latitude)").substringToIndex(7)
        var width = NSString(string: "\(self.mapImage.frame.width)").substringToIndex(3)
        var height = NSString(string: "\(self.mapImage.frame.height)").substringToIndex(3)
        
        var imageURL = "http://restapi.amap.com/v3/staticmap?location=\(longitude),\(latitude)&zoom=15&size=\(width)*\(height)&scale=2&markers=mid,,A:\(longitude),\(latitude)&key=992a5459adc4de286ea6e3acdda61f9f"
        mapImage.setImageWithURL(NSURL(string: imageURL), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
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

        cell.participatorAvatarImage.setImageWithURL(NSURL(string: participators![indexPath.row].avatar!), placeholderImage: UIImage(named: "default_avatar"), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
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
