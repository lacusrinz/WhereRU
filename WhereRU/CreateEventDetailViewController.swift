//
//  CreateEventDetailViewController.swift
//  WhereRU
//
//  Created by RInz on 14/12/28.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

protocol CreateEventDetailViewControllerDelegate{
    func CreateEventDetailViewControllerDone(CreateEventDetailViewController, String, Bool)
}

class CreateEventDetailViewController: UITableViewController{

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var needLocation: UISwitch!
    var date:String?
    var need:Bool = true
    
    var delegate:CreateEventDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]
        self.navigationController?.navigationBar.translucent = false
        
        self.tableView.tableFooterView = UIView()
        if date != nil{
            var dateFormate:NSDateFormatter = NSDateFormatter()
            dateFormate.dateFormat = "yyyy-MM-dd HH:mm"
            var datetime = dateFormate.dateFromString(date!)
            datePicker.setDate(datetime!, animated: true)
            needLocation.on = need
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Done(sender: AnyObject) {
        var dateFormate:NSDateFormatter = NSDateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm"//.setLocalizedDateFormatFromTemplate("yyyy - MM - dd HH:mm")
        var date:String = dateFormate.stringFromDate(datePicker.date)
        self.delegate?.CreateEventDetailViewControllerDone(self, date, needLocation.on)
//        self.dismissViewControllerAnimated(true, completion: nil)
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
