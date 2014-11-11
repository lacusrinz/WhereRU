//
//  User.swift
//  WhereRU
//
//  Created by RInz on 14/11/11.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

public class User  {
    var name:NSString?
    var uid:NSString?
    var site_name:NSString?
    var avatar:NSURL?
    
    public class var shared : User {
        return Inner.instance
    }
    
    private struct Inner {
        private static let instance = User()
    }
}
