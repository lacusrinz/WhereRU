//
//  AddParticipantsTableViewController.swift
//  WhereRU
//
//  Created by RInz on 14/12/31.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

protocol AddParticipantsTableViewDelegate {
    func AddParticipantsDidDone(AddParticipantsTableViewController, [AVUser])
}

class AddParticipantsTableViewController: UITableViewController {

    var delegate: AddParticipantsTableViewDelegate?
    
    var tableData = [AVUser]()
    var selectedFriends: Dictionary<Int, AVUser> = Dictionary<Int, AVUser>()
    var rowsCount:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]
        
        var query = AVQuery(className: "Friends")
        query.whereKey("from", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (obj:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil && obj.count > 0) {
                var relation:AVRelation = (obj as! [AVObject])[0].objectForKey("to") as! AVRelation
                var query = relation.query()
                query.findObjectsInBackgroundWithBlock({ (friends:[AnyObject]!, error:NSError!) -> Void in
                    if error == nil && friends.count > 0 {
                        self.tableData = friends as! [AVUser]
                        self.rowsCount = self.tableData.count
                        self.tableView.reloadData()
                    }
                })
                
            }
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsCount
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell:AddParticipantTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! AddParticipantTableViewCell
        cell.tintColor = UIColor.blueColor()
        if cell.selectedFriend {
            cell.selectedFriend = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            selectedFriends.removeValueForKey(indexPath.row)
        } else {
            cell.selectedFriend = true
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedFriends[indexPath.row] = tableData[indexPath.row]
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:NSString = "AddParticipantTableViewCell"
        var cell:AddParticipantTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier as String, forIndexPath: indexPath) as? AddParticipantTableViewCell
        cell!.name.text = tableData[indexPath.row].username
        var avatarObject: AnyObject! = tableData[indexPath.row].objectForKey("avatarFile")
        if avatarObject != nil {
            var avatarData = avatarObject.getData()
            cell!.avatar.image = UIImage(data: avatarData)
        } else {
            cell!.avatar.image = UIImage(named: "default_avatar")
        }
        
        return cell!
    }

    @IBAction func done(sender: AnyObject) {
        var selected:[AVUser] = [AVUser]()
        for _selected in selectedFriends.values {
            selected.append(_selected)
        }
        self.delegate?.AddParticipantsDidDone(self, selected)
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //
    }

}
