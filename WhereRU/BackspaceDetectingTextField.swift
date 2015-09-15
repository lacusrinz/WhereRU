//
//  BackspaceDetectingTextField.swift
//  WhereRU
//
//  Created by RInz on 15/9/5.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

protocol BackspaceDetectingTextFieldDelegate: UITextFieldDelegate {
    func textFieldDidDeleteBackwards(textField: UITextField)
}

class BackspaceDetectingTextField: UITextField {
    private var _backspaceDetectingTextFielddelegate: BackspaceDetectingTextFieldDelegate?
    var backspaceDetectingTextFielddelegate: BackspaceDetectingTextFieldDelegate? {
        get {
            return _backspaceDetectingTextFielddelegate
        }
        set {
            _backspaceDetectingTextFielddelegate = newValue
            super.delegate = _backspaceDetectingTextFielddelegate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deleteBackward() {
        self.backspaceDetectingTextFielddelegate!.textFieldDidDeleteBackwards(self)
    }
}
