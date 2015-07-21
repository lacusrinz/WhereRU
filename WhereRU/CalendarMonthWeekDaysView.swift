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
        for day in daysOfWeek() {
            var view:UILabel = UILabel.new()
            view.font = self.calendarManager!.calendarAppearance!.weekDayTextFont
            view.textColor = self.calendarManager!.calendarAppearance!.weekDayTextColor
            view.textAlignment = NSTextAlignment.Center
            view.text = day as? String
            
            self.addSubview(view)
        }
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
    
    override func layoutSubviews() {
        var x: CGFloat = 0;
        var width: CGFloat = self.frame.size.width / 7
        var height: CGFloat = self.frame.size.height
        
        for view in self.subviews {
            (view as! UIView).frame = CGRectMake(x, 0, width, height)
            x = CGRectGetMaxX(view.frame)
        }
    }
    
    func reloadAppearance() {
        for(var i:Int = 0; i < self.subviews.count; ++i) {
            var view: UILabel = (self.subviews as NSArray).objectAtIndex(i) as! UILabel
            
            view.font = self.calendarManager!.calendarAppearance!.weekDayTextFont
            view.textColor = self.calendarManager!.calendarAppearance!.weekDayTextColor
            
            view.text = self.daysOfWeek().objectAtIndex(i) as? String
        }
    }
}
