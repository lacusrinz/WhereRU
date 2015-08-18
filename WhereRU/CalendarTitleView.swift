//
//  CalendarTitleView.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/8/17.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarTitleView: UIView {

    init() {
        super.init(frame: CGRectZero)
        self.frame = CGRectMake(0, 0, 170, 66)
        var title: UIButton = self.titleButtonWithDateTime("十二月 2015")
        self.addSubview(title)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func titleButtonWithDateTime(dateTime: String) -> UIButton {
        var titleButton: UIButton = UIButton.new()
        titleButton.setTitle(dateTime, forState: UIControlState.Normal)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleButton.setImage(UIImage(named: "Icon_arrow_normal"), forState: UIControlState.Normal)
        titleButton.setImage(UIImage(named: "Icon_arrow_selected"), forState: UIControlState.Selected)
        titleButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 145, bottom: 8, right: 8)
        titleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
        titleButton.frame.size = CGSizeMake(170, 66)
        titleButton.addTarget(self, action: "titleClick", forControlEvents: UIControlEvents.TouchUpInside)
        return titleButton
    }
    
    func titleClick() {
        //
    }

}
