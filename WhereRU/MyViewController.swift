//
//  MyViewController.swift
//  WhereRU
//
//  Created by RInz on 14-9-25.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

class MyViewController: UIViewController, UIActionSheetDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBOutlet weak var avatar: avatarImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var recognizeID: UILabel!
    @IBOutlet var avatarTap: UITapGestureRecognizer! = nil
    
    var _name:String = ""
    var _id:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = _name
        recognizeID.text = _id
        
        avatar.addGestureRecognizer(avatarTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editAvatar(sender: UITapGestureRecognizer) {
        var choiceSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Photo", "Take from Libray")
        choiceSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        //todo
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier=="show"){
            var imageCropperViewController:ImageCropperViewController = segue.destinationViewController as ImageCropperViewController
            imageCropperViewController.originalImage = UIImage(named: "map")
        }
    }

    
}
