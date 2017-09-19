//
//  UIViewController+Utility.swift
//  Escape
//
//  Created by Ankit on 21/04/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

extension UIViewController{
    
    
    @objc func setObjectsWithQueryParameters(_ queryParams: [String:Any]) {
        //vcFootPrint = createClassFootPrintWith(theClassName, queryParams: queryParams)
        // Receive Parameterized Data
    }
    
    func addNavigationBarDoneButton() {
        if let _ = self.navigationController {
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIViewController.dismissPopup))
            self.navigationItem.rightBarButtonItem = barButtonItem
        }
    }
    
    @objc func dismissPopup() {
        if let navController = self.navigationController {
            navController.dismiss(animated: true, completion: { 
                self.didDismissPopup()
            })
        }
    }
    
    func didDismissPopup() {
        //overriden in base classes
    }
}
