//
//  CalendarView.swift
//  WhereRU
//
//  Created by RInz on 15/7/5.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

let NUMBER_PAGES_LOADED = 3

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
    
    private var _titleView: CalendarTitleView?
    var titleView: CalendarTitleView? {
        get {
            return _titleView
        }
        set {
            self._titleView = newValue
            self._titleView?.calendarManager = self
            self._titleView?.currentDate = self.currentDate
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
            self.titleView?.currentDate = currentDate
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

    required init() {
        super.init(frame: CGRectZero)
        self._currentDate = NSDate()
        self.calendarAppearance = CalendarAppearance()
        self.dataCache = CalendarDataCache()
        self.dataCache!.calendarManager = self
        
        cacheLastWeekMode = self.calendarAppearance!.isWeekMode
        cacheFirstWeekDay = self.calendarAppearance!.calendar!.firstWeekday
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            let date = self.currentDate
            self.currentDate = date
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
        let pageWidth: CGFloat = CGRectGetWidth(self.contentView!.frame)
        let fractionalPage: CGFloat = self.contentView!.contentOffset.x / pageWidth
        let currentPage = Int(round(fractionalPage))
        if (currentPage == Int(NUMBER_PAGES_LOADED / 2)) {
            self.contentView!.scrollEnabled = true;
            return;
        }
        
        let calendar: NSCalendar = self.calendarAppearance!.calendar!
        let dayComponent: NSDateComponents = NSDateComponents()
        dayComponent.month = 0
        dayComponent.day = 0
        
        if(self.calendarAppearance!.isWeekMode != true){
            dayComponent.month = currentPage - Int(NUMBER_PAGES_LOADED / 2);
        }
        else{
            dayComponent.day = 7 * (currentPage - Int(NUMBER_PAGES_LOADED / 2));
        }
        
        if(self.calendarAppearance!.readFromRightToLeft!){
            dayComponent.month *= -1;
            dayComponent.day *= -1;
        }
        
        let currentDate: NSDate = calendar.dateByAddingComponents(dayComponent, toDate: self.currentDate!, options: NSCalendarOptions(rawValue: 0))!
        self.currentDate = currentDate
        
        self.contentView!.scrollEnabled = true
        
        if(currentPage < NUMBER_PAGES_LOADED / 2) {
            self.dataSource?.calendarDidLoadPreviousPage()
        }
        else {
            self.dataSource?.calendarDidLoadNextPage()
        }
    }
    
    func repositionViews() {
        let pageWidth: CGFloat = CGRectGetWidth(self.contentView!.frame)
        self.contentView!.contentOffset = CGPointMake(pageWidth * CGFloat(Int(NUMBER_PAGES_LOADED / 2)), self.contentView!.contentOffset.y)
    }
    
    func loadNextMonth() {
        self.loadNextPage()
    }
    
    func loadPreviousMonth() {
        self.loadPreviousPage()
    }
    
    func loadNextPage() {
        var frame: CGRect = self.contentView!.frame
        frame.origin.x = frame.size.width * CGFloat(Int(NUMBER_PAGES_LOADED / 2) + 1)
        frame.origin.y = 0
        self.contentView!.scrollRectToVisible(frame, animated: true)
    }
    
    func loadPreviousPage() {
        var frame: CGRect = self.contentView!.frame
        frame.origin.x = frame.size.width * CGFloat(Int(NUMBER_PAGES_LOADED / 2) - 1)
        frame.origin.y = 0
        self.contentView!.scrollRectToVisible(frame, animated: true)
    }
}
