//
//  GenericMasterViewController.swift
//  TVist
//
//  Created by Rahul Meena on 10/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class GenericDetailViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var masterHeaderView: MasterHeaderView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var styleGuideSegmentControl: StyleGuideSegmentControl?
    var theSearchBar: UISearchBar?
    
    var listOfItemType:[FilterType] = [.All, .Television, .Movie]
    var titleForItem: [FilterType: String] = [.All:"All", .Television: "TV Shows", .Movie: "Movies"]
    
    var displayModeButtonItem: UIBarButtonItem?
    
    var isSegmentedBarPresent: Bool = false
    
    // Pagination & Data Refresh
    
    var listItems: [AnyObject] = []
    
    var nextPage = 1
    
    var fetchingData = false
    var fullDataLoaded = false
    var resetFlag:Bool = false
    var loadedOnce:Bool = false
    
    var isTopVC: Bool = true
    var isCollapsed: Bool = false
    var isRegular: Bool = false
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let topVC = queryParams["isTopVC"] as? Bool {
            self.isTopVC = topVC
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func shouldSetupMasterHeaderView() -> Bool {
        return true
    }
    
    // To be overriden in base VC's
    func supportedCells() -> [GenericDetailCellIdentifiers] {
        return []
    }
    
    func initXibs() {
        for genericCell in supportedCells() {
            tableView.register(UINib(nibName: genericCell.rawValue, bundle: nil), forCellReuseIdentifier: genericCell.rawValue)
        }
    }
    
    func setupMasterHeaderView() {
        
        self.masterHeaderView.alpha = 1
        
        self.masterHeaderView.delegate = self
        
        self.tableView.contentInset = UIEdgeInsets(top: ViewConstants.headerHeightFull, left: 0, bottom: 80, right: 0)
        
        if self.isRegular && !self.isCollapsed {
            enableResizerButton()
        } else {
            enableProfileBackButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if listItems.count == 0 {
            loadNexPage()
        } else {
            loadingView.stopAnimating()
        }
        
        if !loadedOnce {
            
            if shouldSetupMasterHeaderView() {
                
                setupMasterHeaderView()
                if let title = self.title {
                    self.masterHeaderView.setMasterHeaderViewWithTitle(title: title)
                }
            }
            
            loadedOnce = true
            initXibs()
        }
    }
    
    
    func setupSearchBar(){
        if let searchBar = self.theSearchBar {
            if #available(iOS 11.0, *) {
                
            } else {
                
                searchBar.barTintColor = UIColor.black
                
                searchBar.tintColor    = UIColor.black
                
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
            
            searchBar.searchBarStyle = .minimal
            searchBar.placeholder  = "Search Movies & TV Shows"
            searchBar.showsCancelButton = true
        }
    }
    
    func addSegmentedFilterHeader(withSearchBar: Bool) {
        
        isSegmentedBarPresent = true
        if shouldSetupMasterHeaderView() {
            self.masterHeaderView.bottomLine.alpha = 0
        }
        
        var totalHeight = ViewConstants.segmentedHeaderHeightView
        var yOffsetForSegmentedView:CGFloat = 0
        if withSearchBar {
            self.theSearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 45))
            setupSearchBar()
            totalHeight += 45
            yOffsetForSegmentedView += 45
        }
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: totalHeight))
        headerView.translatesAutoresizingMaskIntoConstraints = true
        headerView.center = CGPoint(x: self.tableView.bounds.midX, y: ViewConstants.segmentedHeaderHeightView/2)
        headerView.autoresizingMask = [.flexibleWidth]
        
        
        headerView.backgroundColor = UIColor.styleGuideBackgroundColor2()
        
        if withSearchBar {
            if let searchBar = self.theSearchBar {
                searchBar.translatesAutoresizingMaskIntoConstraints = true
                searchBar.autoresizingMask = [.flexibleWidth]
                searchBar.center = headerView.center
                headerView.addSubview(searchBar)
            }
        }
        
        styleGuideSegmentControl = StyleGuideSegmentControl(frame: CGRect(x: ViewConstants.styleGuideDefaultMargin, y: yOffsetForSegmentedView, width: headerView.bounds.width-(2*ViewConstants.styleGuideDefaultMargin), height: ViewConstants.segmentedControlHeight))
        
        if let styleGuideSegmentControl = styleGuideSegmentControl {
            styleGuideSegmentControl.translatesAutoresizingMaskIntoConstraints = true
            styleGuideSegmentControl.delegate = self
            styleGuideSegmentControl.center = CGPoint(x: headerView.center.x, y: headerView.center.y+yOffsetForSegmentedView)
            styleGuideSegmentControl.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            styleGuideSegmentControl.selectedIndex = 0
            
            for listType in listOfItemType {
                if let titleForType = titleForItem[listType] {
                    
                    styleGuideSegmentControl.segments.append(TextSegment(text: titleForType))
                }
            }
            
            headerView.addSubview(styleGuideSegmentControl)
        }
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: headerView.bounds.height-0.5, width: headerView.bounds.width, height: 0.5))
        bottomLine.center = CGPoint(x: headerView.bounds.midX, y: headerView.bounds.height-0.5)
        bottomLine.translatesAutoresizingMaskIntoConstraints = true
        bottomLine.autoresizingMask = [.flexibleWidth]
        bottomLine.backgroundColor = UIColor.styleGuideLineGray()
        
        headerView.addSubview(bottomLine)
            
        self.tableView.tableHeaderView = headerView
    }
    
    func selectedFilterType(filterType: FilterType) {
        // override in base view
    }
    
    func fetchRequest() {
        // Override in Base View
    }
    
    
    func setupSearchFloatButton() {
        let searchFloatButton = UIButton(frame: CGRect(x: self.view.bounds.maxX-ViewConstants.floatingButtonHeight-22, y: self.view.bounds.maxY-ViewConstants.floatingButtonHeight-22, width: ViewConstants.floatingButtonHeight, height: ViewConstants.floatingButtonHeight))
        searchFloatButton.backgroundColor = UIColor.styleGuideActionButtonBlue()
        searchFloatButton.setImage(IonIcons.image(withIcon: ion_ios_search_strong, size: 30, color: UIColor.white), for: .normal)
        searchFloatButton.layer.cornerRadius = ViewConstants.floatingButtonHeight/2
        searchFloatButton.layer.masksToBounds = true
        searchFloatButton.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin]
        searchFloatButton.translatesAutoresizingMaskIntoConstraints = true
        searchFloatButton.alpha = 1
        searchFloatButton.addTarget(self, action: #selector(GenericDetailViewController.searchButtonDidTap), for: .touchUpInside)
        self.view.addSubview(searchFloatButton)
    }
    
    func loadNexPage() {
        if !fetchingData && !fullDataLoaded {
            fetchingData = true
            fetchRequest()
        }
    }
    
    @objc func searchButtonDidTap() {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SearchFloatButtonTap)
        ScreenVader.sharedVader.performUniversalScreenManagerAction(.openSearchView, queryParams: ["screen": "home", "isTopVC": false])
        
    }
    
    
    @objc func reset() {
        nextPage = 1
        fetchingData = false
        fullDataLoaded = false
        resetFlag = true
        
        self.loadingView.startAnimating()
        fetchRequest()
    }
    
    func pageFetchSize() -> Int {
        return DataConstants.kDefaultFetchSize
    }
    
    func appendDataToBeListed(appendableData: [AnyObject], page: Int?, animated: Bool = false, animationStyle: UITableViewRowAnimation = .left) {
        
        loadingView.stopAnimating()
        
        if let page = page, page == nextPage {
            
            nextPage += 1
            if appendableData.count < pageFetchSize() {
                fullDataLoaded = true
            }
            
            if resetFlag {
                resetFlag = false
                listItems = []
            }
            
            listItems.append(contentsOf: appendableData)
            if animated {
                tableView.reloadSections(IndexSet(integer: 0), with:animationStyle)
            } else {
                tableView.reloadData()
                
            }
            
            fetchingData = false
        }
        
    }
    
    func enableProfileBackButton() {
        if self.masterHeaderView != nil {
            self.masterHeaderView.setBackButton(withUserProfile: self.isTopVC)
        }
    }
    
    func enableResizerButton() {

        if let displayModeButtonItem = displayModeButtonItem, self.masterHeaderView != nil {
            self.masterHeaderView.setResizerButton(displayModeButton: displayModeButtonItem)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var contentY = scrollView.contentOffset.y
        contentY = ViewConstants.headerHeightFull+contentY
        determineHeaderViewStateFor(offset: contentY)
        
        if contentY > ((scrollView.contentSize.height - scrollView.frame.size.height)*0.30) {
            loadNexPage()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            
        }
    }
    
    func determineHeaderViewStateFor(offset: CGFloat) {
        if shouldSetupMasterHeaderView() {
            
            if offset > 0 && !self.masterHeaderView.isCollapsed {
                
                self.headerViewHeightConstraint.constant = ViewConstants.headerHeightCollapsed
                self.masterHeaderView.isCollapsed = true
                
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.masterHeaderView.headerTitleLabel.alpha = 1
                    if self.isSegmentedBarPresent {
                        self.masterHeaderView.bottomLine.alpha = 1
                    }
                    self.masterHeaderView.layoutIfNeeded()
                }, completion: nil)
            }
            
            if offset < 0 && self.masterHeaderView.isCollapsed {
                
                self.headerViewHeightConstraint.constant = ViewConstants.headerHeightFull
                self.masterHeaderView.isCollapsed = false
                
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.masterHeaderView.headerTitleLabel.alpha = 0
                    self.masterHeaderView.layoutIfNeeded()
                    if self.isSegmentedBarPresent {
                        self.masterHeaderView.bottomLine.alpha = 0
                    }
                }, completion: nil)
            }
            
        }
    }
}

extension GenericDetailViewController: WBSegmentControlDelegate {
    func segmentControl(_ segmentControl: WBSegmentControl, selectIndex newIndex: Int, oldIndex: Int) {
        let filter = listOfItemType[newIndex]
        selectedFilterType(filterType: filter)
    }
}

extension GenericDetailViewController: MasterHeaderViewProtocol {
    func didTapLeftNavButton() {
        LocalStorageVader.sharedVader.setFlagForKey(.TappedOnRedDot)
        if self.isTopVC {
            AnalyticsVader.sharedVader.basicEvents(eventName: .UserViewNavigationButtonClick)
            ScreenVader.sharedVader.performUniversalScreenManagerAction(.openUserView, queryParams: nil)
        } else {
            ScreenVader.sharedVader.backButtonPressOnDetailView()
        }
    }
}
