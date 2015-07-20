//
//  CalendarMonthWeekDaysView.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/6.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarMonthWeekDaysView: UIView {
    var calendarManager: CalendarView?
    
    private var cacheDaysOfWeeks: NSMutableArray?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        
    }
    
    func daysOfWeek() -> NSArray {
        if(cacheDaysOfWeeks != nil) {
            return cacheDaysOfWeeks!
        }
        
        var dateFormatter: NSDateFormatter?
        dateFormatter = NSDateFormatter.new()
        var days = NSMutableArray()
        
        days = dateFormatter!.shortStandaloneWeekdaySymbols as NSArray as! NSMutableArray
        
        for(var i: Int = 0; i < days.count; i++) {
            var day: String = days[i] as! String
            days.replaceObjectAtIndex(i, withObject: day.uppercaseString)
        }
        
        var calendar: NSCalendar = self.calendarManager!.calendarAppearance!.calendar!
        var firstWeekday = (calendar.firstWeekday + 6) % 7
        
        for(var i: Int = 0; i < firstWeekday; ++i) {
            var day: AnyObject? = days.firstObject
            days.removeObjectAtIndex(0)
            days.addObject(day!)
        }
        
        self.cacheDaysOfWeeks = days
        return self.cacheDaysOfWeeks!
    }
}
