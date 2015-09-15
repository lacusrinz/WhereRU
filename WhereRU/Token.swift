//
//  Token.swift
//  WhereRU
//
//  Created by RInz on 15/9/5.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class Token: NSObject {
    var displayText: String?
    var context: NSObject?
    
    private var _hash: Int?
    override var hash: Int {
        get {
            return self.displayText!.hash + self.context!.hash
        }
        set {
            _hash = newValue
        }
    }
    
    init(displayText: String, context: NSObject) {
        super.init()
        self.displayText = displayText
        self.context = context
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if self == object as! Token {
            return true
        }
        if (!object!.isKindOfClass(Token)) {
            return false
        }
        
        let otherObject: Token = object as! Token
        if(otherObject.displayText == self.displayText && otherObject.context!.isEqual(self.context)) {
            return true
        }
        return false
    }
}
