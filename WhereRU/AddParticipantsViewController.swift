//
//  AddParticipantsViewController.swift
//  WhereRU
//
//  Created by RInz on 14/12/31.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

protocol AddParticipantsViewDelegate {
    func AddParticipantsDidDone(_: AddParticipantsViewController, _: [AVUser])
}

class AddParticipantsViewController: UIViewController {

    var delegate: AddParticipantsViewDelegate?
    
    @IBOutlet weak var selectNameView: TokenInputView!
    @IBOutlet weak var selectNameTableView: UITableView!
    
    var tableData = [AVUser]()
    var selectedFriends: Dictionary<Int, AVUser> = Dictionary<Int, AVUser>()
    var rowsCount:NSInteger = 0
    var names:NSArray?
    var filteredNames:NSArray?
    var selectedNames:NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        
        self.names = ["Brenden Mulligan","Cluster Labs, Inc.","Pat Fives","Rizwan Sattar","Taylor Hughes"]
        self.filteredNames = NSArray()
        self.selectedNames = NSMutableArray(capacity: self.names!.count)
        
        self.selectNameTableView.delegate = self
        self.selectNameTableView.dataSource = self
        
        self.selectNameTableView.hidden = false
        
        self.selectNameView.placeholderText = "搜索"
        self.selectNameView.drawBottomBorder = true
        self.selectNameView.delegate = self
        
        
//        var query = AVQuery(className: "Friends")
//        query.whereKey("from", equalTo: AVUser.currentUser())
//        query.findObjectsInBackgroundWithBlock { (obj:[AnyObject]!, error:NSError!) -> Void in
//            if (error == nil && obj.count > 0) {
//                var relation:AVRelation = (obj as! [AVObject])[0].objectForKey("to") as! AVRelation
//                var query = relation.query()
//                query.findObjectsInBackgroundWithBlock({ (friends:[AnyObject]!, error:NSError!) -> Void in
//                    if error == nil && friends.count > 0 {
//                        self.tableData = friends as! [AVUser]
//                        self.rowsCount = self.tableData.count
//                        self.tableView.reloadData()
//                    }
//                })
//                
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if !self.selectNameView.editing! {
            self.selectNameView.beginEditing()
        }
    }

//    @IBAction func done(sender: AnyObject) {
//        var selected:[AVUser] = [AVUser]()
//        for _selected in selectedFriends.values {
//            selected.append(_selected)
//        }
//        self.delegate?.AddParticipantsDidDone(self, selected)
//    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //
    }

}

extension AddParticipantsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
}

extension AddParticipantsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filteredNames == nil || self.filteredNames?.count == 0 {
            return self.names!.count
        }else {
            return self.filteredNames!.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.filteredNames != nil && self.filteredNames?.count != 0 {
            let name: String = self.filteredNames![indexPath.row] as! String
            let token: Token = Token(displayText: name, context: nil)
            if self.selectNameView.editing! {
                self.selectNameView.addToken(token)
            }
        }else {
            let name: String = self.names![indexPath.row] as! String
            let token: Token = Token(displayText: name, context: nil)
            if self.selectNameView.editing! {
                self.selectNameView.addToken(token)
            }
        }
        self.selectNameTableView.reloadData()
//        let cell:AddParticipantTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! AddParticipantTableViewCell
//        cell.tintColor = UIColor.blueColor()
//        if cell.selectedFriend {
//            cell.selectedFriend = false
//            cell.accessoryType = UITableViewCellAccessoryType.None
//            selectedFriends.removeValueForKey(indexPath.row)
//        } else {
//            cell.selectedFriend = true
//            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//            selectedFriends[indexPath.row] = tableData[indexPath.row]
//        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if  self.filteredNames != nil && self.filteredNames?.count != 0 {
            let cell: UITableViewCell = UITableViewCell()
            let name: String = self.filteredNames![indexPath.row] as! String
            cell.textLabel?.text = name
            if self.selectedNames!.containsObject(name) {
                cell.accessoryType = .Checkmark
            }else {
                cell.accessoryType = .None
            }
            return cell
        }else {
            let cell: UITableViewCell = UITableViewCell()
            let name: String = self.names![indexPath.row] as! String
            cell.textLabel?.text = name
            if self.selectedNames!.containsObject(name) {
                cell.accessoryType = .Checkmark
            }else {
                cell.accessoryType = .None
            }
            return cell
        }
        
//        let cellIdentifier:NSString = "AddParticipantTableViewCell"
//        let cell:AddParticipantTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier as String, forIndexPath: indexPath) as? AddParticipantTableViewCell
        //        cell!.name.text = tableData[indexPath.row].username
        //        let avatarObject: AnyObject! = tableData[indexPath.row].objectForKey("avatarFile")
        //        if avatarObject != nil {
        //            let avatarData = avatarObject.getData()
        //            cell!.avatar.image = UIImage(data: avatarData)
        //        } else {
        //            cell!.avatar.image = UIImage(named: "default_avatar")
        //        }
        
//        return cell!
    }
}

extension AddParticipantsViewController: TokenInputViewDelegate {
    func tokenInputView(view: TokenInputView, didChangeText text: String) {
        if text == "" {
            self.filteredNames = nil
        }else {
            let predicate: NSPredicate = NSPredicate(format: "self contains[cd] %@", text)
            self.filteredNames = self.names?.filteredArrayUsingPredicate(predicate)
            self.selectNameTableView.hidden = false
        }
        self.selectNameTableView.reloadData()
    }
    
    func tokenInputView(view: TokenInputView, didRemoveToken token: Token) {
        let name = token.displayText
        self.selectedNames!.removeObject(name!)
        self.selectNameTableView.reloadData()
    }
    
    func tokenInputView(view: TokenInputView, didAddToken token: Token) {
        let name = token.displayText
        self.selectedNames?.addObject(name!)
    }
    
    func tokenInputView(view: TokenInputView, tokenForText text: String) -> Token? {
        if self.filteredNames?.count > 0 {
            let matchingName: String = self.filteredNames![0] as! String
            let match: Token = Token(displayText: matchingName, context: nil)
            return match
        }
        return nil
    }
    
    func tokenInputViewDidEndEditing(view: TokenInputView) {
//        view.accessoryView = nil
    }
    
    func tokenInputViewDidBeginEditing(view: TokenInputView) {
        //
    }
    
    func tokenInputView(view: TokenInputView, didChangeHeightTo height: CGFloat) {
        //
    }
    
}
