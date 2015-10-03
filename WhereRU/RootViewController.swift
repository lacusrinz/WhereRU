//
//  RootViewController.swift
//  WhereRU
//
//  Created by RInz on 15/8/22.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class RootViewController: RESideMenu {
    override func awakeFromNib() {
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.LightContent
        self.contentViewShadowColor = UIColor.blackColor()
        self.contentViewShadowOffset = CGSizeMake(0, 0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        
        self.contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("contentViewController") 
        self.leftMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("leftMenuViewController") 
        self.delegate = self
    }
}

extension RootViewController: RESideMenuDelegate {
    //
}
