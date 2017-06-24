//
//  GenericEscapeListViewController.swift
//  Escape
//
//  Created by Rahul Meena on 30/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class UserEscapeListViewController: GenericAllItemsListViewController {
    
    var escapeType: EscapeType!
    var escapeAction: String!
    var userId: String?
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        if let escapeTypeStr = queryParams["escapeType"] as? String, let escapeType = EscapeType(rawValue: escapeTypeStr)  {
            self.escapeType = escapeType
        }
        
        if let escapeAction = queryParams["escapeAction"] as? String {
            self.escapeAction = escapeAction
            self.title = escapeAction
        }
        
        if let userId = queryParams["userId"] as? String {
            self.userId = userId
        }
    }
    
    override func fetchRequest() {
        MyAccountDataProvider.sharedDataProvider.escapeListDataDelegate = self
        MyAccountDataProvider.sharedDataProvider.getUserEscapes(escapeType, escapeAction: escapeAction, userId: userId, page: nextPage)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

extension UserEscapeListViewController: EscapeListDataProtocol {
    func receivedEscapeListData(_ escapeData: [EscapeItem], page: Int?, escapeType: String?, escapeAction: String?, userId: String?) {
        
        if self.userId == userId {
            
            if let escapeType = escapeType, let escapeAction = escapeAction, escapeType == self.escapeType.rawValue && escapeAction == self.escapeAction {
                appendDataToBeListed(appendableData: escapeData, page: page)
            }
        }
    }
    
    func failedToReceiveData() {
        // Failure case
    }
}
