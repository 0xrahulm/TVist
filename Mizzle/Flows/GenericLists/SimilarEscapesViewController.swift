//
//  SimilarEscapesViewController.swift
//  Escape
//
//  Created by Rahul Meena on 16/04/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class SimilarEscapesViewController: GenericAllItemsListViewController {
    
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
            MyAccountDataProvider.sharedDataProvider.similarEscapesDelegate = self
            MyAccountDataProvider.sharedDataProvider.getSimilarEscapes(escapeId: escapeId, escapeType: escapeType, page: nextPage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension SimilarEscapesViewController: SimilarEscapesProtocol {
    func receivedSimilarEscapes(_ escapeData: [EscapeItem], page: Int?) {
        appendDataToBeListed(appendableData: escapeData, page: page)
    }
    
    func failedToReceivedData() {
        
    }
}
