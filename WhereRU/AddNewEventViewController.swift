//
//  AddNewEventViewController.swift
//  WhereRU
//
//  Created by RInz on 16/1/8.
//  Copyright © 2016年 RInz. All rights reserved.
//

import UIKit

class AddNewEventViewController: UIViewController {

    @IBOutlet weak var startTimeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var endTimeHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteFextView: UITextView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var endTimeDatePicker: UIDatePicker!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        startTimeHeightConstraint.constant = 0
        endTimeHeightConstraint.constant = 0
        self.titleTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func create(sender: AnyObject) {
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
