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

class ViewEventViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var avatarImage: avatarImageView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var participantsCollection: UICollectionView!
    
    private var authToken:String?
    private var manager = AFHTTPRequestOperationManager()
    
    var participators:[Friend]?
    var event:Event?
    var delegate:ViewEventViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authToken = User.shared.token
        if event!.owner != User.shared.id{
            self.manager.requestSerializer.setValue("Token "+authToken!, forHTTPHeaderField: "Authorization")
            self.manager.GET("http://54.255.168.161/friends/\(event!.owner)/",
                parameters: nil,
                success: { (request:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                    var response = JSONValue(object)
                    var avatar:String = response["avatar"].string!
                    self.avatarImage.setImageWithURL(NSURL(string: avatar), placeholderImage: UIImage(named: "default_avatar"), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
                }) { (request:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    println("get owner avatar failed: \(error.description)")
            }
        }else{
             self.avatarImage.setImageWithURL(NSURL(string: User.shared.avatar!), placeholderImage: UIImage(named: "default_avatar"), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        }
        
        message.text = event!.Message
        message.layer.borderColor = UIColor.blackColor().CGColor
        message.layer.borderWidth = 1
        participators = []
        
        participantsCollection.delegate = self
        participantsCollection.dataSource = self
        
        self.manager.requestSerializer.setValue("Token "+authToken!, forHTTPHeaderField: "Authorization")
        self.manager.GET("http://54.255.168.161/participants/by_event/?eventid=\(event!.eventID!)",
            parameters: nil,
            success: { (request:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                var response = JSONValue(object)
                var sum:Int = response["count"].integer!
                for var i=0; i<sum; ++i{
                    var participant:Friend = Friend()
                    participant.to_user = response["results"][i]["nickname"].string
                    participant.from_user = User.shared.nickname
                    participant.avatar = response["results"][i]["avatar"].string
                    self.participators?.append(participant)
                }
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
        var cell: ParticipatorCollectionViewCell = participantsCollection.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as ParticipatorCollectionViewCell

        cell.participatorAvatarImage.setImageWithURL(NSURL(string: participators![indexPath.row].avatar!), placeholderImage: UIImage(named: "default_avatar"), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        cell.participatorAvatarImage.layer.borderWidth = 1
        cell.isParticipator = true
        
        return cell
    }
}
