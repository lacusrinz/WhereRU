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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var uid:String? = self.userinfo.stringForKey("uid") as String?
        if uid != ""{
            var socialUserSearchURL:NSString = "http://localhost:8000/socialuser?search=" + uid!
            SVProgressHUD.show()
            self.manager.GET(socialUserSearchURL,
                parameters: nil,
                success: {
                    (operation:AFHTTPRequestOperation!, object:AnyObject!) -> Void in
                    var response = JSONValue(object)
                    var count = response["count"].integer
                    if count == 1{
                        User.shared.uid = response["results"][0]["site_uid"].string
                        User.shared.name = response["results"][0]["username"].string
                        User.shared.avatar = NSURL(string: response["results"][0]["avatar"].string!)
                        User.shared.site_name = "ShareTypeSinaWeibo"
                        SVProgressHUD.showSuccessWithStatus("Welcome back!")
                        self.performSegueWithIdentifier("login", sender: self)
                    }
                }) {
                    (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    //
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func weiboLogin(sender: AnyObject) {
        ShareSDK.getUserInfoWithType(ShareTypeSinaWeibo, authOptions: nil) {
            (result:Bool, userInfo:ISSPlatformUser!, error:ICMErrorInfo!) -> Void in
            if(result){
                println("uid = \(userInfo.uid())")
                println("name = \(userInfo.nickname())")
                println("icon = \(userInfo.profileImage())")
                
                var socialUserSearchURL:NSString = "http://localhost:8000/socialuser?search=\(userInfo.uid())"
                self.manager.GET(socialUserSearchURL,
                    parameters: nil,
                    success: {
                        (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                        var response = JSONValue(responseObject)
                        var count = response["count"].integer
                        if(count == 1){
                            User.shared.uid = response["results"][0]["site_uid"].string
                            User.shared.name = response["results"][0]["username"].string
                            User.shared.avatar = NSURL(string: response["results"][0]["avatar"].string!)
                            User.shared.site_name = "ShareTypeSinaWeibo"
                            
                            self.userinfo.setObject(User.shared.uid, forKey: "uid")
                            self.userinfo.synchronize()
                            
                            println("segue !")
                            self.performSegueWithIdentifier("login", sender: self)
                        }else{
                            var sourceData:NSDictionary = userInfo.sourceData()
                            var socialUserCreateURL:NSString = "http://localhost:8000/socialuser/"
                            var params:NSMutableDictionary = NSMutableDictionary(capacity: 6)
                            params.setObject(userInfo.nickname(), forKey: "username")
                            params.setObject("ShareTypeSinaWeibo", forKey: "site_name")
                            params.setObject(userInfo.uid(), forKey: "site_uid")
                            params.setObject(sourceData.objectForKey("avatar_hd")!, forKey: "avatar")
                            params.setObject(true, forKey: "is_active")
                            self.manager.POST(socialUserCreateURL,
                                parameters: params,
                                success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                                    println("post success! \(userInfo.nickname())")
                                    User.shared.name = userInfo.nickname()
                                    User.shared.uid = userInfo.uid()
                                    User.shared.avatar = NSURL(string: sourceData.objectForKey("avatar_hd") as String)
                                    User.shared.site_name = "ShareTypeSinaWeibo"
                                    
                                    self.userinfo.setObject(User.shared.uid, forKey: "uid")
                                    self.userinfo.synchronize()
                                    
                                    self.performSegueWithIdentifier("login", sender: self)
                                },
                                failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                                    println("Error: " + error.localizedDescription)
                            })
                        }
                    },
                    failure: { (operation: AFHTTPRequestOperation!,
                        error: NSError!) in
                        println("Error: " + error.localizedDescription + socialUserSearchURL)
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
            //
        }
    }
}

