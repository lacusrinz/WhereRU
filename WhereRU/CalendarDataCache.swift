//
//  JTCalendarDataCache.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/6.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarDataCache: NSObject {
    var calendarManager:CalendarView?
    
    private var events:[String : Bool]?
    private var dateFormatter:NSDateFormatter?
    
    override init() {
        super.init()
        
        dateFormatter = NSDateFormatter.new()
        dateFormatter!.dateFormat = "yyyy-MM-dd"
        events = [String : Bool]()
    }
    
    func reloadData() {
        events!.removeAll(keepCapacity: false)
    }
    
    func haveEvent(date:NSDate) -> Bool {
        if((self.calendarManager?.dataSource) == nil) {
            return false
        }
        if(self.calendarManager?.calendarAppearance?.useCacheSystem == nil) {
            return self.calendarManager!.dataSource!.calendarHaveEvent(self.calendarManager!, date: date)
        }
        
        var haveEvent:Bool = false
        var key:String = dateFormatter!.stringFromDate(date)
        
        if(events![key] != nil) {
            haveEvent = events![key]!
        } else {
            haveEvent = self.calendarManager!.dataSource!.calendarHaveEvent(self.calendarManager!, date: date)
            events![key] = haveEvent
        }
        return haveEvent
    }
}
