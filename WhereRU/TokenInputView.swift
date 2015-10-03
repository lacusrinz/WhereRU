//
//  TokenInputView.swift
//  WhereRU
//
//  Created by RInz on 15/9/5.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

let HSPACE: CGFloat = 0.0
let TEXT_FIELD_HSPACE: CGFloat = 4.0
let VSPACE: CGFloat = 4.0
let MINIMUM_TEXTFIELD_WIDTH: CGFloat = 56
let PADDING_TOP: CGFloat = 10.0
let PADDING_BOTTOM: CGFloat = 10.0
let PADDING_LEFT: CGFloat = 8.0
let PADDING_RIGHT: CGFloat = 16.0
let STANDARD_ROW_HEIGHT: CGFloat = 25.0
let FIELD_MARGIN_X: CGFloat = 4

protocol TokenInputViewDelegate {
    func tokenInputViewDidEndEditing(view: TokenInputView)
    func tokenInputViewDidBeginEditing(view: TokenInputView)
    func tokenInputView(view: TokenInputView, didChangeText text: String)
    func tokenInputView(view: TokenInputView, didAddToken token: Token)
    func tokenInputView(view: TokenInputView, didRemoveToken token: Token)
    func tokenInputView(view: TokenInputView, tokenForText text: String) -> Token?
    func tokenInputView(view: TokenInputView, didChangeHeightTo height: CGFloat)
}

class TokenInputView: UIView, BackspaceDetectingTextFieldDelegate, TokenViewDelegate {

    private var _keyboardType: UIKeyboardType?
    @IBInspectable var keyboardType: UIKeyboardType? {
        get {
            return _keyboardType
        }
        set {
            _keyboardType = newValue
            self.textField?.keyboardType = _keyboardType!
        }
    }
    private var _autocapitalizationType: UITextAutocapitalizationType?
    @IBInspectable var autocapitalizationType: UITextAutocapitalizationType? {
        get {
            return _autocapitalizationType
        }
        set {
            _autocapitalizationType = newValue
            self.textField?.autocapitalizationType = _autocapitalizationType!
        }
    }
    private var _autocorrectionType: UITextAutocorrectionType?
    @IBInspectable var autocorrectionType: UITextAutocorrectionType? {
        get {
            return _autocorrectionType
        }
        set {
            _autocorrectionType = newValue
            self.textField?.autocorrectionType = _autocorrectionType!
        }
    }
    private var _drawBottomBorder: Bool?
    @IBInspectable var drawBottomBorder: Bool? {
        get {
            return _drawBottomBorder
        }
        set {
            if (_drawBottomBorder == newValue) {
                return
            }
            _drawBottomBorder = newValue
            self.setNeedsDisplay()
        }
    }
    
    var delegate: TokenInputViewDelegate?
    var fieldView: UIView?
    var fieldName: String?
    var accessoryView: UIView?
    
    private var _placeholderText: String?
    var placeholderText: String? {
        get {
            return _placeholderText
        }
        set {
            if _placeholderText == newValue {
                return
            }
            _placeholderText = newValue
            self.updatePlaceholderTextVisibility()
        }
    }
    
    private var _allTokens: [Token]?
    var allTokens: [Token]? {
        get {
            return self.tokens
        }
        set {
            _allTokens = newValue
        }
    }
    
    private var _editing: Bool?
    var editing: Bool? {
        get {
            return self.textField!.editing
        }
        set {
            _editing = newValue
        }
    }
    
    private var _textFieldDisplayOffset: CGFloat?
    var textFieldDisplayOffset: CGFloat? {
        get {
            return CGRectGetMinY(self.textField!.frame) - PADDING_TOP
        }
        set {
            _textFieldDisplayOffset = newValue
        }
    }
    
    private var _text: String?
    var text: String? {
        get {
            return self.textField!.text!
        }
        set {
            _text = newValue
        }
    }
    
    private var tokens: [Token]?
    private var tokenViews: [TokenView]?
    private var textField: BackspaceDetectingTextField?
    private var fieldLabel: UILabel?
    private var intrinsicContentHeight: CGFloat?
    private var additionalTextFieldYOffset: CGFloat?
    
    func commonInit() {
        self.textField = BackspaceDetectingTextField(frame: self.bounds)
        self.textField!.backgroundColor = UIColor.clearColor()
        self.textField!.keyboardType = UIKeyboardType.EmailAddress
        self.textField!.autocorrectionType = UITextAutocorrectionType.No
        self.textField!.autocapitalizationType = UITextAutocapitalizationType.None
        self.textField!.backspaceDetectingTextFielddelegate = self
        self.additionalTextFieldYOffset = 0
        if(self.textField!.defaultTextAttributes.isEmpty) {
            self.additionalTextFieldYOffset = 1.5
        }
        self.textField!.addTarget(self, action: "onTextFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
        self.addSubview(self.textField!)
        
        self.tokens = [Token]()
        self.tokenViews = [TokenView]()
        
        self.fieldLabel = UILabel(frame: CGRectZero)
        self.fieldLabel!.font = self.textField!.font
        self.fieldLabel!.textColor = UIColor.lightGrayColor()
        self.addSubview(self.fieldLabel!)
        self.fieldLabel!.hidden = true
        
        self.intrinsicContentHeight = STANDARD_ROW_HEIGHT
        self.repositionViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, max(45, self.intrinsicContentHeight!))
    }
    
    // MARK: - Tint color
    override func tintColorDidChange() {
        for tokenView: TokenView in self.tokenViews! {
            tokenView.tintColor = self.tintColor
        }
    }
    
    // MARK: - Adding / Removing Tokens
    func addToken(token: Token) {
        if ((self.tokens!).contains(token)) {
            return
        }
        self.tokens!.append(token)
        let tokenView: TokenView = TokenView(token: token)
        tokenView.tintColor = self.tintColor
        tokenView.tokenViewDelegate = self
        let intrinsicSize: CGSize = tokenView.intrinsicContentSize()
        tokenView.frame = CGRectMake(0, 0, intrinsicSize.width, intrinsicSize.height)
        self.tokenViews!.append(tokenView)
        self.addSubview(tokenView)
        self.textField!.text = ""
        self.delegate!.tokenInputView(self, didAddToken: token)
        self.updatePlaceholderTextVisibility()
        self.repositionViews()
    }
    
    func removeToken(token: Token) {
        let index: Int = (self.tokens!).indexOf(token)!
        if index == NSNotFound {
            return
        }
        self.removeTokenAtIndex(index)
    }
    
    func removeTokenAtIndex(index: Int) {
        if index == NSNotFound {
            return
        }
        let tokenView: TokenView = self.tokenViews![index]
        tokenView.removeFromSuperview()
        self.tokenViews!.removeAtIndex(index)
        let removedToken: Token = self.tokens![index]
        self.tokens?.removeAtIndex(index)
        self.delegate!.tokenInputView(self, didRemoveToken: removedToken)
        self.updatePlaceholderTextVisibility()
        self.repositionViews()
    }
    
    func tokenizeTextfieldText() -> Token? {
        var token: Token? = nil
        let text: String = self.textField!.text!
        if text.characters.count > 0 {
            token = self.delegate!.tokenInputView(self, tokenForText: text)
            if token != nil {
                self.addToken(token!)
                self.textField!.text = ""
                self.onTextFieldDidChange()
            }
        }
        return token
    }
    
    func repositionViews() {
        let bounds: CGRect = self.bounds
        let rightBoundary: CGFloat = CGRectGetWidth(bounds) - PADDING_RIGHT
        var firstLineRightBoundary: CGFloat = rightBoundary
        
        var curX: CGFloat = PADDING_LEFT
        var curY: CGFloat = PADDING_TOP
        var totalHeight: CGFloat = STANDARD_ROW_HEIGHT
        var isOnFirstLine: Bool = true
        
        // Position field view (if set)
        if (self.fieldView != nil) {
            var fieldViewRect: CGRect = self.fieldView!.frame
            fieldViewRect.origin.x = curX + FIELD_MARGIN_X
            fieldViewRect.origin.y = curY + ((STANDARD_ROW_HEIGHT - CGRectGetHeight(fieldViewRect))/2.0)
            self.fieldView!.frame = fieldViewRect
            
            curX = CGRectGetMaxX(fieldViewRect) + FIELD_MARGIN_X
        }
        
        // Position field label (if field name is set)
        if (!self.fieldLabel!.hidden) {
            var fieldLabelRect: CGRect = self.fieldLabel!.frame
            fieldLabelRect.origin.x = curX + FIELD_MARGIN_X
            fieldLabelRect.origin.y = curY + ((STANDARD_ROW_HEIGHT-CGRectGetHeight(fieldLabelRect))/2.0)
            self.fieldLabel!.frame = fieldLabelRect
            
            curX = CGRectGetMaxX(fieldLabelRect) + FIELD_MARGIN_X
        }
        
        // Position accessory view (if set)
        if (self.accessoryView != nil) {
            var accessoryRect: CGRect = self.accessoryView!.frame
            accessoryRect.origin.x = CGRectGetWidth(bounds) - PADDING_RIGHT - CGRectGetWidth(accessoryRect)
            accessoryRect.origin.y = curY
            self.accessoryView!.frame = accessoryRect
            
            firstLineRightBoundary = CGRectGetMinX(accessoryRect) - HSPACE
        }
        
        // Position token views
        var tokenRect: CGRect = CGRectNull
        for tokenView: UIView in self.tokenViews! {
            tokenRect = tokenView.frame
            
            let tokenBoundary: CGFloat = isOnFirstLine ? firstLineRightBoundary : rightBoundary
            if (curX + CGRectGetWidth(tokenRect) > tokenBoundary) {
                // Need a new line
                curX = PADDING_LEFT
                curY += STANDARD_ROW_HEIGHT+VSPACE
                totalHeight += STANDARD_ROW_HEIGHT
                isOnFirstLine = false
            }
            
            tokenRect.origin.x = curX
            // Center our tokenView vertially within STANDARD_ROW_HEIGHT
            tokenRect.origin.y = curY + ((STANDARD_ROW_HEIGHT-CGRectGetHeight(tokenRect))/2.0)
            tokenView.frame = tokenRect
            
            curX = CGRectGetMaxX(tokenRect) + HSPACE
        }
        
        // Always indent textfield by a little bit
        curX += TEXT_FIELD_HSPACE
        let textBoundary: CGFloat = isOnFirstLine ? firstLineRightBoundary : rightBoundary
        var availableWidthForTextField: CGFloat = textBoundary - curX
        if (availableWidthForTextField < MINIMUM_TEXTFIELD_WIDTH) {
            isOnFirstLine = false
            curX = PADDING_LEFT + TEXT_FIELD_HSPACE
            curY += STANDARD_ROW_HEIGHT+VSPACE
            totalHeight += STANDARD_ROW_HEIGHT
            // Adjust the width
            availableWidthForTextField = rightBoundary - curX
        }
        
        var textFieldRect: CGRect = self.textField!.frame
        textFieldRect.origin.x = curX
        textFieldRect.origin.y = curY + self.additionalTextFieldYOffset!
        textFieldRect.size.width = availableWidthForTextField
        textFieldRect.size.height = STANDARD_ROW_HEIGHT
        self.textField!.frame = textFieldRect
        
        let oldContentHeight: CGFloat = self.intrinsicContentHeight!
        self.intrinsicContentHeight = CGRectGetMaxY(textFieldRect)+PADDING_BOTTOM
        self.invalidateIntrinsicContentSize()
        
        if (oldContentHeight != self.intrinsicContentHeight!) {
            self.delegate?.tokenInputView(self, didChangeHeightTo: self.intrinsicContentSize().height)
        }
        self.setNeedsDisplay()
    }
    
    func updatePlaceholderTextVisibility() {
        if (self.tokens!.count > 0) {
            self.textField!.placeholder = nil
        } else {
            self.textField!.placeholder = self.placeholderText
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.repositionViews()
    }
    
    // MARK: - BackspaceDetectingTextFieldDelegate
    func textFieldDidDeleteBackwards(textField: UITextField) {
        if (textField.text!.characters.count == 0) {
            let tokenView: TokenView? = self.tokenViews!.last
            if (tokenView != nil) {
                self.selectTokenView(tokenView!, animated: true)
                self.textField!.resignFirstResponder()
            }
        }
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate!.tokenInputViewDidBeginEditing(self)
        self.unselectAllTokenViewsAnimated(true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.delegate!.tokenInputViewDidEndEditing(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.tokenizeTextfieldText()
        return false
    }
    
    //MARK: - Text Field Changes
    func onTextFieldDidChange() {
        self.delegate!.tokenInputView(self, didChangeText: self.textField!.text!)
    }
    
    //MARK: -  TokenViewDelegate
    func tokenViewDidRequestDeleteandReplaceWithText(tokenView: TokenView, replacementText: String?) {
        self.textField?.becomeFirstResponder()
        if replacementText != nil && (replacementText!).characters.count > 0 {
            self.textField!.text = replacementText
        }
        let index: Int = (self.tokenViews!).indexOf(tokenView)!
        if index == NSNotFound {
            return
        }
        self.removeTokenAtIndex(index)
    }
    
    func tokenViewDidRequestSelection(tokenView: TokenView) {
        self.selectTokenView(tokenView, animated: true)
    }
    
    //MARK: - Token selection
    func selectTokenView(tokenView: TokenView, animated: Bool) {
        tokenView.setSelected(true, animated: animated)
        for otherTokenView: TokenView in self.tokenViews! {
            if otherTokenView != tokenView {
                otherTokenView.setSelected(false, animated: animated)
            }
        }
    }
    
    func unselectAllTokenViewsAnimated(animated: Bool) {
        for tokenView: TokenView in self.tokenViews! {
            tokenView.setSelected(false, animated: animated)
        }
    }
    
    //MARK: - Editing
    func beginEditing() {
        self.textField?.becomeFirstResponder()
        self.unselectAllTokenViewsAnimated(false)
    }
    
    func endEditing() {
        self.textField?.resignFirstResponder()
    }
    
    //MARK: - Drawing
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if self.drawBottomBorder != nil {
            let context: CGContextRef = UIGraphicsGetCurrentContext()!
            let bounds: CGRect = self.bounds
            CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor)
            CGContextSetLineWidth(context, 0.5)
            
            CGContextMoveToPoint(context, 0, bounds.size.height)
            CGContextAddLineToPoint(context, CGRectGetWidth(bounds), bounds.size.height)
            CGContextStrokePath(context)
        }
    }
}
