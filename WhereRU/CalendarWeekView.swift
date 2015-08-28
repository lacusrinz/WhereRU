//
//  CalendarWeekView.swift
//  WhereRU
//
//  Created by RInz on 15/7/6.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarWeekView: UIView {
    private var _calendarManager: CalendarView?
    var calendarManager: CalendarView? {
        get {
            return _calendarManager
        }
        set {
            self._calendarManager = newValue
            for view in daysViews! {
                (view as! CalendarDayView).calendarManager = newValue
            }
        }
    }
    var currentMonthIndex:NSInteger?
    
    private var daysViews:NSArray?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        var views = NSMutableArray()
        
        for (var i: Int = 0; i < 7; ++i) {
            var view: UIView = CalendarDayView.new()
            views.addObject(view)
            self.addSubview(view)
        }
        daysViews = views
    }
    
    override func layoutSubviews() {
        var x: CGFloat = 0
        var width: CGFloat = self.frame.size.width / 7
        var height: CGFloat = self.frame.size.height
        
        if self.calendarManager?.calendarAppearance?.readFromRightToLeft != nil && self.calendarManager!.calendarAppearance!.readFromRightToLeft! {
            for view in self.subviews.reverse() {
                (view as! UIView).frame = CGRectMake(x, 0, width, height)
                x = CGRectGetMaxX(view.frame)
            }
        }
        else {
            for view in self.subviews {
                (view as! UIView).frame = CGRectMake(x, 0, width, height)
                x = CGRectGetMaxX(view.frame)
            }
        }
        super.layoutSubviews()
    }
    
    func setBeginningOfWeek(date: NSDate) {
        var currentDate: NSDate = date
        var calendar: NSCalendar = self.calendarManager!.calendarAppearance!.calendar!
        
        for view in daysViews! {
            if !self.calendarManager!.calendarAppearance!.isWeekMode! {
                var comps: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitMonth, fromDate: currentDate)
                var monthIndex: Int = comps.month
                (view as! CalendarDayView).isOtherMonth = (monthIndex != self.currentMonthIndex)
            }
            else {
                (view as! CalendarDayView).isOtherMonth = false
            }
            (view as! CalendarDayView).date = currentDate
            var dayComponent: NSDateComponents = NSDateComponents.new()
            dayComponent.day = 1
            currentDate = calendar.dateByAddingComponents(dayComponent, toDate: currentDate, options: NSCalendarOptions(0))!
        }
    }

    func reloadData() {
        for view in daysViews! {
            (view as! CalendarDayView).reloadData()
        }
    }
    
    func reloadAppearance() {
        for view in daysViews! {
            (view as! CalendarDayView).reloadAppearance()
        }
    }
}
