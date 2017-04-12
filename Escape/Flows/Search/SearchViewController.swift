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
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
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
        
        if screen == "discover"{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelTapped))
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ScreenVader.sharedVader.hideTabBar(false)
    }
    deinit {
        ECUserDefaults.removeSearchedText()
    }
    
    
    func setupSearchBar(){
        var width = self.view.frame.size.width-30
        if screen == "discover"{
            width = self.view.frame.size.width-100
        }
        searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 40.0))
        searchBar.delegate = self
        
        searchBar.barTintColor = UIColor.themeColorBlack()
        searchBar.placeholder  = "Search"
        searchBar.tintColor    = UIColor.themeColorBlack()
        searchBar.backgroundImage = UIImage.getImageWithColor(UIColor.clear, size: CGSize(width: 1, height: 1))
        searchBar.backgroundColor = UIColor.escapeGray()
        if screen != "discover" {
            
            searchBar.showsCancelButton = true
        }
        searchBar.searchBarStyle = .minimal
        if let searchIconImage = IonIcons.image(withIcon: ion_ios_search_strong, iconColor: UIColor.themeColorBlack(), iconSize: 28, imageSize: CGSize(width: 24, height: 24)) {
            
            searchBar.setImage(searchIconImage, for: UISearchBarIcon.search, state: UIControlState())
            searchBar.setImage(searchIconImage, for: UISearchBarIcon.search, state: .highlighted)
        }
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = UIColor.themeColorBlack()
            let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.value(forKey: "placeholderLabel") as? UILabel
            textFieldInsideSearchBarLabel?.textColor = UIColor.themeColorBlack()
        }
        
        let leftnavButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftnavButton
        
        
        addFirstResponder()
        
    }
    
    func addFirstResponder(){
        //addDoneButton()
        self.searchBar.becomeFirstResponder()
        
    }

    func cancelTapped() {
        if let navController = self.navigationController{
            navController.dismiss(animated: true, completion: nil)
        }
    }
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                            target: self, action: #selector(SearchViewController.doneTapped))
        
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
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
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.escapeBlueColor()),
            .bottomMenuHairlineColor(UIColor.textGrayColor()),
            .menuItemFont(UIFont(name: "SFUIDisplay-Regular", size: 13.0)!),
            .menuHeight(45.0),
            .menuMargin(0.0),
            .menuItemWidth(100.0),
            .centerMenuItems(true),
            .selectedMenuItemLabelColor(UIColor.themeColorBlack()),
            .unselectedMenuItemLabelColor(UIColor.textGrayColor()),
            .selectionIndicatorHeight(1.5)
        ]
        
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: self)
        
    }
    
    func addVcFor(_ type : SearchType , title : String){
        let controller = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "searchAllVC") as? SearchAllViewController
        controller!.title = title
        controller!.type = type
        controller!.dismissKeyboardDelegate = self
        controllerArray.append(controller!)
        
    }
    
    override var shouldAutomaticallyForwardAppearanceMethods : Bool {
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if screen != "discover" {
            self.searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchedText = searchText
        
        ECUserDefaults.setSearchedText(searchText)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.SearchQueryObserver.rawValue), object: ["searchText" : searchText])
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
}
