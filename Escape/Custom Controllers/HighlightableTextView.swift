//
//  HighlightableTextView.swift
//  Escape
//
//  Created by Rahul Meena on 22/10/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol HighlightableTextViewProtocol: class {
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
}

class HighlightableTextView: UIView {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var textField: UITextField!
    weak var delegate:HighlightableTextViewProtocol?

}

extension HighlightableTextView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lineView.backgroundColor = UIColor.mizzleBlueColor()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.lineView.backgroundColor = UIColor.lineGrayColor()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let delegate = self.delegate {
            return delegate.textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
        }
        return true
    }
    
}
