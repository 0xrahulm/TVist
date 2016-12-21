//
//  SearchViewController.swift
//  Escape
//
//  Created by Ankit on 16/09/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import ionicons

class SearchViewController: UIViewController {
    
    var searchBar:UISearchBar =     UISearchBar()
    var pageMenu : CAPSPageMenu?
    
    var controllerArray : [UIViewController] = []
    var searchedText : String = ""
    var moveToIndex = 0
    var screen = ""
    
    static let sharedInstance = SearchViewController()
    
    override func setObjectsWithQueryParameters(queryParams: [String : AnyObject]) {
        print("query params present")
        if let moveToIndex = queryParams["moveToIndex"] as? Int{
            self.moveToIndex = moveToIndex
        }
        if let screen = queryParams["screen"] as? String{
            self.screen = screen
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ECUserDefaults.removeSearchedText()
        setupSearchBar()
        configureVCs()
        pageMenu?.moveToPage(moveToIndex)

    }
    deinit {
        ECUserDefaults.removeSearchedText()
    }
    
    
    func setupSearchBar(){
        
        searchBar = UISearchBar(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width-100, 40.0))
        searchBar.delegate = self
        
        searchBar.barTintColor = UIColor.themeColorBlack()
        searchBar.placeholder  = "Search"
        searchBar.tintColor    = UIColor.themeColorBlack()
        searchBar.backgroundImage = UIImage.getImageWithColor(UIColor.clearColor(), size: CGSizeMake(1, 1))
        searchBar.backgroundColor = UIColor.escapeGray()
        searchBar.searchBarStyle = .Minimal
        if let searchIconImage = IonIcons.imageWithIcon(ion_ios_search_strong, iconColor: UIColor.themeColorBlack(), iconSize: 28, imageSize: CGSize(width: 24, height: 24)) {
            
            searchBar.setImage(searchIconImage, forSearchBarIcon: UISearchBarIcon.Search, state: .Normal)
            searchBar.setImage(searchIconImage, forSearchBarIcon: UISearchBarIcon.Search, state: .Highlighted)
        }
        
        if let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = UIColor.themeColorBlack()
            let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.valueForKey("placeholderLabel") as? UILabel
            textFieldInsideSearchBarLabel?.textColor = UIColor.themeColorBlack()
        }
        
        let leftnavButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftnavButton
        
        searchBar.showsCancelButton = false
        addFirstResponder()
        
    }
    
    func addFirstResponder(){
        //addDoneButton()
        self.searchBar.becomeFirstResponder()
        
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        if let navController = self.navigationController{
            navController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
                                            target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .Cancel,
                                            target: self, action: #selector(SearchViewController.doneTapped))
        
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
                                            target: self, action: #selector(SearchViewController.doneTapped))
        keyboardToolbar.items = [cancelBarButton,flexBarButton, doneBarButton]
        self.searchBar.inputAccessoryView = keyboardToolbar
    }
    func doneTapped(){
        self.searchBar.resignFirstResponder()
    }
    
    func configureVCs(){
        
        addVcFor(.All, title: "ALL")
        addVcFor(.Movie, title: "MOVIES")
        addVcFor(.TvShows, title: "TV SHOWS")
        addVcFor(.Books, title: "BOOKS")
        addVcFor(.User, title: "PEOPLE")
        
        // Customize menu
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor.escapeBlueColor()),
            .BottomMenuHairlineColor(UIColor.textGrayColor()),
            .MenuItemFont(UIFont(name: "SFUIDisplay-Regular", size: 13.0)!),
            .MenuHeight(45.0),
            .MenuMargin(0.0),
            .MenuItemWidth(100.0),
            .CenterMenuItems(true),
            .SelectedMenuItemLabelColor(UIColor.themeColorBlack()),
            .UnselectedMenuItemLabelColor(UIColor.textGrayColor()),
            .SelectionIndicatorHeight(1.5)
        ]
        
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMoveToParentViewController(self)
        
    }
    
    func addVcFor(type : SearchType , title : String){
        let controller = UIStoryboard(name: "Search", bundle: nil).instantiateViewControllerWithIdentifier("searchAllVC") as? SearchAllViewController
        controller!.title = title
        controller!.type = type
        controller!.dismissKeyboardDelegate = self
        controllerArray.append(controller!)
        
    }
    
    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return true
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    


}
extension SearchViewController : DismissKeyboardProtocol{
    func dismissKeyBoard(){
        self.searchBar.resignFirstResponder()
    }
}
extension SearchViewController : UISearchBarDelegate{
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchedText = searchText
        
        ECUserDefaults.setSearchedText(searchText)
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationObservers.SearchQueryObserver.rawValue, object: ["searchText" : searchText])
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
}
