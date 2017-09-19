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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMasterHeaderView()
        
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
        
        
        self.tableView.contentInset = UIEdgeInsets(top: ViewConstants.headerHeightFull, left: 0, bottom: 40, right: 0)
        
        if self.view.traitCollection.horizontalSizeClass == .regular {
            enableResizerButton()
        } else {
            enableProfileBackButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let title = self.title {
            self.masterHeaderView.setMasterHeaderViewWithTitle(title: title)
        }
        
        
        if listItems.count == 0 {
            loadNexPage()
        } else {
            loadingView.stopAnimating()
        }
        
        if !loadedOnce {
            loadedOnce = true
            initXibs()
        }
    }
    
    
    func addSegmentedFilterHeader() {
        
        isSegmentedBarPresent = true
        
        self.masterHeaderView.bottomLine.alpha = 0
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: ViewConstants.segmentedHeaderHeightView))
        headerView.translatesAutoresizingMaskIntoConstraints = true
        headerView.center = CGPoint(x: self.tableView.bounds.midX, y: ViewConstants.segmentedHeaderHeightView/2)
        headerView.autoresizingMask = [.flexibleWidth]
        
        headerView.backgroundColor = UIColor.styleGuideBackgroundColor2()
        
        styleGuideSegmentControl = StyleGuideSegmentControl(frame: CGRect(x: ViewConstants.styleGuideDefaultMargin, y: 0, width: headerView.bounds.width-(2*ViewConstants.styleGuideDefaultMargin), height: ViewConstants.segmentedControlHeight))
        
        if let styleGuideSegmentControl = styleGuideSegmentControl {
            styleGuideSegmentControl.translatesAutoresizingMaskIntoConstraints = true
            
            styleGuideSegmentControl.center = headerView.center
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
    
    
    
    func fetchRequest() {
        // Override in Base View
    }
    
    
    func loadNexPage() {
        if !fetchingData && !fullDataLoaded {
            fetchingData = true
            fetchRequest()
        }
    }
    
    
    
    func reset() {
        nextPage = 1
        fetchingData = false
        fullDataLoaded = false
        resetFlag = true
        
        self.loadingView.startAnimating()
        fetchRequest()
    }
    
    func appendDataToBeListed(appendableData: [AnyObject], page: Int?) {
        
        loadingView.stopAnimating()
        
        if let page = page, page == nextPage {
            
            nextPage += 1
            if appendableData.count < DataConstants.kDefaultFetchSize {
                fullDataLoaded = true
            }
            
            if resetFlag {
                resetFlag = false
                listItems = []
            }
            
            listItems.append(contentsOf: appendableData)
            tableView.reloadData()
            
            fetchingData = false
        }
        
    }
    
    func enableProfileBackButton() {
        if self.masterHeaderView != nil {
            self.masterHeaderView.setUserProfileBackButton()
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
        var contentY = scrollView.contentOffset.y
        contentY = ViewConstants.headerHeightFull+contentY
        determineHeaderViewStateFor(offset: contentY)
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            
            var contentY = scrollView.contentOffset.y
            contentY = ViewConstants.headerHeightFull+contentY
            determineHeaderViewStateFor(offset: contentY)
        }
    }
    
    func determineHeaderViewStateFor(offset: CGFloat) {
        let offsetDelta = ViewConstants.headerHeightFull-ViewConstants.headerHeightCollapsed
        
        var largeLabelFontSize = ViewConstants.largeTitleDefaultFontSize
        
        if offset <= offsetDelta {
            var alpha = (offset/offsetDelta)
            if alpha < 0 {
                alpha = 0
            }
            self.masterHeaderView.headerTitleLabel.alpha = alpha
            
            if self.isSegmentedBarPresent {
                self.masterHeaderView.bottomLine.alpha = alpha
            }
            
            self.headerViewHeightConstraint.constant = ViewConstants.headerHeightFull-offset
            
            if offset < 0 {
                let largeLabelScaleFactor:CGFloat = 1 + (-(offset) / ViewConstants.headerHeightFull)
                
                largeLabelFontSize = largeLabelScaleFactor*largeLabelFontSize
            }
            if let titleText = self.masterHeaderView.largeTitleLabel.text {
                self.masterHeaderView.largeTitleLabel.attributedText = SFUIAttributedText.boldAttributedTextForString(titleText, size: largeLabelFontSize, color: UIColor.styleGuideMainTextColor())
            }
            self.masterHeaderView.layoutIfNeeded()
        }
    }
}

extension GenericDetailViewController: MasterHeaderViewProtocol {
    func didTapLeftNavButton() {
        ScreenVader.sharedVader.performUniversalScreenManagerAction(.openUserView, queryParams: nil)
    }
}
