//
//  CalendarViewController.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/25.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, CalendarDataSource, CalendarContentViewDelegate {

    @IBOutlet weak var calendarContentView: CalendarContentView!
    @IBOutlet weak var calendarContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var calendar: CalendarView?
    
    private var height: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.height = calendarContentViewHeight.constant
        
        self.calendar = CalendarView.new()
        self.calendar!.calendarAppearance!.calendar!.firstWeekday = 2
        self.calendar!.calendarAppearance!.dayCircleRatio = 9 / 10
        self.calendar!.calendarAppearance!.focusSelectedDayChangeMode = true
        self.calendar!.contentView = self.calendarContentView
        self.calendar!.dataSource = self
        
        self.navigationItem.titleView = CalendarTitleView.new()
        
        self.calendar!.contentView!.contentDelegate = self
        
        self.calendar!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.calendar!.repositionViews()
    }
    
    // MARK: - JTCalendarDataSource
    
    func calendarHaveEvent(calendar: CalendarView, date: NSDate) -> Bool {
        return false
    }
    
    func calendarDidDateSelected(calendar: CalendarView, date: NSDate) {
        //
    }
    
    func calendarDidLoadNextPage() {
        //
    }
    
    func calendarDidLoadPreviousPage() {
        println("xxxx")
    }
    
    func calendarCanSelectDate(calendar: CalendarView, date: NSDate) -> Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func changeMode(gesture: UISwipeGestureRecognizer) {
        self.calendar?.calendarAppearance?.isWeekMode = !self.calendar!.calendarAppearance!.isWeekMode!
        var newHeight: CGFloat = self.height
        if(self.calendar!.calendarAppearance!.isWeekMode!) {
            newHeight = 75
        }
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.calendarContentViewHeight.constant = newHeight
            self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.calendarContentView.layer.opacity = 0
            }) { (finished: Bool) -> Void in
                self.calendar?.reloadAppearance()
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.calendarContentView.layer.opacity = 1
                })
        }
    }

}
