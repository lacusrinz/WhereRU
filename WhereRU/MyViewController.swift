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
        if(buttonIndex == 1){
            if(self.isCameraAvailable()){
                var controller: UIImagePickerController = UIImagePickerController()
                controller.sourceType = UIImagePickerControllerSourceType.Camera
                if(self.isFrontCameraAvailable()){
                    controller.cameraDevice = UIImagePickerControllerCameraDevice.Front;
                }
                controller.delegate = self
                self.presentViewController(controller, animated: true, completion: { () -> Void in
                    NSLog("Picker View Controller is presented")
                })
            }
        }
        else if(buttonIndex == 2){
            if(self.isPhotoLibraryAvailable()){
                var controller: UIImagePickerController = UIImagePickerController()
                controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                controller.delegate = self
                self.presentViewController(controller, animated: true, completion: { () -> Void in
                    NSLog("Picker View Controller is presented")
                })
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            var portraitImg:UIImage = info["UIImagePickerControllerOriginalImage"] as UIImage
            var imageCropVC:RSKImageCropViewController = RSKImageCropViewController(image: portraitImg)
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
    
    func imageCropViewController(controller: RSKImageCropViewController!, didCropImage croppedImage: UIImage!) {
        self.avatar.image = croppedImage
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            //
        })
    }
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            //
        })
    }
    
}
