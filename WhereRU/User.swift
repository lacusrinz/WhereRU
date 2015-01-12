//
//  User.swift
//  WhereRU
//
//  Created by RInz on 14/11/11.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

public class User  {
    var id:Int = 0
    var username:String?
    var nickname:String?
    var from:String?
    var avatar:String?
    var is_social:Bool = false
    var friends = [Friend]()
    var token:String?
    
    public class var shared : User {
        return Inner.instance
    }
    
    private struct Inner {
        private static let instance = User()
    }
}
