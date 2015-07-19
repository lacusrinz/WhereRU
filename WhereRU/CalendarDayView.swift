//
//  JTCalendarDayView.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/6.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarDayView: UIView {

    var calendarManager:CalendarView?
    
    var date:NSDate?
    var isOtherMonth:Bool?
    
    private var backgroundView:UIView?
    private var circleView:CircleView?
    private var textLabel:UILabel?
    private var dotView:CircleView?
    
    private var isSelected:Bool?
    private var cacheIsToday:Int?
    private var cacheCurrentDateText:String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    deinit {
        //
    }
    
    func commonInit() {
        isSelected = false
        isOtherMonth = false
        
        backgroundView = UIView()
        self.addSubview(backgroundView!)
        
        circleView = CircleView.new()
        self.addSubview(circleView!)
        
        textLabel = UILabel()
        self.addSubview(textLabel!)
        
        dotView = CircleView.new()
        self.addSubview(dotView!)
        dotView!.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didDaySelected:", name: "CalendarDaySelected", object: nil)
    }

    override func layoutSubviews() {
        textLabel!.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        backgroundView!.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        
        var sizeCircle = min(self.frame.size.width, self.frame.size.height)
        var sizeDot = sizeCircle
        
        //
        
    }
}
