//
//  NewSupportTicketViewController.swift
//  TVist
//
//  Created by Rahul Meena on 20/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class NewSupportTicketViewController: UIViewController {

    @IBOutlet weak var doneButton: CustomDoneButton!
    
    @IBOutlet weak var supportTitleView: HighlightableTextView!
    @IBOutlet weak var supportBodyView: HighlightableTextView!
    @IBOutlet weak var supportTypeView: HighlightableTextView!
    
    var selectedSupportType: SupportTicketType?
    
    var supportTypes: [SupportTicketType] = [.technical, .general, .howTo, .bugReport, .other]
    var titlesForSupportTypes: [SupportTicketType: String] = [
        .technical:  "Technical",
        .general: "General",
        .howTo: "How To",
        .bugReport: "Bug Report",
        .other: "Other"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.doneButton.enableButton = false
        self.supportTitleView.delegate = self
        self.supportBodyView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func didTapOnSupportTypeButton(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Support Type", message: nil, preferredStyle: .actionSheet)
        
        for supportType in supportTypes {
            if let titleForSupportType = titlesForSupportTypes[supportType] {
                
                let supportAction = UIAlertAction(title: titleForSupportType, style: .default, handler: { (action) in
                    self.didSelectSupportType(supportType: supportType)
                })
                
                alertController.addAction(supportAction)
            }
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.popoverPresentationController?.sourceView = self.supportTypeView
        alertController.popoverPresentationController?.sourceRect = self.supportTypeView.bounds
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didSelectSupportType(supportType: SupportTicketType) {
        if let title = titlesForSupportTypes[supportType] {
            self.supportTypeView.setText(text: title)
        }
        self.selectedSupportType = supportType
        
        determineDoneButtonState()
    }
    
    func determineDoneButtonState() {
        doneButton.enableButton = allFieldsFilled()
    }
    
    func allFieldsFilled() -> Bool {
        return self.selectedSupportType != nil && self.supportTitleView.isSet() && self.supportBodyView.isSet()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if allFieldsFilled() {
            
            self.view.endEditing(true)
            
            self.doneButton.isLoading = true
            
            UserDataProvider.sharedDataProvider.createNewSupportTicket(title: self.supportTitleView.textView.text, supportType: self.selectedSupportType!, body: self.supportBodyView.textView.text)
        }
    }
    
}

extension NewSupportTicketViewController: HighlightableTextViewProtocol {
    func textViewDidChange() {
        determineDoneButtonState()
    }
}
