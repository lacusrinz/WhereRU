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
    var owner:Int = 0
    var participants:String?
    var coordinate:CLLocationCoordinate2D?
    var date:String?// = NSDate(timeIntervalSinceNow: 0)
    var needLocation:Bool = true
    var Message:String?
    var AcceptMemberCount:Int?
    var RefuseMemberCount:Int?
}
