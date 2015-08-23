//
//  RootViewController.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/8/22.
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
        
        self.contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("contentViewController")! as! UIViewController
        self.leftMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("leftMenuViewController")! as! UIViewController
        self.delegate = self
    }
}

extension RootViewController: RESideMenuDelegate {
    //
}
