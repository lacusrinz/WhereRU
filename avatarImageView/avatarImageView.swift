//
//  avatarImageView.swift
//  WhereRU
//
//  Created by RInz on 14-9-22.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

@IBDesignable
public class avatarImageView: UIImageView {

    @IBInspectable
    var avatarImage : UIImage = UIImage(){
        didSet{
            self.image = avatarImage
        }
    }
    
    @IBInspectable
    var borderColor : UIColor = UIColor.clearColor(){
        didSet{
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable
    var borderWidth : CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var cornerRadius : CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable
    var mask : Bool = true{
        didSet{
            layer.masksToBounds = mask
        }
    }
}
