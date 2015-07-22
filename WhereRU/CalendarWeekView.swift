//
//  CalendarWeekView.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/6.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarWeekView: UIView {

    var calendarManager:CalendarView?
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
    }

}
