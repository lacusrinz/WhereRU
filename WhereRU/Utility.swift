//
//  Utility.swift
//  WhereRU
//
//  Created by RInz on 15/6/10.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    class func filePath(filename: NSString) -> String {
        let mypaths:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let mydocpath:NSString = mypaths.objectAtIndex(0) as! NSString
        let filepath = mydocpath.stringByAppendingPathComponent(filename as String)
        return filepath
    }
   
}
