//
//  SubmitButton.swift
//  WhereRU
//
//  Created by RInz on 15/11/28.
//  Copyright © 2015年 RInz. All rights reserved.
//

import UIKit

@IBDesignable
public class SubmitButton: UIButton {

    lazy var spiner: SpinerLayer! = {
        let s = SpinerLayer(frame: self.frame)
        self.layer.addSublayer(s)
        return s
    }()
    
    @IBInspectable var spinnerColor: UIColor = UIColor.whiteColor() {
        didSet {
            spiner.spinnerColor = spinnerColor
        }
    }
    
    public var didEndFinishAnimation : (()->())? = nil
    let springGoEase = CAMediaTimingFunction(controlPoints: 0.45, -0.36, 0.44, 0.92)
    let shrinkCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    let expandCurve = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    let shrinkDuration: CFTimeInterval  = 0.2
    var cachedTitle: String?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    public required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    func setup() {
        self.clipsToBounds = true
        spiner.spinnerColor = spinnerColor
    }
    public func startLoadingAnimation() {
        self.cachedTitle = titleForState(.Normal)
        self.setTitle("", forState: .Normal)
        self.returnToOriginalState()
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.layer.cornerRadius = self.frame.height / 2
            }) { (done) -> Void in
                self.shrink()
                NSTimer.schedule(delay: self.shrinkDuration - 0.25) { timer in
                    self.spiner.animation()
                }
        }
    }
    public func animateCompletionSuccess(completion:(()->())?) {
        self.didEndFinishAnimation = completion
        self.expand()
        self.spiner.stopAnimation()
    }
    public func animateCompletionFailed(completion:(()->())?) {
        self.didEndFinishAnimation = completion
        
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.height
        shrinkAnim.toValue = frame.width
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = kCAFillModeForwards
        shrinkAnim.removedOnCompletion = false
        
        let keyFrame: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        let point: CGPoint = self.layer.position
        keyFrame.values = [NSValue(CGPoint: CGPointMake(point.x, point.y)),
            NSValue(CGPoint: CGPointMake(point.x - 10, point.y)),
            NSValue(CGPoint: CGPointMake(point.x + 10, point.y)),
            NSValue(CGPoint: CGPointMake(point.x - 10, point.y)),
            NSValue(CGPoint: CGPointMake(point.x + 10, point.y)),
            NSValue(CGPoint: CGPointMake(point.x - 10, point.y)),
            NSValue(CGPoint: CGPointMake(point.x + 10, point.y)),
            NSValue(CGPoint: point)]
        keyFrame.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        keyFrame.duration = 0.5
        keyFrame.delegate = self
        self.layer.position = point
        
        layer.addAnimation(keyFrame, forKey: keyFrame.keyPath)
        layer.addAnimation(shrinkAnim, forKey: shrinkAnim.keyPath)
        
        self.spiner.stopAnimation()
        
        self.userInteractionEnabled = true
    }
    
    public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let a = anim as? CABasicAnimation {
            if a.keyPath == "transform.scale" {
                didEndFinishAnimation?()
                NSTimer.schedule(delay: 1) { timer in
                    self.returnToOriginalState()
                }
            }
        }
    }
    
    public func returnToOriginalState() {
        
        self.layer.removeAllAnimations()
        self.setTitle(self.cachedTitle, forState: .Normal)
        self.spiner.stopAnimation()
    }
    
    func shrink() {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.width
        shrinkAnim.toValue = frame.height
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = kCAFillModeForwards
        shrinkAnim.removedOnCompletion = false
        layer.addAnimation(shrinkAnim, forKey: shrinkAnim.keyPath)
    }
    
    func expand() {
        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        expandAnim.fromValue = 1.0
        expandAnim.toValue = 33.0
        expandAnim.timingFunction = expandCurve
        expandAnim.duration = 0.8
        expandAnim.delegate = self
        expandAnim.fillMode = kCAFillModeForwards
        expandAnim.removedOnCompletion = false
        layer.addAnimation(expandAnim, forKey: expandAnim.keyPath)
    }

}
