//
//  CircleView.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/6.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CircleView: UIView {

    var color: UIColor?

    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        self.color = UIColor.whiteColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColor(ctx, CGColorGetComponents(self.backgroundColor!.CGColor))
        CGContextFillRect(ctx, rect)
        
        let newRect = CGRectInset(rect, 0.5, 0.5)
        
        CGContextSetStrokeColorWithColor(ctx, self.color!.CGColor)
        CGContextSetFillColorWithColor(ctx, self.color!.CGColor)
        
        CGContextAddEllipseInRect(ctx, newRect)
        CGContextFillEllipseInRect(ctx, newRect)
        
        CGContextFillPath(ctx)
    }
}
