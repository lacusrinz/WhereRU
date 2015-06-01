//
//  CustomAnnotationView.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/5/23.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CustomAnnotationView: MAAnnotationView {
    
    var avatarImageView:UIImageView!
    var avaterImage:UIImage?
    var calloutView:UIView?
    var name:String?
    
    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.bounds = CGRectMake(0, 0, 30, 30)
        self.avatarImageView = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        self.addSubview(self.avatarImageView)
        
        self.layer.borderColor = UIColor.clearColor().CGColor
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        
        if self.avaterImage != nil {
            self.avatarImageView.image = self.avaterImage!
        } else {
            self.avatarImageView.image = UIImage(named: "default_avatar")
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        if self.selected == selected {
            return
        }
        if selected {
            if self.calloutView == nil {
                self.calloutView = UIView(frame: CGRectMake(0, 0, 60, 20))
                self.calloutView!.center = CGPointMake(CGRectGetWidth(self.bounds) / 2 + self.calloutOffset.x, -CGRectGetHeight(self.calloutView!.bounds) / 2 + self.calloutOffset.y)
                println(self.calloutView!.center)
                var nameLabel:UILabel = UILabel(frame: CGRectMake(0, 0, 60, 20))
                nameLabel.textAlignment = NSTextAlignment.Center
                nameLabel.backgroundColor = UIColor.grayColor()
                nameLabel.textColor = UIColor.whiteColor()
                nameLabel.text = name
                self.calloutView!.addSubview(nameLabel)
            }
            self.addSubview(self.calloutView!)
        } else {
            self.calloutView!.removeFromSuperview()
        }
        super.setSelected(selected, animated: animated)
    }
   
}
