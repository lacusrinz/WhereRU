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

class AddContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var contactSearchBar: UISearchBar!
    @IBOutlet var displayController: UISearchDisplayController!
    @IBOutlet weak var tableView: UITableView!
    
    var users:[AVUser]?
    var delegate:AddContactViewControllerDelegate?
    var key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.users = [AVUser]()
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.displayController?.setActive(false, animated: false)
        self.contactSearchBar.placeholder = self.key;
        searchUserWithKey(self.key)
    }
    
    //MARK: - UISearchDisplayDelegate
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.key = searchString
        return true
    }
    
    func searchUserWithKey(searchString:String) {
        var query:AVQuery = AVUser.query()
        query.whereKey("username", containsString: searchString)
        query.findObjectsInBackgroundWithBlock { (objs:[AnyObject]!, error:NSError!) -> Void in
            if error == nil && objs.count>0 {
                self.users = objs as? [AVUser]
                self.tableView.reloadData()
            }else {
                self.users!.removeAll(keepCapacity: true)
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - SearchBar UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.displayController.searchResultsTableView {
            return 1
        } else {
            return self.users!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.displayController.searchResultsTableView {
            let userCellIdentifier = "userCellIdentifier"
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(userCellIdentifier) as? UITableViewCell
            if cell == nil{
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: userCellIdentifier)
            }
            cell!.textLabel!.text = "搜索: \(self.key)"
            return cell!
        }else {
            let userCellIdentifier = "userCellIdentifier"
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(userCellIdentifier) as? UITableViewCell
            if cell == nil{
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: userCellIdentifier)
            }
            var user:AVUser = self.users![indexPath.row]
            cell?.textLabel?.text = user.username
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.displayController.searchResultsTableView {
            self.displayController?.setActive(false, animated: false)
            self.contactSearchBar.placeholder = self.key
            searchUserWithKey(self.key)
        }else {
            //
        }
    }

    
    @IBAction func back(sender: AnyObject) {
        self.delegate!.AddContactViewControllerBack(self)
    }
}
