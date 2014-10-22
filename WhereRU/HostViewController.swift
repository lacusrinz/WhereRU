//
//  HostViewController.swift
//  WhereRU
//
//  Created by RInz on 14-9-25.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class HostViewController: ViewPagerController, ViewPagerDelegate, ViewPagerDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        var version = NSString(string : UIDevice.currentDevice().systemVersion)
        if(version.floatValue >= 7.0){
            self.edgesForExtendedLayout = UIRectEdge.None
        }
    }
    
    func numberOfTabsForViewPager(viewPager: ViewPagerController!) -> UInt {
        return 2
    }
    
    func viewPager(viewPager: ViewPagerController!, viewForTabAtIndex index: UInt) -> UIView! {
        var label:UILabel = UILabel()
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont.systemFontOfSize(22)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.grayColor()
        
        switch(index){
        case 0:
            label.text = "My"
        case 1:
            label.text = "Map"
        default:
            label.text = "Error"
        }
        label.sizeToFit()
        label.tag = 101
        return label
    }
    
    func viewPager(viewPager: ViewPagerController!, contentViewControllerForTabAtIndex index: UInt) -> UIViewController! {
        var myViewController:MyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("myViewController") as MyViewController
        var mapViewController:MapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewController") as MapViewController

        switch(index){
        case 0:
            myViewController._name = "Content View \(index)"
            return myViewController
        case 1:
            return mapViewController
        default:
            return nil
        }
    }
    
    func viewPager(viewPager: ViewPagerController!, valueForOption option: ViewPagerOption, withDefault value: CGFloat) -> CGFloat {
        switch(option){
        case .StartFromSecondTab:
            return 0.0
        case .CenterCurrentTab:
            return 0.0
        case .TabLocation:
            return 1.0
        case .TabOffset:
            return 36.0
        default:
            return value
        }
    }
    
    func viewPager(viewPager: ViewPagerController!, colorForComponent component: ViewPagerComponent, withDefault color: UIColor!) -> UIColor! {
        switch(component){
        case .TabsView:
            return UIColor.clearColor()
        case .Content:
            return UIColor.clearColor()
        default:
            return color
        }
    }
    
    func viewPager(viewPager: ViewPagerController!, didChangeTabToIndex index: UInt) {
        //todo
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
