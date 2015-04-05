//
//  ViewController.swift
//  WhereRU
//
//  Created by RInz on 14-9-11.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        SVProgressHUD.setBackgroundColor(UIColor.clearColor())
    }
    
    override func viewDidAppear(animated: Bool) {
        //
    }

    @IBAction func login(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //
    }
}

