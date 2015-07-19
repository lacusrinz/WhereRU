//
//  CalendarContentView.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/5.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarContentView: UIScrollView {
    var calendarManager: CalendarView?
    var currentDate: NSDate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.pagingEnabled = true
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        self.configureConstrainsForSubviews()
        super.layoutSubviews()
    }
    
    func configureConstrainsForSubviews() {
        self.contentOffset = CGPointMake(self.contentOffset.x, 0)
        
        var width: CGFloat = self.frame.size.width
        var height: CGFloat = self.frame.size.height
        
        self.contentSize = CGSizeMake(width * 5, height)
    }
    
    
}
