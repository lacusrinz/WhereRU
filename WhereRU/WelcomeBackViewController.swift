//
//  WelcomeBackViewController.swift
//  WhereRU
//
//  Created by RInz on 15/5/11.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

class WelcomeBackViewController: UIViewController {

    @IBOutlet weak var avatarImage: avatarImageView!
    @IBOutlet weak var welcomeLabel: RQShineLabel!

    
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if image != nil {
            avatarImage.image = image
        }
        
        self.welcomeLabel.numberOfLines = 0
        self.welcomeLabel.text = "欢 迎 回 来"
        self.welcomeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        self.welcomeLabel.textColor = UIColor.blackColor()
    }
    
    override func viewDidLayoutSubviews() {
        self.avatarImage.layer.cornerRadius = self.avatarImage.frame.width / 2
    }
    
    override func viewDidAppear(animated: Bool) {
        self.welcomeLabel.shineWithCompletion { () -> Void in
            self.performSegueWithIdentifier("welcome", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
