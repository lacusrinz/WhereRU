//
//  MyViewController.swift
//  WhereRU
//
//  Created by RInz on 14-9-25.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

class MyViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avatar: avatarImageView!
    @IBOutlet var avatarTap: UITapGestureRecognizer!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var birthday: UITextField!
    @IBOutlet weak var sex: UISegmentedControl!
    @IBOutlet weak var isPush: UISwitch!
    
    private var returnKeyHandler: IQKeyboardReturnKeyHandler?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        self.tabBarController?.tabBar.translucent = false
        self.navigationController?.navigationBar.translucent = false
        
        self.returnKeyHandler = IQKeyboardReturnKeyHandler(viewController: self)
        self.returnKeyHandler!.lastTextFieldReturnKeyType = UIReturnKeyType.Done

        if let avatarObject =  AVUser.currentUser()!.objectForKey("avatarFile") {
            self.avatar.image = UIImage(data: avatarObject.getData())
        }
        
        avatar.addGestureRecognizer(avatarTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editAvatar(sender: UITapGestureRecognizer) {
        let choiceSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Photo", "Take from Libray")
        choiceSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 1) {
            if(self.isCameraAvailable()) {
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
        else if(buttonIndex == 2){
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
    
    func isCameraAvailable()->Bool{
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    func isRearCameraAvailable()->Bool{
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear)
    }
    
    func isFrontCameraAvailable()->Bool{
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)
    }
    
    func isPhotoLibraryAvailable()->Bool{
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    
    
//    func doesCameraSupportTakingPhotos()->Bool{
//        //
//    }
//    
//    func cameraSupportsMedia(paramMediaType:NSString, paramSourceType:UIImagePickerControllerSourceType)->Bool{
//        //
//    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.avatar.image = croppedImage
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            let avatarData:NSData = UIImagePNGRepresentation(croppedImage)!
            let avatarFile: AnyObject! = AVFile(name: "avatar.png", data: avatarData)
            AVUser.currentUser().setObject(avatarFile, forKey: "avatarFile")
            AVUser.currentUser().saveInBackground()
        })
    }
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            //
        })
    }
    
}
