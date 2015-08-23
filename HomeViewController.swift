//
//  HomeViewController.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/4.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: avatarImageView!
    @IBOutlet weak var todayListTable: UITableView!
    
//    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.todayListTable.delegate = self
        self.todayListTable.dataSource = self
        
        let navBar = self.navigationController!.navigationBar
        navBar.barTintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonClick(sender: AnyObject) {
        //
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.todayListTable.registerNib(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "eventCell")
        let cell:EventCell = self.todayListTable.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventCell
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //
    }

}
