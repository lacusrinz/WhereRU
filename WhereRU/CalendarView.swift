//
//  CalendarView.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/5.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarView: UIView, UIScrollViewDelegate {
    
    var contentView:CalendarContentView?
    
    var dataSource:CalendarDataSource?
    
    var currentDate:NSDate?
    var currentDateSelected:NSDate?
    
    var dataCache:CalendarDataCache?
    var calendarAppearance:CalendarAppearance?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.currentDate = NSDate()
        self.calendarAppearance = CalendarAppearance.new()
        self.dataCache = CalendarDataCache.new()
        self.dataCache!.calendarManager = self
    }

}
