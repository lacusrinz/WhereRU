//
//  TokenView.swift
//  WhereRU
//
//  Created by RInz on 15/9/5.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

let PADDING_X: CGFloat = 4.0
let PADDING_Y: CGFloat = 2.0

protocol TokenViewDelegate {
    func tokenViewDidRequestDeleteandReplaceWithText(tokenView: TokenView, replacementText: String?)
    func tokenViewDidRequestSelection(tokenView: TokenView)
}

class TokenView: UIView, UIKeyInput {

    private var _selected: Bool?
    private var backgroundView: UIView?
    private var label: UILabel?
    private var selectedBackgroundView: UIView?
    private var selectedLabel: UILabel?
    private var displayText: String?
    
    var selected: Bool{
        get {
            return _selected!
        }
        set {
            self.setSelected(newValue, animated: false)
        }
    }
    
    var tokenViewDelegate: TokenViewDelegate?
    
    init(token: Token) {
        super.init(frame: CGRectZero)
        let tintColor: UIColor = self.tintColor
        
        self.backgroundView = UIView(frame: CGRectZero)
        
        self.label = UILabel(frame: CGRectMake(PADDING_X, PADDING_Y, 0, 0))
        self.label!.font = UIFont.systemFontOfSize(17)
        self.label!.textColor = tintColor
        self.label!.backgroundColor = UIColor.clearColor()
        self.addSubview(self.label!)
        
        self.selectedBackgroundView = UIView(frame: CGRectZero)
        self.selectedBackgroundView!.backgroundColor = tintColor
        self.selectedBackgroundView!.layer.cornerRadius = 3.0
        self.addSubview(self.selectedBackgroundView!)
        self.selectedBackgroundView!.hidden = true
        
        self.selectedLabel = UILabel(frame: CGRectMake(PADDING_X, PADDING_Y, 0, 0))
        self.selectedLabel!.font = self.label!.font
        self.selectedLabel!.textColor = UIColor.whiteColor()
        self.selectedLabel!.backgroundColor = UIColor.clearColor()
        self.addSubview(self.selectedLabel!)
        self.selectedLabel!.hidden = true
        
        self.displayText = token.displayText
        
        // Configure for the token, unselected shows "displayText," and selected is "[displayText]"
        let labelString: String = self.displayText!
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: labelString, attributes: [NSFontAttributeName: self.label!.font, NSForegroundColorAttributeName: tintColor])
        self.label!.attributedText = attrString
        self.selectedLabel!.text = token.displayText!
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGestureRecognizer")
        self.addGestureRecognizer(tapRecognizer)
        
        self.setNeedsLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func intrinsicContentSize() -> CGSize {
        let labelIntrinsicSize: CGSize = self.selectedLabel!.intrinsicContentSize()
        return CGSizeMake(labelIntrinsicSize.width+(2.0*PADDING_X), labelIntrinsicSize.height+(2.0*PADDING_Y))
    }

    override func sizeThatFits(size: CGSize) -> CGSize {
        let fittingSize: CGSize = CGSizeMake(size.width-(2.0*PADDING_X), size.height-(2.0*PADDING_Y))
        let labelSize: CGSize = self.selectedLabel!.sizeThatFits(fittingSize)
        return CGSizeMake(labelSize.width+(2.0*PADDING_X), labelSize.height+(2.0*PADDING_Y))
    }
    
    // MARK: - Tap
    func handleTapGestureRecognizer() {
        self.tokenViewDelegate!.tokenViewDidRequestSelection(self)
    }
    
    // MARK: - Selected
    func setSelected(selected: Bool, animated: Bool) {
        if(_selected == selected) {
            return
        }
        _selected = selected
        if(selected) {
            self.becomeFirstResponder()
        }
        let selectedAlpha: CGFloat = _selected! ? 1.0 : 0.0
        if(animated) {
            if (_selected!) {
                self.selectedBackgroundView!.alpha = 0.0
                self.selectedBackgroundView!.hidden = false
                self.selectedLabel!.alpha = 0.0
                self.selectedLabel!.hidden = false
            }
        UIView.animateWithDuration(0.25,
            animations: { () -> Void in
            self.selectedBackgroundView!.alpha = selectedAlpha
            self.selectedLabel!.alpha = selectedAlpha
            })
            { (finished: Bool) -> Void in
                if (!self._selected!) {
                    self.selectedBackgroundView!.hidden = true
                    self.selectedLabel!.hidden = true
                }
            }
        }
        else {
            self.selectedBackgroundView!.hidden = !_selected!
            self.selectedLabel!.hidden = !_selected!
        }
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds: CGRect = self.bounds
        
        self.backgroundView!.frame = bounds
        self.selectedBackgroundView!.frame = bounds
        
        var labelFrame: CGRect = CGRectInset(bounds, PADDING_X, PADDING_Y)
        self.selectedLabel!.frame = labelFrame
        labelFrame.size.width += PADDING_X * 2.0
        self.label!.frame = labelFrame
    }
    
    // MARK: - UIKeyInput protocol
    func hasText() -> Bool {
        return true
    }
    
    func insertText(text: String) {
        self.tokenViewDelegate!.tokenViewDidRequestDeleteandReplaceWithText(self, replacementText: text)
    }
    
    func deleteBackward() {
        self.tokenViewDelegate!.tokenViewDidRequestDeleteandReplaceWithText(self, replacementText: nil)
    }
    
    // MARK: - First Responder (needed to capture keyboard)
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
}
