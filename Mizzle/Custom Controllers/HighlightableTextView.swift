//
//  HighlightableTextView.swift
//  Escape
//
//  Created by Rahul Meena on 22/10/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol HighlightableTextViewProtocol: class {
    func textViewDidChange()
}

class HighlightableTextView: UIView {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var textView: UITextView!
    var isPasswordField:Bool = false
    var placeholder:String!
    
    var passwordFieldValue: String = ""
    
    weak var delegate:HighlightableTextViewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.placeholder = textView.text
    }

    func setText(text: String) {
        textView.text = text
        textView.textColor = UIColor.styleGuideMainTextColor()
    }
    
    func setPlaceholder(text: String) {
        self.placeholder = text
        self.textView.text = text
    }
    
    func isSet() -> Bool {
        return self.textView.text.characters.count > 0 && self.placeholder != self.textView.text
    }
    
    func getValue() -> String {
        if isPasswordField {
            return self.passwordFieldValue
        }
        
        if self.placeholder == self.textView.text {
            return ""
        }
        
        return self.textView.text
    }
}

extension HighlightableTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.lineView.backgroundColor = UIColor.styleGuideActionButtonBlue()
        
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = UIColor.styleGuideMainTextColor()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.lineView.backgroundColor = UIColor.styleGuideLineGrayLight()
        
        if textView.text.isEmpty {
            textView.text = self.placeholder
            textView.textColor = UIColor.styleGuideBodyTextColor()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        if isPasswordField {
            self.passwordFieldValue = (self.passwordFieldValue as NSString?)?.replacingCharacters(in: range, with: text) ?? text
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if isPasswordField {
            self.perform(#selector(HighlightableTextView.convertToSecureText), with: nil, afterDelay: 0.85)
        }
        if let delegate = self.delegate {
            delegate.textViewDidChange()
        }
    }
    
    @objc func convertToSecureText() {
        self.textView.text = Array.init(repeating: "●", count: self.passwordFieldValue.count).joined(separator: "")
    }
}
