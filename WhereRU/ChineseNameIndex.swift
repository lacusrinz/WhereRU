//
//  ChineseNameIndex.swift
//  WhereRU
//
//  Created by RInz on 15/8/27.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class ChineseNameIndex: NSObject {
    
    var name: String?
    var lastName: String?
    var sectionNum: Int = 0
    var originIndex: Int = 0
    
    func getName() -> String {
        if (lastName!.canBeConvertedToEncoding(NSASCIIStringEncoding)) {
            return self.lastName!
        }
        else {
            return String(format: "%c",pinyinFirstLetter((lastName! as NSString).characterAtIndex(0)))
        }
    }
    
//    func getLastName() -> String {
//        if (lastName!.canBeConvertedToEncoding(NSASCIIStringEncoding)) {
//            return lastName!
//        }
//        else {
//            println((lastName! as NSString))
//            println(String(format: "%c",(lastName! as NSString).characterAtIndex(0)))
//            return String(format: "%c",pinyinFirstLetter((lastName! as NSString).characterAtIndex(0)))
//        }
//    }
}
