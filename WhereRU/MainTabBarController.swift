//
//  MainTabBarController.swift
//  WhereRU
//
//  Created by RInz on 15/4/11.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class MainTabBarController: YALFoldingTabBarController {
    
    override func viewDidLoad() {
        var item1:YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "icon_invite"), leftItemImage: nil, rightItemImage: UIImage(named: "icon_edit"))
        var item2:YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "icon_visit"), leftItemImage: nil, rightItemImage: nil)
        self.leftBarItems = [item1, item2]
        var item3:YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "icon_friends"), leftItemImage: nil, rightItemImage: nil)
        var item4:YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "icon_settings"), leftItemImage: nil, rightItemImage: nil)
        self.rightBarItems = [item3, item4]
        self.centerButtonImage = UIImage(named: "plus_icon")
        self.selectedIndex = 0
        
        self.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight
        self.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
        self.tabBarView.backgroundColor = UIColor(red: 244/255, green: 246/255, blue: 246/255, alpha: 100.0)
        self.tabBarView.tabBarColor = UIColor(red:1, green:0.42, blue:0.42, alpha:1)
        self.tabBarViewHeight = YALTabBarViewDefaultHeight
        self.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets
        self.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets
        
        self.tabBar.clipsToBounds = true
    }
    
}
