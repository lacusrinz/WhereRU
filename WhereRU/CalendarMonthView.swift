//
//  CalendarMonthView.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/6.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarMonthView: UIView {

    var calendarManager: CalendarView?
    
    private var weekdaysView: CalendarMonthWeekDaysView?
    private var weeksViews: [UIView]?
    private var currentMonthIndex: Int?
    private var cacheLastWeekMode:Bool?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func commonInit() {
        var views:[UIView] = [UIView]()
        
    }

}
