//
//  SigninViewController.swift
//  WhereRU
//
//  Created by RInz on 14-9-22.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

protocol SignUpViewControllerDelegate {
    func signUpViewControllerBack()
}

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, RSKImageCropViewControllerDelegate {
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userAvatarImageView: avatarImageView!
    @IBOutlet var avatarTap: UITapGestureRecognizer!
    
//    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var user:AVUser?
    
    var delegate:SignUpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAvatarImageView.addGestureRecognizer(avatarTap)
        
//        returnKeyHandler = IQKeyboardReturnKeyHandler(viewController: self)
        
        user = AVUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signin(sender: AnyObject) {
        if (nicknameTextField.text?.isEmpty != nil){
            TSMessage.showNotificationInViewController(self, title: "出错啦！", subtitle: "请输入昵称", type: .Error)
            return
        }
        if emailTextField.text!.isEmpty{
            TSMessage.showNotificationInViewController(self, title: "出错啦！", subtitle: "请输入邮箱", type: .Error)
            return
        }
        if passwordTextField.text!.isEmpty{
            TSMessage.showNotificationInViewController(self, title: "出错啦！", subtitle: "请输入密码", type: .Error)
            return
        }
        
        self.user!.username = nicknameTextField.text
        self.user!.email = emailTextField.text
        self.user!.password = passwordTextField.text
        self.user!.setObject("", forKey: "avatar")
        self.user!.setObject(true, forKey: "is_active")
        
        SVProgressHUD.show()
        self.user!.signUpInBackgroundWithBlock { (succeeded:Bool, error:NSError!) -> Void in
            if succeeded{
                print("success!")
                AVUser.logInWithUsernameInBackground(self.user!.username, password: self.user!.password) { (user:AVUser?, error:NSError?) -> Void in
                    if (user != nil) {
                        print("login success")
                        SVProgressHUD.showSuccessWithStatus("")
                        self.performSegueWithIdentifier("loginaftersignin", sender: self)
                    } else {
                        SVProgressHUD.showErrorWithStatus("登陆失败")
                        print("failed:\(error!.description)")
                    }
                }
            }
            else{
                SVProgressHUD.showErrorWithStatus("注册失败")
                print("failed:\(error.description)")
            }
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        self.delegate!.signUpViewControllerBack()
    }
    
    
    @IBAction func uploadAvatar(sender: AnyObject) {
        let choiceSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从照片库获取")
        choiceSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 1) {
            if(self.isCameraAvailable()){
                let controller: UIImagePickerController = UIImagePickerController()
                controller.sourceType = UIImagePickerControllerSourceType.Camera
                if(self.isFrontCameraAvailable()) {
                    controller.cameraDevice = UIImagePickerControllerCameraDevice.Front;
                }
                controller.delegate = self
                self.presentViewController(controller, animated: true, completion: { () -> Void in
                    NSLog("Picker View Controller is presented")
                })
            }
        }
        else if(buttonIndex == 2) {
            if(self.isPhotoLibraryAvailable()) {
                let controller: UIImagePickerController = UIImagePickerController()
                controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                controller.delegate = self
                self.presentViewController(controller, animated: true, completion: { () -> Void in
                    NSLog("Picker View Controller is presented")
                })
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            let portraitImg:UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
            let imageCropVC:RSKImageCropViewController = RSKImageCropViewController(image: portraitImg)
            imageCropVC.delegate = self
            self.presentViewController(imageCropVC, animated: true, completion: { () -> Void in
                //
            })
        })
    }
    
    func isCameraAvailable()->Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    func isRearCameraAvailable()->Bool {
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear)
    }
    
    func isFrontCameraAvailable()->Bool {
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)
    }
    
    func isPhotoLibraryAvailable()->Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    // MARK: - RSKImageCropViewControllerDelegate
    func imageCropViewController(controller: RSKImageCropViewController!, didCropImage croppedImage: UIImage!, usingCropRect cropRect: CGRect) {
        self.userAvatarImageView.image = croppedImage
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            let avatarData:NSData = UIImagePNGRepresentation(croppedImage)!
            let avatarFile: AnyObject! = AVFile(name: "avatar.png", data: avatarData)
            self.user!.setObject(avatarFile, forKey: "avatarFile")
        })
    }
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            //
        })
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        var nextTag = textField.tag + 1
//        var nextResponder:UIResponder? = textField.superview?.viewWithTag(nextTag)
//        if (nextResponder != nil) {
//            nextResponder!.becomeFirstResponder()
//        } else {
//            textField.resignFirstResponder()
//        }
//        return false
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
