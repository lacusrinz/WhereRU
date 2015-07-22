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
    
    var _date: NSDate?
    var date: NSDate? {
        get {
            return _date
        }
        set {
            var dateFormatter: NSDateFormatter?
            if(dateFormatter == nil) {
                dateFormatter = NSDateFormatter.new()
                dateFormatter!.timeZone = self.calendarManager!.calendarAppearance!.calendar!.timeZone
                dateFormatter!.dateFormat = self.calendarManager!.calendarAppearance!.dayFormat
            }
            self._date = newValue
            textLabel!.text = dateFormatter!.stringFromDate(newValue!)
            cacheIsToday = -1
            cacheCurrentDateText = nil
        }
    }
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
        
        var gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTouch")
        self.userInteractionEnabled = true
        self.addGestureRecognizer(gesture)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didDaySelected:", name: "CalendarDaySelected", object: nil)
    }

    override func layoutSubviews() {
        self.configureConstrainsForSubview()
    }
    
    func configureConstrainsForSubview() {
        textLabel!.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        backgroundView!.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        
        var sizeCircle = min(self.frame.size.width, self.frame.size.height)
        var sizeDot = sizeCircle
        
        sizeCircle = sizeCircle * self.calendarManager!.calendarAppearance!.dayCircleRatio!
        sizeDot = sizeDot * self.calendarManager!.calendarAppearance!.dayDotRation!
        
        sizeCircle = round(sizeCircle)
        sizeDot = round(sizeDot)
        
        circleView!.frame = CGRectMake(0, 0, sizeCircle, sizeCircle)
        circleView!.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        circleView!.layer.cornerRadius = sizeCircle / 2
        
        dotView!.frame = CGRectMake(0, 0, sizeDot, sizeDot)
        dotView!.center = CGPointMake(self.frame.size.width / 2, (self.frame.size.height / 2) + sizeDot * 2.5)
        dotView!.layer.cornerRadius = sizeDot / 2
    }
    
    func didTouch() {
        if(self.calendarManager!.dataSource!.calendarCanSelectDate(self.calendarManager!, date: self.date!) == false) {
            return
        }
        self.setSelected(true, animated: true)
        //TODO
    }
    
    func didDaySelected(notification: NSNotification) {
        var dateSelected: NSDate = notification.object as! NSDate
        
        if(self.isSameDate(dateSelected)) {
            if(isSelected == false) {
                self.setSelected(true, animated: true)
            }
        }
        else if(isSelected == true) {
            self.setSelected(false, animated: true)
        }
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        //
    }
    
    func setIsOtherMonth(isOtherMonth: Bool) {
        //
    }
    
    func reloadData() {
        //
    }
    
    func isToday() -> Bool {
        return false
    }
    
    func isSameDate(date: NSDate) -> Bool {
        return false
    }
    
    func monthIndexForDate(date: NSDate) -> Int {
        var calendar: NSCalendar = self.calendarManager!.calendarAppearance!.calendar!
        var comps: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitMonth, fromDate: date)
        return comps.month
    }
    
    func reloadAppearance() {
        textLabel!.textAlignment = NSTextAlignment.Center
        textLabel!.font = self.calendarManager!.calendarAppearance!.dayTextFont
        backgroundView!.backgroundColor = self.calendarManager!.calendarAppearance!.dayBackgroundColor
        backgroundView!.layer.borderWidth = self.calendarManager!.calendarAppearance!.dayBorderWidth!
        backgroundView!.layer.borderColor = self.calendarManager!.calendarAppearance!.dayBorderColor!.CGColor
        
        self.configureConstrainsForSubview()
        self.setSelected(isSelected!, animated: false)
    }
}
