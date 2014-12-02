//
//  ViewController.swift
//  WhereRU
//
//  Created by RInz on 14-9-11.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var weiboLoginButton: UIButton!
    @IBOutlet weak var wxLoginButton: UIButton!
    var userinfo:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var manager = AFHTTPRequestOperationManager()
    var authToken:String?
    
    var loginURL:String = "http://localhost:8000/auth/login"
    var meURL:String = "http://localhost:8000/auth/me"
    var registrURL:String = "http://localhost:8000/auth/register"
    var friendsURL:String = "http://localhost:8000/friends"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var username:String? = self.userinfo.stringForKey("username") as String?
        var password:String? = self.userinfo.stringForKey("password") as String?
        if let name = username{
            var params:NSMutableDictionary = NSMutableDictionary(capacity: 2)
            params.setObject(username!, forKey: "username")
            params.setObject(password!, forKey: "password")
            self.manager.POST(self.loginURL,
                parameters: params,
                success: {
                    (operation:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                    var response = JSONValue(object)
                    self.authToken = response["auth_token"].string
                    if (self.authToken != ""){
                        self.manager.requestSerializer.setValue("Token "+self.authToken!, forHTTPHeaderField: "Authorization")
                        self.manager.GET(self.meURL,
                            parameters: nil,
                            success: {
                                (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                                var response = JSONValue(responseObject)
                                User.shared.username = response["username"].string
                                User.shared.nickname = response["nickname"].string
                                User.shared.from = response["From"].string
                                User.shared.avatar = response["avatar"].string
                                self.performSegueWithIdentifier("login", sender: self)
                        }, failure: {
                            (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                            //
                        })
                    }
                }) {
                    (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    //
            }
        }
    }

    @IBAction func weiboLogin(sender: AnyObject) {
        ShareSDK.getUserInfoWithType(ShareTypeSinaWeibo, authOptions: nil) {
            (result:Bool, userInfo:ISSPlatformUser!, error:ICMErrorInfo!) -> Void in
            if(result){
                println("uid = \(userInfo.uid())")
                println("name = \(userInfo.nickname())")
                println("icon = \(userInfo.profileImage())")
                
                var params:NSMutableDictionary = NSMutableDictionary(capacity: 2)
                params.setObject(userInfo.uid() + "_ShareTypeSinaWeibo", forKey: "username")
                params.setObject(",mnbvcxz", forKey: "password")
                
                self.manager.POST(self.loginURL,
                    parameters: params,
                    success: {
                        (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                        var response = JSONValue(responseObject)
                        self.authToken = response["auth_token"].string
                        if(self.authToken != ""){
                            self.manager.requestSerializer.setValue("Token "+self.authToken!, forHTTPHeaderField: "Authorization")
                            self.manager.GET(self.meURL,
                                parameters: nil,
                                success: {
                                    (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                                    var response = JSONValue(responseObject)
                                    User.shared.username = response["username"].string
                                    User.shared.nickname = response["nickname"].string
                                    User.shared.from = response["From"].string
                                    User.shared.avatar = response["avatar"].string
                                    
                                    self.userinfo.setObject(User.shared.username, forKey: "username")
                                    self.userinfo.setObject(",mnbvcxz", forKey: "password")
                                    self.userinfo.synchronize()
                                    
                                    println("segue !")
                                    
                                    self.performSegueWithIdentifier("login", sender: self)
                                }, failure: {
                                    (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                                    //
                            })
                        }else{
                                //
                        }
                    },
                    failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                        println(operation.response.statusCode)
                        if operation.response.statusCode == 400{
                            var sourceData:NSDictionary = userInfo.sourceData()
                            
                            var params:NSMutableDictionary = NSMutableDictionary(capacity: 6)
                            params.setObject(userInfo.uid() + "_ShareTypeSinaWeibo", forKey: "username")
                            params.setObject(",mnbvcxz", forKey: "password")
                            params.setObject(userInfo.nickname(), forKey: "nickname")
                            params.setObject("ShareTypeSinaWeibo", forKey: "From")
                            params.setObject(sourceData.objectForKey("avatar_hd")!, forKey: "avatar")
                            params.setObject(true, forKey: "is_social")
                            self.manager.POST(self.registrURL,
                                parameters: params,
                                success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                                    println("post success! \(userInfo.nickname())")
                                    
                                    var response = JSONValue(responseObject)
                                    self.authToken = response["auth_token"].string
                                    User.shared.username = response["username"].string
                                    User.shared.nickname = response["nickname"].string
                                    User.shared.from = response["From"].string
                                    User.shared.avatar = response["avatar"].string
                                    User.shared.is_social = true
                                    
                                    self.userinfo.setObject(User.shared.username, forKey: "username")
                                    self.userinfo.setObject(",mnbvcxz", forKey: "password")
                                    self.userinfo.synchronize()
                                    
                                    self.performSegueWithIdentifier("login", sender: self)
                                },
                                failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                                    println("Error: " + error.localizedDescription)
                            })
                        }
                })
//                SVProgressHUD.show()
            }
        }
    }
    @IBAction func wxLogin(sender: AnyObject) {
        //todo
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "login"{
            self.manager.requestSerializer.clearAuthorizationHeader()
            self.manager.requestSerializer.setValue("Token "+self.authToken!, forHTTPHeaderField: "Authorization")
            self.manager.GET(friendsURL,
                parameters: nil,
                success: { (operation:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                    var response = JSONValue(object)
                    var count = response["count"].integer
                    for var index = 0; index<count; ++index{
                        var friend = Friend()
                        friend.to_user = response["results"][index]["nickname"].string
                        friend.from_user = User.shared.nickname
                        User.shared.friends.append(friend)
                    }
                },
                failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    //
            })
        }
    }
}

