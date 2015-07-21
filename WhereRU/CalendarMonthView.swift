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
    private var weeksViews: NSArray?
    private var currentMonthIndex: Int?
    private var cacheLastWeekMode:Bool?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        var views: NSMutableArray = NSMutableArray.new()
        
        weekdaysView = CalendarMonthWeekDaysView.new()
        self.addSubview(weekdaysView!)
        
        for(var i: Int = 0; i < 6; ++i) {
            var view: UIView = CalendarWeekView.new()
            views.addObject(view)
            self.addSubview(view)
        }
        
        weeksViews = views as NSArray
        
        cacheLastWeekMode = self.calendarManager!.calendarAppearance!.isWeekMode
    }
    
    override func layoutSubviews() {
        self.configureConstraintsForSubviews()
        super.layoutSubviews()
    }
    
    func configureConstraintsForSubviews() {
        //
    }

}
