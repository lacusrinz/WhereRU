//
//  JTCalendarDayView.swift
//  WhereRU
//
//  Created by RInz on 15/7/6.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarDayView: UIView {

    var calendarManager:CalendarView?
    
    private var _date: NSDate?
    var date: NSDate? {
        get {
            return _date
        }
        set {
            var dateFormatter: NSDateFormatter?
            if(dateFormatter == nil) {
                dateFormatter = NSDateFormatter()
                dateFormatter!.timeZone = self.calendarManager!.calendarAppearance!.calendar!.timeZone
                dateFormatter!.dateFormat = self.calendarManager!.calendarAppearance!.dayFormat
            }
            self._date = newValue
            textLabel!.text = dateFormatter!.stringFromDate(newValue!)
            cacheIsToday = -1
            cacheCurrentDateText = nil
        }
    }
    
    private var _isOtherMonth: Bool?
    var isOtherMonth: Bool? {
        get {
            return _isOtherMonth
        }
        set {
            self._isOtherMonth = newValue
            self.setSelected(isSelected, animated: false)
        }
    }
    
    private var backgroundView: UIView?
    private var circleView: CircleView?
    private var textLabel: UILabel?
    private var dotView: CircleView?
    private var isSelected: Bool = false
    private var cacheIsToday: Int = 0
    private var cacheCurrentDateText: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func commonInit() {
        isSelected = false
        isOtherMonth = false
        
        backgroundView = UIView()
        self.addSubview(backgroundView!)
        
        circleView = CircleView()
        self.addSubview(circleView!)
        
        textLabel = UILabel()
        self.addSubview(textLabel!)
        
        dotView = CircleView()
        self.addSubview(dotView!)
        dotView!.hidden = true
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTouch")
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
        self.calendarManager!.currentDateSelected = self.date
        
        NSNotificationCenter.defaultCenter().postNotificationName("CalendarDaySelected", object: self.date)
        
        self.calendarManager!.dataSource!.calendarDidDateSelected(self.calendarManager!, date: self.date!)
        
        if(self.isOtherMonth != true || self.calendarManager!.calendarAppearance!.autoChangeMonth != true) {
            return
        }
        let currentMonthIndex: Int = self.monthIndexForDate(self.date!)
        let calendarMonthIndex: Int = self.monthIndexForDate(self.calendarManager!.currentDate!)
        
        if(currentMonthIndex == (calendarMonthIndex + 1) % 12) {
            self.calendarManager!.loadNextPage()
        }
        else if(currentMonthIndex == (calendarMonthIndex + 12 - 1) % 12) {
            self.calendarManager!.loadPreviousPage()
        }
    }
    
    func didDaySelected(notification: NSNotification) {
        let dateSelected: NSDate = notification.object as! NSDate
        
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
        var _animated = animated
        if isSelected == selected {
            _animated = false
        }
        isSelected = selected
        
        circleView?.transform = CGAffineTransformIdentity
        var tr: CGAffineTransform = CGAffineTransformIdentity
        var opacity: CGFloat = 1
        
        if selected {
            if self.isOtherMonth == false {
                circleView?.color = self.calendarManager?.calendarAppearance?.dayCircleColorSelected
                textLabel?.textColor = self.calendarManager?.calendarAppearance?.dayTextColorSelected
                dotView?.color = self.calendarManager?.calendarAppearance?.dayDotColorSelected
            }
            else {
                circleView?.color = self.calendarManager?.calendarAppearance?.dayCircleColorSelectedOtherMonth
                textLabel?.textColor = self.calendarManager?.calendarAppearance?.dayTextColorSelectedOtherMonth
                dotView?.color = self.calendarManager?.calendarAppearance?.dayDotColorSelectedOtherMonth
            }
            circleView?.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)
            tr = CGAffineTransformIdentity
        }
        else if self.isToday() {
            if self.isOtherMonth == false {
                circleView?.color = self.calendarManager?.calendarAppearance?.dayCircleColorToday
                textLabel?.textColor = self.calendarManager?.calendarAppearance?.dayTextColorToday
                dotView?.color = self.calendarManager?.calendarAppearance?.dayDotColorToday
            }
            else {
                circleView?.color = self.calendarManager?.calendarAppearance?.dayCircleColorTodayOtherMonth
                textLabel?.textColor = self.calendarManager?.calendarAppearance?.dayTextColorTodayOtherMonth
                dotView?.color = self.calendarManager?.calendarAppearance?.dayDotColorTodayOtherMonth
            }
        }
        else {
            if self.isOtherMonth == false {
                textLabel?.textColor = self.calendarManager?.calendarAppearance?.dayTextColor
                dotView?.color = self.calendarManager?.calendarAppearance?.dayDotColor
            }
            else {
                textLabel?.textColor = self.calendarManager?.calendarAppearance?.dayTextColorOtherMonth
                dotView?.color = self.calendarManager?.calendarAppearance?.dayDotColorOtherMonth
            }
            opacity = 0
        }
        
        if animated {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.circleView?.layer.opacity = Float(opacity)
                self.circleView?.transform = tr
            })
        }
        else {
            self.circleView?.layer.opacity = Float(opacity)
            self.circleView?.transform = tr
        }
    }
    
    func reloadData() {
        dotView!.hidden = !self.calendarManager!.dataCache!.haveEvent(self.date!)
        let selected: Bool = self.isSameDate(self.calendarManager!.currentDateSelected)
        self.setSelected(selected, animated: false)
    }
    
    func isToday() -> Bool {
        if cacheIsToday == 0 {
            return false
        }
        else if cacheIsToday == 1 {
            return true
        }
        else {
            if self.isSameDate(NSDate()) {
                cacheIsToday = 1
                return true
            }
            else {
                cacheIsToday = 0
                return false
            }
        }
    }
    
    func isSameDate(date: NSDate?) -> Bool {
        if date != nil {
            var dateFormatter: NSDateFormatter?
            if dateFormatter == nil {
                dateFormatter = NSDateFormatter()
                dateFormatter!.timeZone = self.calendarManager?.calendarAppearance?.calendar?.timeZone
                dateFormatter!.dateFormat = "dd-MM-yyyy"
            }
            if cacheCurrentDateText == nil {
                cacheCurrentDateText = dateFormatter!.stringFromDate(self.date!)
            }
            let dateText2: String = dateFormatter!.stringFromDate(date!)
            if cacheCurrentDateText == dateText2 {
                return true
            }
        }
        return false
    }
    
    func monthIndexForDate(date: NSDate) -> Int {
        let calendar: NSCalendar = self.calendarManager!.calendarAppearance!.calendar!
        let comps: NSDateComponents = calendar.components(NSCalendarUnit.Month, fromDate: date)
        return comps.month
    }
    
    func reloadAppearance() {
        textLabel!.textAlignment = NSTextAlignment.Center
        textLabel!.font = self.calendarManager!.calendarAppearance!.dayTextFont
        backgroundView!.backgroundColor = self.calendarManager!.calendarAppearance!.dayBackgroundColor
        backgroundView!.layer.borderWidth = self.calendarManager!.calendarAppearance!.dayBorderWidth!
        backgroundView!.layer.borderColor = self.calendarManager!.calendarAppearance!.dayBorderColor!.CGColor
        
        self.configureConstrainsForSubview()
        self.setSelected(isSelected, animated: false)
    }
}
