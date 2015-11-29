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
    @IBOutlet weak var loginButton: SubmitButton!
    
    private var returnKeyHandler: IQKeyboardReturnKeyHandler?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.returnKeyHandler = IQKeyboardReturnKeyHandler(viewController: self)
        self.returnKeyHandler!.lastTextFieldReturnKeyType = UIReturnKeyType.Done
    }

    @IBAction func login(sender: AnyObject) {
        self.loginButton.startLoadingAnimation()
        AVUser.logInWithUsernameInBackground(emailTextField.text, password: passwordTextField.text) { (user:AVUser?, error:NSError?) -> Void in
            if let loginUser = user {
                print("login success \(loginUser)")
                
                let currentInstallation:AVInstallation = AVInstallation.currentInstallation()
                currentInstallation.setObject(AVUser.currentUser(), forKey: "deviceOwner")
                self.loginButton.animateCompletionSuccess({ () -> () in
                    self.performSegueWithIdentifier("login", sender: self)
                })
            } else {
                self.loginButton.animateCompletionFailed(nil)
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

