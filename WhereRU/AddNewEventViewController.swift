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
    
    let format = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        startTimeHeightConstraint.constant = 0
        endTimeHeightConstraint.constant = 0
        self.titleTextField.becomeFirstResponder()
        
        let startTimeTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapStartTimeLabel")
        let endTimeTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapEndTimeLabel")
        startTimeLabel.addGestureRecognizer(startTimeTapGesture)
        endTimeLabel.addGestureRecognizer(endTimeTapGesture)
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
    
    func tapStartTimeLabel() {
        if startTimeHeightConstraint.constant > 0 {
            startTimeDatePicker.hidden = true
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.startTimeHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
                self.format.dateFormat = "yyyy MMM dd日 hh:mm"
                self.startTimeLabel.text = self.format.stringFromDate(self.startTimeDatePicker.date)
            })
        } else {
            startTimeDatePicker.hidden = false
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.startTimeHeightConstraint.constant = 139
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func tapEndTimeLabel() {
        if endTimeHeightConstraint.constant > 0 {
            endTimeDatePicker.hidden = true
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.endTimeHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
                self.format.dateFormat = "yyyy MMM dd日 hh:mm"
                self.endTimeLabel.text = self.format.stringFromDate(self.endTimeDatePicker.date)
            })
        } else {
            endTimeDatePicker.hidden = false
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.endTimeHeightConstraint.constant = 139
                self.view.layoutIfNeeded()
            })
        }
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
