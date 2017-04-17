//
//  RelatedPeopleViewController.swift
//  Escape
//
//  Created by Rahul Meena on 16/04/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class RelatedPeopleViewController: GenericAllItemsListViewController {
    var escapeType: EscapeType!
    var escapeId: String?
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        if let escapeTypeStr = queryParams["escapeType"] as? String, let escapeType = EscapeType(rawValue: escapeTypeStr)  {
            self.escapeType = escapeType
        }
        
        
        if let escapeId = queryParams["escapeId"] as? String {
            self.escapeId = escapeId
        }
    }
    
    override func fetchRequest() {
        if let escapeId = escapeId {
            MyAccountDataProvider.sharedDataProvider.relatedPeopleDelegate = self
            MyAccountDataProvider.sharedDataProvider.getRelatedPeople(escapeId: escapeId, page: nextPage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}

extension RelatedPeopleViewController: RelatedPeopleProtocol {
    func receivedRelatedPeople(_ relatedPeople: [MyAccountItems], page: Int?) {
        appendDataToBeListed(appendableData: relatedPeople, page: page)
    }
    func failedToReceivedData() {
        
    }
}
