//
//  SigninViewController.swift
//  WhereRU
//
//  Created by RInz on 14-9-22.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController {
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signin(sender: AnyObject) {
        if nicknameTextField.text.isEmpty{
            TSMessage.showNotificationWithTitle("出错啦", subtitle: "请输入昵称", type: .Error)
        }
        if emailTextField.text.isEmpty{
            TSMessage.showNotificationWithTitle("出错啦", subtitle: "请输入邮箱", type: .Error)
        }
        if passwordTextField.text.isEmpty{
            TSMessage.showNotificationWithTitle("出错啦", subtitle: "请输入密码", type: .Error)
        }
        var user:AVUser = AVUser()
        user.username = nicknameTextField.text
        user.email = emailTextField.text
        user.password = passwordTextField.text
        user.setObject("", forKey: "avatar")
        user.setObject(true, forKey: "is_active")
        
        user.signUpInBackgroundWithBlock { (succeeded:Bool, error:NSError!) -> Void in
            if succeeded{
                println("success!")
            }
            else{
                println("failed:\(error.description)")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
