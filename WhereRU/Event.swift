//
//  Event.swift
//  WhereRU
//
//  Created by RInz on 15/1/3.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class Event: NSObject {
    var owner:NSString?
    var participants:[Friend]?
    var coordinate:CLLocationCoordinate2D?
    var date:NSDate?// = NSDate(timeIntervalSinceNow: 0)
    var needLocation:Bool = true
    var Message:NSString?
}
