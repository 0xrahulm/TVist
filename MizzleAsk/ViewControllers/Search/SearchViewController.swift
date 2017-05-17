//
//  SearchViewController.swift
//  Escape
//
//  Created by Ankit on 16/09/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var containerView: UIView!
    
    var pageMenu : CAPSPageMenu?
    var delegate: SearchViewControllerDelegate?
    
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
    
    func setMoveToIndexWithType(type: String?) {
        if let type = type, let searchType = SearchType(rawValue: type) {
            
            if searchType == .Movie {
                self.moveToIndex = 1
            } else if searchType == .TvShows {
                self.moveToIndex = 2
            } else if searchType == .Books {
                self.moveToIndex = 3
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ECUserDefaults.removeSearchedText()
        setupSearchBar()
        configureVCs()
        pageMenu?.moveToPage(moveToIndex)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        ECUserDefaults.removeSearchedText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addFirstResponder()
    }
    
    
    func setupSearchBar(){
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
        
        
    }
    
    func addFirstResponder(){
        //addDoneButton()
        self.searchBar.becomeFirstResponder()
        
    }

    func cancelTapped() {
        if let delegate = delegate {
            dismissKeyBoard()
            delegate.didTapOnCancelButton()
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
        searchBar.resignFirstResponder()
    }
    
    func configureVCs(){
        
        addVcFor(.All, title: "ALL")
        addVcFor(.Movie, title: "MOVIES")
        addVcFor(.TvShows, title: "TV SHOWS")
        addVcFor(.Books, title: "BOOKS")
        
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
        
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.containerView.frame.width, height: self.containerView.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.containerView.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: self)
        
    }
    
    func addVcFor(_ type : SearchType , title : String){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "searchAllVC") as? SearchAllViewController
        controller!.title = title
        controller!.type = type
        controller!.parentVC = self
        controllerArray.append(controller!)
        
    }
    
    override var shouldAutomaticallyForwardAppearanceMethods : Bool {
        return true
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    

    func dismissKeyBoard(){
        self.searchBar.resignFirstResponder()
    }
    
    func selectedSearchItem(searchItem: SearchItems, loadedImage: UIImage?) {
        if let delegate = self.delegate {
            dismissKeyBoard()
            
            delegate.didTapOnSearchItem(searchItem: searchItem, loadedImage: loadedImage)
        }
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
        dismissKeyBoard()
    }
    
}

// MARK: - Protocol

protocol SearchViewControllerDelegate {
    func didTapOnCancelButton()
    func didTapOnSearch()
    func didTapOnSearchItem(searchItem: SearchItems, loadedImage: UIImage?)
}
