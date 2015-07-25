//
//  CalendarView.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/5.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarView: UIView, UIScrollViewDelegate {
    
    private var _contentView: CalendarContentView?
    var contentView:CalendarContentView? {
        get {
            return _contentView
        }
        set {
            self._contentView?.delegate = nil
            self._contentView?.calendarManager = nil
            
            self._contentView = newValue
            self._contentView!.delegate = self
            self._contentView!.calendarManager = self
            
            self.contentView!.currentDate = self.currentDate
            self.contentView!.reloadAppearance()
        }
    }
    
    private var _currentDate:NSDate?
    var currentDate:NSDate? {
        get {
            return _currentDate
        }
        set {
            assert(currentDate != nil, "Calendar currentDate cannot be nil")
            self._currentDate = newValue
            self.contentView?.currentDate = currentDate
            self.repositionViews()
            self.contentView?.reloadData()
        }
    }
    
    var dataSource:CalendarDataSource?
    var currentDateSelected:NSDate?
    var dataCache:CalendarDataCache?
    var calendarAppearance:CalendarAppearance?
    
    private var cacheLastWeekMode: Bool?
    private var cacheFirstWeekDay: Int?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.currentDate = NSDate()
        self.calendarAppearance = CalendarAppearance.new()
        self.dataCache = CalendarDataCache.new()
        self.dataCache!.calendarManager = self
        
        cacheLastWeekMode = self.calendarAppearance!.isWeekMode
        cacheFirstWeekDay = self.calendarAppearance!.calendar!.firstWeekday
    }

    func reloadData() {
        self.dataCache!.reloadData()
        self.repositionViews()
        self.contentView!.reloadData()
    }
    
    func reloadAppearance() {
        self.contentView!.reloadAppearance()
        if(cacheLastWeekMode != self.calendarAppearance!.isWeekMode || cacheFirstWeekDay != self.calendarAppearance!.calendar!.firstWeekday) {
            cacheLastWeekMode = self.calendarAppearance!.isWeekMode
            cacheFirstWeekDay = self.calendarAppearance!.calendar!.firstWeekday
        }
        if self.calendarAppearance!.focusSelectedDayChangeMode! == true && self.currentDateSelected != nil {
            self.currentDate = self.currentDateSelected
        }
        else {
            //???
        }
    }
    
    //MARK: - UIScrollView delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(self.calendarAppearance!.isWeekMode!){
            return;
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.updatePage()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.updatePage()
    }
    
    func updatePage() {
        var pageWidth: CGFloat = CGRectGetWidth(self.contentView!.frame)
        var fractionalPage: CGFloat = self.contentView!.contentOffset.x / pageWidth
        var currentPage = Int(round(fractionalPage))
        if (currentPage == (5 / 2)) {
            self.contentView!.scrollEnabled = true;
            return;
        }
        
        var calendar: NSCalendar = self.calendarAppearance!.calendar!
        var dayComponent: NSDateComponents = NSDateComponents.new()
        dayComponent.month = 0
        dayComponent.day = 0
        
        if(self.calendarAppearance!.isWeekMode != true){
            dayComponent.month = currentPage - (5 / 2);
        }
        else{
            dayComponent.day = 7 * (currentPage - (5 / 2));
        }
        
        if(self.calendarAppearance!.readFromRightToLeft!){
            dayComponent.month *= -1;
            dayComponent.day *= -1;
        }
        
        var currentDate: NSDate = calendar.dateByAddingComponents(dayComponent, toDate: self.currentDate!, options: nil)!
        self.currentDate = currentDate
        
        self.contentView!.scrollEnabled = true
        
        if(currentPage < 5 / 2) {
            self.dataSource?.calendarDidLoadPreviousPage()
        }
        else {
            self.dataSource?.calendarDidLoadNextPage()
        }
    }
    
    func repositionViews() {
        var pageWidth: CGFloat = CGRectGetWidth(self.contentView!.frame)
        self.contentView!.contentOffset = CGPointMake(pageWidth * (5 / 2), self.contentView!.contentOffset.y)
    }
    
    func loadNextMonth() {
        self.loadNextPage()
    }
    
    func loadPreviousMonth() {
        self.loadPreviousPage()
    }
    
    func loadNextPage() {
        var frame: CGRect = self.contentView!.frame
        frame.origin.x = frame.size.width * (5 / 2 + 1)
        frame.origin.y = 0
        self.contentView!.scrollRectToVisible(frame, animated: true)
    }
    
    func loadPreviousPage() {
        var frame: CGRect = self.contentView!.frame
        frame.origin.x = frame.size.width * (5 / 2 - 1)
        frame.origin.y = 0
        self.contentView!.scrollRectToVisible(frame, animated: true)
    }
}
