//
//  SearchViewController.swift
//  Escape
//
//  Created by Ankit on 16/09/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {
    
    var searchBar:UISearchBar =     UISearchBar()
    var pageMenu : CAPSPageMenu?
    
    var controllerArray : [UIViewController] = []
    var searchedText : String = ""
    
    static let sharedInstance = SearchViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ECUserDefaults.removeSearchedText()
        setupSearchBar()
        configureVCs()

    }
    deinit {
        ECUserDefaults.removeSearchedText()
    }
    
    
    func setupSearchBar(){
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        searchBar = UISearchBar(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width-90, 40.0))
        searchBar.delegate = self
        
        searchBar.barTintColor = UIColor.whiteColor()
        searchBar.placeholder  = "Search"
        searchBar.tintColor    = UIColor.searchPlaceHolderColor()
        searchBar.backgroundImage = UIImage.getImageWithColor(UIColor.clearColor(), size: CGSizeMake(1, 1))
        searchBar.backgroundColor = UIColor.escapeBlueColor()
        searchBar.searchBarStyle = .Minimal
        searchBar.setImage(UIImage(named: "search-white"), forSearchBarIcon: UISearchBarIcon.Search, state: .Normal)
        searchBar.setImage(UIImage(named: "search-white"), forSearchBarIcon: UISearchBarIcon.Search, state: .Highlighted)
        
        if let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = UIColor.whiteColor()
            let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.valueForKey("placeholderLabel") as? UILabel
            textFieldInsideSearchBarLabel?.textColor = UIColor.whiteColor()
        }
        
        let leftnavButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftnavButton
        
        searchBar.showsCancelButton = false
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(SearchViewController.addFirstResponder), userInfo: nil , repeats: false)
        
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
        
        addVcFor(.All, title: "All")
        addVcFor(.Movie, title: "Movies")
        addVcFor(.TvShows, title: "Tv Shows")
        addVcFor(.Books, title: "Books")
        addVcFor(.User, title: "People")
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor.escapeBlueColor()),
            .BottomMenuHairlineColor(UIColor.escapeBlueColor()),
            .MenuItemFont(UIFont(name: "SFUIDisplay-Regular", size: 14.0)!),
            .MenuHeight(45.0),
            .MenuItemWidth(80.0),
            .CenterMenuItems(true),
            .SelectedMenuItemLabelColor(UIColor.escapeBlueColor()),
            .UnselectedMenuItemLabelColor(UIColor.grayColor()),
            .SelectionIndicatorHeight(1.0),
            
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
