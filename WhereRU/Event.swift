//
//  Event.swift
//  WhereRU
//
//  Created by RInz on 15/1/3.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class Event: NSObject {
    var eventID:Int?
    var owner:AVUser?
    var participants:[AVUser]?
    var coordinate:CLLocationCoordinate2D?
    var date:NSDate?// = NSDate(timeIntervalSinceNow: 0)
    var needLocation:Bool = true
    var message:String?
    var acceptMemberCount:Int?
    var refuseMemberCount:Int?
}
