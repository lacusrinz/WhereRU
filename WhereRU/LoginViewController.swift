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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var user = User.shared
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
                
                var manager = AFHTTPRequestOperationManager()
                var socialUserSearchURL:NSString = "http://localhost:8000/socialuser?search=\(userInfo.uid())"
                manager.GET(socialUserSearchURL,
                    parameters: nil,
                    success: {
                        (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                        var response = JSONValue(responseObject)
                        var count = response["count"].integer
                        if(count == 1){
                            var id = response["results"][0]["id"].string
                            println("segue !")
                        }else{
                            var socialUserCreateURL:NSString = "http://localhost:8000/socialuser/"
                            var params:NSMutableDictionary = NSMutableDictionary(capacity: 6)
                            params.setObject(userInfo.nickname(), forKey: "username")
                            params.setObject("ShareTypeSinaWeibo", forKey: "site_name")
                            params.setObject(userInfo.uid(), forKey: "site_uid")
                            params.setObject(userInfo.profileImage(), forKey: "avatar")
                            params.setObject(true, forKey: "is_active")
                            manager.POST(socialUserCreateURL,
                                parameters: params,
                                success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                                    println("post success! \(userInfo.nickname())")
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
        //todo
    }
}

