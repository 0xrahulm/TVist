//
//  SearchViewController.swift
//  Escape
//
//  Created by Ankit on 16/09/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {
    
    var searchBar:UISearchBar =     UISearchBar()
    var pageMenu : CAPSPageMenu?
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var segmentedTab: UISegmentedControl!
    
    var controllerArray : [UIViewController] = []
    
    var moveToIndex = 0
    var screen = ""
    var searchedText : String = ""
    var loadedOnce: Bool = false
    
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

    override func getName() -> String {
        return ScreenNames.Search.rawValue
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !loadedOnce {
            
            
            ECUserDefaults.removeSearchedText()
            setupSearchBar()
            configureVCs()
            pageMenu?.moveToPage(moveToIndex)
            
            if screen == "home"{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelTapped))
            }
            loadedOnce = true
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        ECUserDefaults.removeSearchedText()
    }
    
    
    func setupSearchBar(){
        var width = self.view.frame.size.width-30
        if screen == "home" {
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

    @objc func cancelTapped() {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SearchCancelled, properties: ["Position": "Guide"])
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
    @objc func doneTapped(){
        self.searchBar.resignFirstResponder()
        
    }
    
    func configureVCs(){
        
        addVcFor(.All, title: "ALL")
        addVcFor(.TvShows, title: "TV SHOWS")
        addVcFor(.Movie, title: "MOVIES")
        
        // Customize menu
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.mizzleBlueColor()),
            .bottomMenuHairlineColor(UIColor.textGrayColor()),
            .menuItemFont(UIFont(name: "SFUIDisplay-Regular", size: 13.0)!),
            .menuHeight(45.0),
            .menuMargin(0.0),
            .menuItemWidth(100.0),
            .centerMenuItems(true),
            .selectedMenuItemLabelColor(UIColor.themeColorBlack()),
            .unselectedMenuItemLabelColor(UIColor.textGrayColor()),
            .selectionIndicatorHeight(1.5),
            .hideTopMenuBar(true)
        ]
        
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.containerView.frame.width, height: self.containerView.frame.height), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        
        self.addChildViewController(pageMenu!)
        self.containerView.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: self)
        
    }
    
    func addVcFor(_ type : SearchType , title : String){
        let controller = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "searchChildVC") as? SearchChildViewController
        controller!.title = title
        controller!.type = type
        if screen == "discover" {
            controller!.searchPosition = "Guide"
        } else {
            controller!.searchPosition = "Search Tab"
        }
        controller!.dismissKeyboardDelegate = self
        controllerArray.append(controller!)
        
    }
    
    override var shouldAutomaticallyForwardAppearanceMethods : Bool {
        return true
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    
    func bringToTopWithIndex(index: Int) {
        self.pageMenu?.moveToPage(index)
    }

    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        bringToTopWithIndex(index: sender.selectedSegmentIndex)
    }
    
}


extension SearchViewController: CAPSPageMenuDelegate {
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        // Blank for now
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        self.segmentedTab.selectedSegmentIndex = index
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
        
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SearchCancelled, properties: ["Position": "Search Tab"])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchedText = searchText
        
        ECUserDefaults.setSearchedText(searchText)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.SearchQueryObserver.rawValue), object: ["searchText" : searchText])
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SearchClick, properties: ["Position": "Search Tab"])
        self.searchBar.resignFirstResponder()
    }
    
}
