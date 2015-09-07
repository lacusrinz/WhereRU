//
//  TokenInputView.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/9/5.
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
    func tokenInputView(view: TokenInputView, tokenForText text: String) -> Token
    func tokenInputView(view: TokenInputView, didChangeHeightTo height: CGFloat)
}

class TokenInputView: UIView, BackspaceDetectingTextFieldDelegate, TokenViewDelegate {

    @IBInspectable var keyboardType: UIKeyboardType?
    @IBInspectable var autocapitalizationType: UITextAutocapitalizationType?
    @IBInspectable var autocorrectionType: UITextAutocorrectionType?
    @IBInspectable var drawBottomBorder: Bool?
    
    var delegate: TokenInputViewDelegate?
    var fieldView: UIView?
    var fieldName: String?
    var placeholderText: String?
    var accessoryView: UIView?
    
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
            return _editing
        }
        set {
            _editing = newValue
        }
    }
    var textFieldDisplayOffset: CGFloat?
    var text: String?
    
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
        if(self.textField!.defaultTextAttributes == nil) {
            self.additionalTextFieldYOffset = 1.5
        }
        self.textField!.addTarget(self, action: "onTextFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
        self.addSubview(self.textField!)
        
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

    required init(coder aDecoder: NSCoder) {
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
        if (contains(self.tokens!, token)) {
            return
        }
        self.tokens!.append(token)
        var tokenView: TokenView = TokenView(token: token)
        tokenView.tintColor = self.tintColor
        tokenView.tokenViewDelegate = self
        var intrinsicSize: CGSize = tokenView.intrinsicContentSize()
        tokenView.frame = CGRectMake(0, 0, intrinsicSize.width, intrinsicSize.height)
        self.tokenViews!.append(tokenView)
        self.addSubview(tokenView)
        self.textField!.text = ""
        self.delegate!.tokenInputView(self, didAddToken: token)
    }
    
    func removeToken(token: Token) {
        var index: Int = find(self.tokens!, token)!
        if index == NSNotFound {
            return
        }
        self.removeTokenAtIndex(index)
    }
    
    func removeTokenAtIndex(index: Int) {
        if index == NSNotFound {
            return
        }
        var tokenView: TokenView = self.tokenViews![index]
        tokenView.removeFromSuperview()
        self.tokenViews!.removeAtIndex(index)
        var removedToken: Token = self.tokens![index]
        self.delegate!.tokenInputView(self, didRemoveToken: removedToken)
        self.updatePlaceholderTextVisibility()
        self.repositionViews()
    }
    
    func tokenizeTextfieldText() -> Token {
        var token: Token? = nil
        var text: String = self.textField!.text
        if count(text) > 0 {
            token = self.delegate!.tokenInputView(self, tokenForText: text)
            if token != nil {
                self.addToken(token!)
                self.textField!.text = ""
                self.onTextFieldDidChange()
            }
        }
        return token!
    }
    
    func repositionViews() {
        //TODO
    }
    
    func updatePlaceholderTextVisibility() {
        //TODO
    }
    
    func textFieldDidDeleteBackwards(textField: UITextField) {
        //TODO
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //TODO
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //TODO
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //TODO
        return false
    }
    
    func onTextFieldDidChange() {
        //TODO
    }
    
    func tokenViewDidRequestDeleteandReplaceWithText(tokenView: TokenView, replacementText: String?) {
        //TODO
    }
    
    func tokenViewDidRequestSelection(tokenView: TokenView) {
        //TODO
    }
}
