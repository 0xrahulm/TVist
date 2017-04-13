//
//  GenericEscapeListViewController.swift
//  Escape
//
//  Created by Rahul Meena on 30/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class UserEscapeListViewController: GenericListViewController {
    
    var escapeType: EscapeType!
    var escapeAction: String!
    var userId: String?
    
    var nextPage = 1
    
    var fetchingData = false
    var fullDataLoaded = false
    
    var listItems:[EscapeItem] = []
    
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        if let escapeTypeStr = queryParams["escapeType"] as? String, let escapeType = EscapeType(rawValue: escapeTypeStr)  {
            self.escapeType = escapeType
        }
        
        if let escapeAction = queryParams["escapeAction"] as? String {
            self.escapeAction = escapeAction
            self.title = escapeAction
        }
        
        if let prefillItems = queryParams["prefillItems"] as? [EscapeItem], prefillItems.count > 0 {
            nextPage = 2
            if prefillItems.count >= DataConstants.kDefaultFetchSize {
                fullDataLoaded = true
            }
            listItems = prefillItems
        }
        
        if let userId = queryParams["userId"] as? String {
            self.userId = userId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.startAnimating()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ScreenVader.sharedVader.hideTabBar(true)
        
        if listItems.count == 0 {
            loadNexPage()
        }else{
            loadingView.stopAnimating()
        }
    }
    
    
    func loadNexPage() {
        if !fetchingData && !fullDataLoaded {
            fetchingData = true
            
            MyAccountDataProvider.sharedDataProvider.escapeListDataDelegate = self
            
            MyAccountDataProvider.sharedDataProvider.getUserEscapes(escapeType, escapeAction: escapeAction, userId: userId, page: nextPage)
        }
    }
    
    override func listCount() -> Int {
        return listItems.count
    }
    
    override func listItemAtIndexPath(_ indexPath: IndexPath) -> NormalCell {
        let escapeCell = tableView.dequeueReusableCell(withIdentifier: GenericCellIdentifier.EscapeCell.rawValue, for: indexPath) as! EscapeCell
        escapeCell.escapeItem = listItems[indexPath.row]
        return escapeCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    
}

extension UserEscapeListViewController: EscapeListDataProtocol {
    func receivedEscapeListData(_ escapeData: [EscapeItem], page: Int?, escapeType: String?, escapeAction: String?, userId: String?) {
        
        loadingView.stopAnimating()
        
        if self.userId == userId {
            
            if let escapeType = escapeType, let escapeAction = escapeAction, escapeType == self.escapeType.rawValue && escapeAction == self.escapeAction {
                
                if let page = page, page == nextPage {
                    
                    nextPage += 1
                    if escapeData.count < DataConstants.kDefaultFetchSize {
                        fullDataLoaded = true
                    }
                    
                    listItems.append(contentsOf: escapeData)
                    tableView.reloadData()
                    
                    fetchingData = false
                }
            }
        }
    }
    
    func failedToReceiveData() {
        // Failure case
    }
}

extension UserEscapeListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > ((scrollView.frame.height - scrollView.contentSize.height)*0.80) {
            loadNexPage()
        }
    }
}
