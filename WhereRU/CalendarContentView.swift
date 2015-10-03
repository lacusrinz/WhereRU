//
//  CalendarContentView.swift
//  WhereRU
//
//  Created by RInz on 15/7/5.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

protocol CalendarContentViewDelegate {
    func changeMode(gesture: UISwipeGestureRecognizer)
}

class CalendarContentView: UIScrollView {
    var contentDelegate: CalendarContentViewDelegate?
    
    private var _calendarManager: CalendarView?
    var calendarManager: CalendarView? {
        get {
            return _calendarManager
        }
        set {
            self._calendarManager = newValue
            for view in monthsViews! {
                (view as! CalendarMonthView).calendarManager = newValue
            }
        }
    }
    
    private var _currentDate: NSDate?
    var currentDate: NSDate? {
        get {
            return _currentDate
        }
        set {
            self._currentDate = newValue
            let calendar: NSCalendar = self.calendarManager!.calendarAppearance!.calendar!
            
            for(var i: Int = 0; i < NUMBER_PAGES_LOADED; ++i) {
                let monthView: CalendarMonthView = monthsViews![i] as! CalendarMonthView
                let dayComponent: NSDateComponents = NSDateComponents()
                if(self.calendarManager!.calendarAppearance!.isWeekMode == false) {
                    dayComponent.month = i - Int(NUMBER_PAGES_LOADED / 2)
                    var monthDate: NSDate = calendar.dateByAddingComponents(dayComponent, toDate: self._currentDate!, options: NSCalendarOptions(rawValue: 0))!
                    monthDate = self.beginningOfMonth(monthDate)
                    monthView.setBeginningOfMonth(monthDate)
                }
                else {
                    dayComponent.day = 7 * (i - Int(NUMBER_PAGES_LOADED / 2))
                    var monthDate: NSDate = calendar.dateByAddingComponents(dayComponent, toDate: self._currentDate!, options: NSCalendarOptions(rawValue: 0))!
                    monthDate = self.beginningOfWeek(monthDate)
                    monthView.setBeginningOfMonth(monthDate)
                }
            }
        }
    }
    
    private var monthsViews: NSMutableArray?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        monthsViews = NSMutableArray()
        
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.pagingEnabled = true
        self.clipsToBounds = true
        
        for(var i: Int = 0; i < NUMBER_PAGES_LOADED; ++i) {
            let monthView: CalendarMonthView = CalendarMonthView()
            self.addSubview(monthView)
            monthsViews!.addObject(monthView)
        }
        
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "changeMode:")
        swipe.direction = [UISwipeGestureRecognizerDirection.Down, UISwipeGestureRecognizerDirection.Up]
        self.addGestureRecognizer(swipe)
    }
    
    override func layoutSubviews() {
        self.configureConstrainsForSubviews()
        super.layoutSubviews()
    }
    
    func configureConstrainsForSubviews() {
        self.contentOffset = CGPointMake(self.contentOffset.x, 0)
        
        var x: CGFloat = 0
        let width: CGFloat = self.frame.size.width
        let height: CGFloat = self.frame.size.height
        
        for view in monthsViews! {
            (view as! UIView).frame = CGRectMake(x, 0, width, height)
            x = CGRectGetMaxX((view as! UIView).frame)
        }
        
        self.contentSize = CGSizeMake(width * CGFloat(NUMBER_PAGES_LOADED), height)
    }
    
    func changeMode(gesture: UISwipeGestureRecognizer) {
        self.contentDelegate?.changeMode(gesture)
    }
    
    func beginningOfMonth(date: NSDate) -> NSDate {
        let calendar: NSCalendar = self.calendarManager!.calendarAppearance!.calendar!
        let componentsCurrentDate: NSDateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Weekday, NSCalendarUnit.WeekOfMonth], fromDate: date)
        
        let componentsNewDate: NSDateComponents = NSDateComponents()
        
        componentsNewDate.year = componentsCurrentDate.year
        componentsNewDate.month = componentsCurrentDate.month
        componentsNewDate.weekOfMonth = 1
        componentsNewDate.weekday = calendar.firstWeekday
        
        return calendar.dateFromComponents(componentsNewDate)!
    }
    
    func beginningOfWeek(date: NSDate) -> NSDate {
        let calendar: NSCalendar = self.calendarManager!.calendarAppearance!.calendar!
        let componentsCurrentDate: NSDateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Weekday, NSCalendarUnit.WeekOfMonth], fromDate: date)
        
        let componentsNewDate: NSDateComponents = NSDateComponents()
        
        componentsNewDate.year = componentsCurrentDate.year
        componentsNewDate.month = componentsCurrentDate.month
        componentsNewDate.weekOfMonth = componentsCurrentDate.weekOfMonth
        componentsNewDate.weekday = calendar.firstWeekday
        
        return calendar.dateFromComponents(componentsNewDate)!
    }
    
    func reloadData() {
        for monthView in monthsViews! {
            (monthView as! CalendarMonthView).reloadData()
        }
    }
    
    func reloadAppearance() {
        self.scrollEnabled = true
        for monthView in monthsViews! {
            (monthView as! CalendarMonthView).reloadAppearance()
        }
    }
}
