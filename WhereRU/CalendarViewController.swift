//
//  CalendarViewController.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/25.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, CalendarDataSource {

    @IBOutlet weak var calendarContentView: CalendarContentView!
    
    var calendar: CalendarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar = CalendarView.new()
        self.calendar!.calendarAppearance!.calendar!.firstWeekday = 2
        self.calendar!.calendarAppearance!.dayCircleRatio = 9 / 10
        self.calendar!.calendarAppearance!.focusSelectedDayChangeMode = true
        self.calendar!.contentView = self.calendarContentView
        self.calendar!.dataSource = self
        
//        self.calendar!.reloadData()
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

}
