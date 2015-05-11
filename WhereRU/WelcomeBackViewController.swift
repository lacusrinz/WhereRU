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
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if image != nil {
            avatarImage.image = image
        }
    }

    override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("welcome", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
