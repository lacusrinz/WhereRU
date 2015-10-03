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
    
    override var hash: Int {
        return self.displayText!.hash + self.context!.hash
    }
    
    init(displayText: String, context: NSObject?) {
        super.init()
        self.displayText = displayText
        self.context = context
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if self === object as? Token {
            return false
        }
        if (!object!.isKindOfClass(Token)) {
            return false
        }
        
        let otherObject: Token = object as! Token
//        let contextEqual = self.context?.isEqual(otherObject.context)
        if(otherObject.displayText == self.displayText) {
            return true
        }
        return false
    }
}
