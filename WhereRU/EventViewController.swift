//
//  EventViewController.swift
//  WhereRU
//
//  Created by RInz on 14/10/26.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, JASwipeCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tableData:NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableData = NSArray(array: ["xx","xxxx","xxxxx"])
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rightButtons()->NSArray{
        var deleteRightButton: JAActionButton = JAActionButton(actionButtonWithTitle: "Delete", color: UIColor.redColor()) { (actionButton, cell) -> Void in
            //todo
            println("delete")
        }
        var buttonArray:NSArray = NSArray(array: [deleteRightButton])
        return buttonArray;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:EventTableViewCell = EventTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "JATableViewCellIdentifier");
        cell.textLabel.text = "111"
        cell.addActionButtons(self.rightButtons(), withButtonWidth: 60, withButtonPosition: JAButtonLocation.Right)
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func leftMostButtonSwipeCompleted(cell: JASwipeCell!) {
        //todo
    }
    
    func rightMostButtonSwipeCompleted(cell: JASwipeCell!) {
        //todo
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
