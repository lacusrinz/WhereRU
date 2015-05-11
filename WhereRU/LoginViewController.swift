//
//  ViewController.swift
//  WhereRU
//
//  Created by RInz on 14-9-11.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewControllerDelegate {
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(sender: AnyObject) {
        AVUser.logInWithUsernameInBackground(nicknameTextField.text, password: passwordTextField.text) { (user:AVUser?, error:NSError?) -> Void in
            if (user != nil) {
                println("login success")
                self.performSegueWithIdentifier("login", sender: self)
            }else {
                println("failed:\(error!.description)")
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goSignin" {
            let signinViewController = segue.destinationViewController as! SigninViewController
            signinViewController.delegate = self
        }
    }
    
    //MARK: - LoginViewControllerDelegate
    func loginViewControllerBack() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

