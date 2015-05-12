//
//  AddFriendTableViewCell.swift
//  WhereRU
//
//  Created by RInz on 15/5/7.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

class AddFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: avatarImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    var friend:AVUser?
    var myFriendsObj:AVObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addFriend(sender: AnyObject) {
        if myFriendsObj != nil {
            var toRelation:AVRelation = myFriendsObj!.relationforKey("to")
            toRelation.addObject(friend)
            myFriendsObj!.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                self.addFriendButton.enabled = false
                self.addFriendButton.setBackgroundImage(UIImage(named: "button_addfrienddone"), forState: UIControlState.Disabled)
            })
        }else {
            myFriendsObj = AVObject(className: "Friends")
            var fromRelation:AVRelation = myFriendsObj!.relationforKey("from")
            fromRelation.addObject(AVUser.currentUser())
            var toRelation:AVRelation = myFriendsObj!.relationforKey("to")
            toRelation.addObject(friend)
            myFriendsObj!.setObject(true, forKey: "isTrue")
            myFriendsObj!.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                self.addFriendButton.enabled = false
                self.addFriendButton.setBackgroundImage(UIImage(named: "button_addfrienddone"), forState: UIControlState.Disabled)
            })
        }
    }
}
