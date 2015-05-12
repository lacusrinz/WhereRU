//
//  WelcomeBackViewController.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/5/11.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

class WelcomeBackViewController: UIViewController {

    @IBOutlet weak var avatarImage: avatarImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if image != nil {
            avatarImage.image = image
        }
    }

    override func viewDidAppear(animated: Bool) {
        var pause:NSTimer = NSTimer.scheduledTimerWithTimeInterval(1.25, target: self, selector: "pause", userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pause() {
        self.performSegueWithIdentifier("welcome", sender: self)
    }

}
