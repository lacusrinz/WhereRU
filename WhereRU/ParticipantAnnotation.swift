//
//  ParticipantAnnotation.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/5/24.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class ParticipantAnnotation: NSObject, MAAnnotation {
    var _title:String?
    var _subtitle:String?
    var _coordinate:CLLocationCoordinate2D?
    var _avatarImage:UIImage?
    
    func title() -> String! {
        return self._title!
    }
    
    func subtitle() -> String! {
        return self._subtitle!
    }
    
    var coordinate:CLLocationCoordinate2D{
        get{
            return self._coordinate!
        }
    }
}