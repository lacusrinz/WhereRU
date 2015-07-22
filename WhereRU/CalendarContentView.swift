//
//  CalendarContentView.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/5.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarContentView: UIScrollView {
    var calendarManager: CalendarView?
    
    var _currentDate: NSDate?
    var currentDate: NSDate? {
        get {
            return _currentDate
        }
        set {
            self._currentDate = newValue
            var calendar: NSCalendar = self.calendarManager!.calendarAppearance!.calendar!
            
            for(var i: Int = 0; i < 5; ++i) {
                var monthView: CalendarMonthView = monthsViews![i] as! CalendarMonthView
                var dayComponent: NSDateComponents = NSDateComponents.new()
                if(self.calendarManager!.calendarAppearance!.isWeekMode != false) {
                    dayComponent.month = i - 5 / 2
                    var monthDate: NSDate = calendar.dateByAddingComponents(dayComponent, toDate: self._currentDate!, options: nil)!
                    monthDate = self.beginningOfMonth(monthDate)
                    //
                }
                else {
                    dayComponent.day = 7 * (i - 5 / 2)
                    var monthDate: NSDate = calendar.dateByAddingComponents(dayComponent, toDate: self._currentDate!, options: nil)!
                    monthDate = self.beginningOfMonth(monthDate)
                    //
                }
            }
        }
    }
    
    private var monthsViews: NSMutableArray?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        monthsViews = NSMutableArray.new()
        
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.pagingEnabled = true
        self.clipsToBounds = true
        
        for(var i: Int = 0; i < 5; ++i) {
            var monthView: CalendarMonthView = CalendarMonthView.new()
            self.addSubview(monthView)
            monthsViews!.addObject(monthView)
        }
    }
    
    override func layoutSubviews() {
        self.configureConstrainsForSubviews()
        super.layoutSubviews()
    }
    
    func configureConstrainsForSubviews() {
        self.contentOffset = CGPointMake(self.contentOffset.x, 0)
        
        var x: CGFloat = 0
        var width: CGFloat = self.frame.size.width
        var height: CGFloat = self.frame.size.height
        
        for view in monthsViews! {
            (view as! UIView).frame = CGRectMake(x, 0, width, height)
            x = CGRectGetMaxX((view as! UIView).frame)
        }
        
        self.contentSize = CGSizeMake(width * 5, height)
    }
    
    func beginningOfMonth(date: NSDate) -> NSDate {
        //TODO
        return NSDate()
    }
    
    func beginningOfWeek(date: NSDate) -> NSDate {
        //TODO
        return NSDate()
    }
}
