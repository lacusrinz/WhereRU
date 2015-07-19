//
//  CalendarDataSource.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/19.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import Foundation

protocol CalendarDataSource {
    func calendarHaveEvent(calendar:CalendarView, date:NSDate) -> Bool
    func calendarDidDateSelected(calendar:CalendarView, date:NSDate)
    
    func calendarCanSelectDate(calendar:CalendarView, date:NSDate) -> Bool
    func calendarDidLoadPreviousPage()
    func calendarDidLoadNextPage()
}


