//
//  AddContactViewController.swift
//  WhereRU
//
//  Created by RInz on 14/11/21.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

protocol AddContactViewControllerDelegate {
    func AddContactViewControllerBack(controller:AddContactViewController)
}

class AddContactViewController: UIViewController {
    @IBOutlet weak var contactSearchBar: UISearchBar!
    @IBOutlet var displayController: UISearchDisplayController!
    
    var users:[AVUser]?
    var delegate:AddContactViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.users = [AVUser]()
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var key = searchBar.text;
        self.displayController?.setActive(false, animated: false)
        self.contactSearchBar.placeholder = key;
    }
    
    //MARK: - UISearchDisplayDelegate
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.searchUserWithKey(searchString)
        return true
    }
    
    func searchUserWithKey(searchString:String) {
        var query:AVQuery = AVUser.query()
        query.whereKey("username", containsString: searchString)
        query.findObjectsInBackgroundWithBlock { (objs:[AnyObject]!, error:NSError!) -> Void in
            if error == nil && objs.count>0 {
                self.users = objs as? [AVUser]
                self.displayController!.searchResultsTableView.reloadData()
            }
        }
    }
    
    //MARK: - SearchBar UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let userCellIdentifier = "userCellIdentifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(userCellIdentifier) as? UITableViewCell
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: userCellIdentifier)
        }
        var user:AVUser = self.users![indexPath.row]
        cell?.textLabel?.text = user.username
        return cell!
    }
    
    @IBAction func back(sender: AnyObject) {
        self.delegate!.AddContactViewControllerBack(self)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var user:AVUser = self.users![indexPath.row]
        self.displayController?.setActive(false, animated: false)
        self.contactSearchBar.placeholder = user.username
    }
}
