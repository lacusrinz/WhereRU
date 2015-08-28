//
//  CalendarAppearance.swift
//  WhereRU
//
//  Created by RInz on 15/7/5.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

typealias CalendarMonthBlock = (NSDate, CalendarView)-> String

class CalendarAppearance: NSObject {
    
    var isWeekMode: Bool?
    var useCacheSystem: Bool?
    var focusSelectedDayChangeMode: Bool?
    var readFromRightToLeft: Bool?
    var autoChangeMonth: Bool?
    var monthBlock: CalendarMonthBlock?
    
    var weekDayTextColor: UIColor?
    var weekDayTextFont: UIFont?
    var weekDayBackgroundColor: UIColor?
    
    var dayCircleColorSelected: UIColor?
    var dayCircleColorSelectedOtherMonth: UIColor?
    var dayCircleColorToday: UIColor?
    var dayCircleColorTodayOtherMonth: UIColor?
    
    var dayDotColor: UIColor?
    var dayDotColorSelected: UIColor?
    var dayDotColorOtherMonth: UIColor?
    var dayDotColorSelectedOtherMonth: UIColor?
    var dayDotColorToday: UIColor?
    var dayDotColorTodayOtherMonth: UIColor?
    
    var dayTextColor: UIColor?
    var dayTextColorSelected: UIColor?
    var dayTextColorOtherMonth: UIColor?
    var dayTextColorSelectedOtherMonth: UIColor?
    var dayTextColorToday: UIColor?
    var dayTextColorTodayOtherMonth: UIColor?
    var dayTextFont: UIFont?
    var dayFormat: String?
    var dayBackgroundColor: UIColor?
    var dayBorderWidth: CGFloat?
    var dayBorderColor: UIColor?
    var dayCircleRatio: CGFloat?
    var dayDotRation: CGFloat?
    
    var calendar: NSCalendar?
    
    override init () {
        super.init()
        
        self.isWeekMode = false
        self.useCacheSystem = true
        self.focusSelectedDayChangeMode = false
        self.readFromRightToLeft = false
        self.autoChangeMonth = true
        
        self.dayCircleRatio = 1
        self.dayDotRation = 1/9
        
        self.weekDayBackgroundColor = UIColor.clearColor()//UIColor(hue:0.96, saturation:0.49, brightness:1, alpha:1)
        self.weekDayTextFont = UIFont.systemFontOfSize(11)
        self.dayTextFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
        
        self.dayFormat = "dd"
        
        self.dayBackgroundColor = UIColor.clearColor()//UIColor(hue:0.96, saturation:0.49, brightness:1, alpha:1)
        self.dayBorderWidth = 0
        self.dayBorderColor = UIColor.clearColor()
        
        self.weekDayTextColor = UIColor(red: 152/256, green: 147/256, blue: 157/256, alpha: 1)
        
        self.setDayDotColorForAll(UIColor(red: 43/256, green: 88/256, blue: 134/256, alpha: 1))
        self.setDayTextColorForAll(UIColor.blackColor())
        
        self.dayTextColorOtherMonth = UIColor(red: 152/256, green: 147/256, blue: 157/256, alpha: 1)
        
        self.dayCircleColorSelected = UIColor.redColor()
        self.dayTextColorSelected = UIColor.whiteColor()
        self.dayDotColorSelected = UIColor.whiteColor()
        
        self.dayCircleColorSelectedOtherMonth = self.dayCircleColorSelected
        self.dayTextColorSelectedOtherMonth = self.dayTextColorSelected
        self.dayDotColorSelectedOtherMonth = self.dayDotColorSelected
        
        self.dayCircleColorToday = UIColor(red: 0x33/256, green: 0xB3/256, blue: 0xEC/256, alpha: 0.5)
        self.dayTextColorToday = UIColor.whiteColor()
        self.dayDotColorToday = UIColor.whiteColor()
        
        self.dayCircleColorTodayOtherMonth = self.dayCircleColorToday
        self.dayTextColorTodayOtherMonth = self.dayTextColorToday
        self.dayDotColorTodayOtherMonth = self.dayDotColorToday
        
        self.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        self.calendar!.timeZone = NSTimeZone.localTimeZone()
        
        self.monthBlock = {
            (date:NSDate, calendar:CalendarView) -> String in
            var newCalendar: NSCalendar = calendar.calendarAppearance!.calendar!
            var comps: NSDateComponents = newCalendar.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth, fromDate: date)
            var currentMonthIndex = comps.month
            
            var dateFormatter:NSDateFormatter?
            
            if(dateFormatter == nil) {
                dateFormatter = NSDateFormatter.new()
                dateFormatter!.timeZone = calendar.calendarAppearance!.calendar!.timeZone
            }
            
            while(currentMonthIndex <= 0) {
                currentMonthIndex += 12
            }
            
            return "\((dateFormatter!.standaloneMonthSymbols[currentMonthIndex - 1]) as! String)  \(comps.year)"
        }
    }
    
    func setDayDotColorForAll(dotColor:UIColor) {
        self.dayDotColor = dotColor
        self.dayDotColorSelected = dotColor
        
        self.dayDotColorOtherMonth = dotColor
        self.dayDotColorSelectedOtherMonth = dotColor
        
        self.dayDotColorToday = dotColor
        self.dayDotColorTodayOtherMonth = dotColor
    }
    
    func setDayTextColorForAll(textColor:UIColor) {
        self.dayTextColor = textColor
        self.dayTextColorSelected = textColor
    
        self.dayTextColorOtherMonth = textColor
        self.dayTextColorSelectedOtherMonth = textColor
        
        self.dayTextColorToday = textColor
        self.dayTextColorTodayOtherMonth = textColor
    }
}
