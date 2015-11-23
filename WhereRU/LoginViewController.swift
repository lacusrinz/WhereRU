//
//  ViewController.swift
//  WhereRU
//
//  Created by RInz on 14-9-11.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, SignUpViewControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(sender: AnyObject) {
        AVUser.logInWithUsernameInBackground(emailTextField.text, password: passwordTextField.text) { (user:AVUser?, error:NSError?) -> Void in
            if let loginUser = user {
                print("login success \(loginUser)")
                
                let currentInstallation:AVInstallation = AVInstallation.currentInstallation()
                currentInstallation.setObject(AVUser.currentUser(), forKey: "deviceOwner")
                
                self.performSegueWithIdentifier("login", sender: self)
            } else {
                print("failed:\(error!.description)")
            }
        }
        
    }

    @IBAction func register(sender: AnyObject) {
        self.performSegueWithIdentifier("signUp", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signUp" {
            let signUpViewController = segue.destinationViewController as! SignUpViewController
            signUpViewController.delegate = self
        }
    }
    
    //MARK: - LoginViewControllerDelegate
    func signUpViewControllerBack() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

