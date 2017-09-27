//
//  UpdateDetailsInputViewController.swift
//  TVist
//
//  Created by Rahul Meena on 24/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class UpdateDetailsInputViewController: UIViewController, HighlightableTextViewProtocol {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: HighlightableTextView!
    @IBOutlet weak var doneButton: CustomDoneButton!
    
    var presentingVC: UIViewController?
    var presentedVCObj : CustomPopupPresentationController?
    
    var previousValue: String = ""
    var editingFieldType: EditableFieldType!
    var isPasswordField: Bool = false
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let previousValue = queryParams["previousValue"] as? String {
            self.previousValue = previousValue
        }
        
        if let editableField = queryParams["fieldType"] as? EditableFieldType {
            self.editingFieldType = editableField
            self.isPasswordField = (self.editingFieldType == EditableFieldType.passwordField)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if previousValue != "" {
            self.textView.setText(text: previousValue)
        }
        self.textView.delegate = self
        
        if self.editingFieldType == EditableFieldType.emailField {
            self.titleLabel.text = "Update Email Address"
            if previousValue == "" {
             
                self.textView.setPlaceholder(text: "Enter email address")
            }
        }
        
        if self.editingFieldType == EditableFieldType.firstNameField {
            self.titleLabel.text = "Update First Name"
            if previousValue == "" {
                self.textView.setPlaceholder(text: "Enter first name")
            }
            
        }
        
        if self.editingFieldType == EditableFieldType.lastNameField {
            self.titleLabel.text = "Update Last Name"
            if previousValue == "" {
                self.textView.setPlaceholder(text: "Enter last name")
            }
        }
        
        determinDoneButtonFate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textView.textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func determinDoneButtonFate() {
        if editingFieldType == EditableFieldType.emailField {
            self.doneButton.enableButton = (previousValue != self.textView.getValue() && self.textView.isSet())
        } else {
         
            self.doneButton.enableButton = (previousValue != self.textView.getValue() && self.textView.isSet())
        }
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        if editingFieldType == EditableFieldType.emailField {
            if !self.textView.isSet() || !OnBoardingUtility.isValidEmail(self.textView.getValue()) {
                loadErrorPopUp("Please enter a valid email address")
                return
            }
            
            MyAccountDataProvider.sharedDataProvider.updateEmail(email: self.textView.getValue())
        }
        
        if editingFieldType == EditableFieldType.firstNameField {
            if !self.textView.isSet() {
                loadErrorPopUp("Please enter first name")
                return
            }
            MyAccountDataProvider.sharedDataProvider.updateFirstName(firstName: self.textView.getValue())
        }
        
        if editingFieldType == EditableFieldType.lastNameField {
            if !self.textView.isSet() {
                loadErrorPopUp("Please enter last name")
                return
            }
            MyAccountDataProvider.sharedDataProvider.updateLastName(lastName: self.textView.getValue())
        }
        
        self.dismissPopup()
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismissPopup()
    }
    
    
    func loadErrorPopUp(_ str : String){
        
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func textViewDidChange() {
        determinDoneButtonFate()
    }
}


extension UpdateDetailsInputViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = CustomPopupPresentationController(presentedViewController: presented, presentingViewController: presentingVC!, width: 310, height: 200, yOffset: 80, cornerRadius: 4)
        presentedVCObj = presentationController
        return presentationController;
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented != self {
            return nil
        }
        return CustomPresentationAnimationViewController(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed != self {
            return nil
        }
        return CustomPresentationAnimationViewController(isPresenting: false)
    }
}
