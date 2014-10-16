//
//  ImageCropperViewController.swift
//  WhereRU
//
//  Created by RInz on 14-10-4.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

protocol ImageCropperDelegate{
    func imageCropper(cropperViewController:ImageCropperViewController, didFinished editedImage:UIImage)
    func imageCropperDidCancel(cropperViewController:ImageCropperViewController)
}

class ImageCropperViewController: UIViewController {
    
    @IBOutlet weak var showImgView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var ratioView: UIView!
    @IBOutlet var pinchGestureRecognizer: UIPinchGestureRecognizer!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    var delegate: ImageCropperViewController?
    var tag: NSInteger = 0
    var cropFrame: CGRect = CGRectZero
    var originalImage: UIImage?
    var editedImage: UIImage?
    var oldFrame: CGRect = CGRectZero
    var largeFrame: CGRect = CGRectZero
    var limitRatio: CGFloat?
    var latestFrame: CGRect = CGRectZero

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ratioView.layer.borderColor = UIColor.yellowColor().CGColor
        self.ratioView.layer.borderWidth = 1.0
        
        showImgView.image = originalImage
        
        pinchGestureRecognizer.addTarget(self, action:"pinchView")
        panGestureRecognizer.addTarget(self, action: "panView")
        self.view.addGestureRecognizer(pinchGestureRecognizer)
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
//    func initView(){
//        var oriWidth:CGFloat = self.cropFrame.size.width
//        var oriHeight:CGFloat = self.originalImage?.size.height * (oriWidth / self.originalImage?.size.width)
//        var oriX:CGFloat = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2
//        var oriY:CGFloat = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2
//        self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight)
//        self.latestFrame = self.oldFrame
//        self.showImgView.frame = self.oldFrame
//        
//        self.largeFrame = CGRectMake(0, 0, self.limitRatio * self.oldFrame?.size.width, self.limitRatio * self.oldFrame?.size.height)
//        
//    }
    
    override func viewDidLayoutSubviews() {
        overlayClipping()
    }
    
    func overlayClipping(){
        var maskLayer: CAShapeLayer = CAShapeLayer()
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddRect(path, nil, CGRectMake(0, 0,
            self.ratioView.frame.origin.x,
            self.overlayView.frame.size.height));
        // Right side of the ratio view
        CGPathAddRect(path, nil, CGRectMake(
            self.ratioView.frame.origin.x + self.ratioView.frame.size.width,
            0,
            self.overlayView.frame.size.width - self.ratioView.frame.origin.x - self.ratioView.frame.size.width,
            self.overlayView.frame.size.height));
        // Top side of the ratio view
        CGPathAddRect(path, nil, CGRectMake(0, 0,
            self.overlayView.frame.size.width,
            self.ratioView.frame.origin.y-20));
        // Bottom side of the ratio view
        CGPathAddRect(path, nil, CGRectMake(0,
            self.ratioView.frame.origin.y + self.ratioView.frame.size.height-20,
            self.overlayView.frame.size.width,
            self.overlayView.frame.size.height - self.ratioView.frame.origin.y + self.ratioView.frame.size.height));
        maskLayer.path = path;
        println(path)
        self.overlayView.layer.mask = maskLayer;
    }
    
    func pinchView(pinchGestureRecognizer:UIPinchGestureRecognizer){
        var view:UIView = self.showImgView
        if(pinchGestureRecognizer.state == UIGestureRecognizerState.Began || pinchGestureRecognizer.state == UIGestureRecognizerState.Changed){
            view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale)
            pinchGestureRecognizer.scale = 1
        }
        else if(pinchGestureRecognizer.state == UIGestureRecognizerState.Ended){
            var newFrame:CGRect = self.showImgView.frame;
//            newFrame = handleScaleOverflow(newFrame)
//            newFrame = handleBorderOverflow(newFrame)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.showImgView.frame = newFrame
                self.oldFrame = newFrame
            })
        }
    }

    func panView(panGestureRecoginzer:UIPanGestureRecognizer){
        //
    }
//
//    func handleScaleOverflow(frame:CGRect)->CGRect{
//        var oriCenter: CGPoint = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2)
//        
//    }
//    
//    func handleBorderOverflow(frame:CGRect)->CGRect{
//        //
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
