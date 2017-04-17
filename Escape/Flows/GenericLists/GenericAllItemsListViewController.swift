//
//  GenericAllItemsListViewController.swift
//  Escape
//
//  Created by Rahul Meena on 14/04/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class GenericAllItemsListViewController: GenericListViewController {
    
    var nextPage = 1
    
    var fetchingData = false
    var fullDataLoaded = false
    
    var listItems:[NSObject] = []
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let prefillItems = queryParams["prefillItems"] as? [NSObject], prefillItems.count > 0 {
            nextPage = 2
            if prefillItems.count < DataConstants.kDefaultFetchSize {
                fullDataLoaded = true
            }
            listItems = prefillItems
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
        } else {
            loadingView.stopAnimating()
        }
    }
    
    func loadNexPage() {
        if !fetchingData && !fullDataLoaded {
            fetchingData = true
            fetchRequest()
        }
    }
    
    func fetchRequest() {
        //Override in child class
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > ((scrollView.frame.height - scrollView.contentSize.height)*0.80) {
            loadNexPage()
        }
    }
    
    
    override func listCount() -> Int {
        return listItems.count
    }
    
    override func listItemAtIndexPath(_ indexPath: IndexPath) -> NormalCell {
        
        if let escapeItem = listItems[indexPath.row] as? EscapeItem {
            
            let escapeCell = tableView.dequeueReusableCell(withIdentifier: GenericCellIdentifier.EscapeCell.rawValue, for: indexPath) as! EscapeCell
            escapeCell.escapeItem = escapeItem
            return escapeCell
        }
        
        if let peopleItem = listItems[indexPath.row] as? MyAccountItems {
            let peopleCell = tableView.dequeueReusableCell(withIdentifier: GenericCellIdentifier.PeopleCell.rawValue, for: indexPath) as! PeopleCell
            peopleCell.accountItem = peopleItem
            return peopleCell
        }
        
        return NormalCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if let _ = listItems[indexPath.row] as? EscapeItem {
            return 130
        }
        
        if let _ = listItems[indexPath.row] as? MyAccountItems {
            return 70
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if listItems.count > indexPath.row {
            
            if let data = listItems[indexPath.row] as? EscapeItem {
                
                var params : [String:Any] = [:]
                
                params["id"] = data.id
                
                params["escape_type"] = data.escapeType
                params["name"] = data.name
                
                if let image = data.posterImage {
                    params["image"] = image
                }
                ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)
            }
            
            
            if let data = listItems[indexPath.row] as? MyAccountItems {
                if let id  = data.id {
                    ScreenVader.sharedVader.performScreenManagerAction(.OpenUserAccount, queryParams: ["user_id":id, "isFollow" : data.isFollow])
                }
            }
        }
    }

    func appendDataToBeListed(appendableData: [NSObject], page: Int?) {
        
        loadingView.stopAnimating()
        
        if let page = page, page == nextPage {
            
            nextPage += 1
            if appendableData.count < DataConstants.kDefaultFetchSize {
                fullDataLoaded = true
            }
            
            listItems.append(contentsOf: appendableData)
            tableView.reloadData()
            
            fetchingData = false
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
