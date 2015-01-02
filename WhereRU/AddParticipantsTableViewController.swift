//
//  AddParticipantsTableViewController.swift
//  WhereRU
//
//  Created by RInz on 14/12/31.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

protocol AddParticipantsTableViewDelegate{
    func AddParticipantsDidDone(AddParticipantsTableViewController, [Friend])
}

class AddParticipantsTableViewController: UITableViewController {

    var delegate: AddParticipantsTableViewDelegate?
    
    var tableData = [Friend]()
    var selectedFriends: Dictionary<Int, Friend> = Dictionary<Int, Friend>()
    var rowsCount:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableData = User.shared.friends
        rowsCount = tableData.count
        
//        selectedFriends = tableData
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
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
        var cell:AddParticipantTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as AddParticipantTableViewCell
        if cell.selectedFriend{
            cell.selectedFriend = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            selectedFriends.removeValueForKey(indexPath.row)
        }else{
            cell.selectedFriend = true
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedFriends[indexPath.row] = tableData[indexPath.row]
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:NSString = "AddParticipantTableViewCell"
        var cell:AddParticipantTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? AddParticipantTableViewCell
        cell?.name.text = tableData[indexPath.row].to_user
        cell?.avatar.setImageWithURL(NSURL(string: tableData[indexPath.row].avatar!), placeholderImage: UIImage(named: "default_avatar"), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
        return cell!
    }

    @IBAction func done(sender: AnyObject) {
        var selected:[Friend] = [Friend]()
        for _selected in selectedFriends.values{
            selected.append(_selected)
        }
        self.delegate?.AddParticipantsDidDone(self, selected)
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //
    }

}
