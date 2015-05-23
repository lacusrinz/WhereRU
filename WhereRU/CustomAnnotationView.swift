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
   
}
