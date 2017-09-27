//
//  AiringNowViewController.swift
//  TVist
//
//  Created by Rahul Meena on 20/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class AiringNowViewController: GenericDetailViewController {
    
    var categoryId: String?
    var searchedChannelNumber: String?
    var listingCategories: [ListingCategory] = []
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var nowButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    
    var shouldAnimate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.white
        
        self.title = "Whats On"
        
        self.masterHeaderView.setupRightNavWithImage(image: "Filter_Button", action: #selector(AiringNowViewController.didTapFilterButton(_:)), target: self)
        // Do any additional setup after loading the view.
        TvRemoteDataProvider.shared.remoteDataDelegate = self
        TvRemoteDataProvider.shared.getCategories()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func supportedCells() -> [GenericDetailCellIdentifiers] {
        return [.channelPlayWithAiringNowCell]
    }
    
    override func fetchRequest() {
        TvRemoteDataProvider.shared.getAiringNow(page: nextPage, categoryId: categoryId, channelNumber: searchedChannelNumber, isLater: self.laterButton.isSelected)
    }
    
    @IBAction func didTapOnFilterBarButtonItem(_ sender: UIBarButtonItem) {
        
        didTapFilterButton(sender)
    }
    
    @objc func didTapFilterButton(_ sender: Any) {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.WhatsOnChannelFilterTap)
        if UserDataProvider.sharedDataProvider.premiumOnlyFeature(feature: .channelFilters) {
            if listingCategories.count > 0 {
                
                
                let alertController = UIAlertController(title: "Filter Chanels", message: nil, preferredStyle: .actionSheet)
                
                let allChannelsAction = UIAlertAction(title: "All Channels", style: .default, handler: { (action) in
                    self.categoryId = nil
                    self.reset()
                })
                
                alertController.addAction(allChannelsAction)
                
                for listingCategory in listingCategories {
                    if let titleForCategory = listingCategory.name {
                        
                        let categoryAction = UIAlertAction(title: titleForCategory, style: .default, handler: { (action) in
                            self.filterSelected(listCategory: listingCategory)
                        })
                        
                        alertController.addAction(categoryAction)
                    }
                }
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alertController.popoverPresentationController?.sourceRect = self.masterHeaderView.rightView.bounds
                alertController.popoverPresentationController?.sourceView = self.masterHeaderView.rightView
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func filterSelected(listCategory: ListingCategory) {
        self.categoryId = listCategory.id
        self.reset()
    }
    
    @IBAction func nowButtonTapped(_ sender: Any) {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.WhatsOnNowButtonTap)
        
        if !self.nowButton.isSelected {
            self.laterButton.isSelected = false
            self.nowButton.isSelected = true
            self.shouldAnimate = true
            reset()
        }
        
    }
    
    
    @IBAction func laterButtonTapped(_ sender: Any) {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.WhatsOnLaterButtonTap)
        if UserDataProvider.sharedDataProvider.premiumOnlyFeature(feature: .advancedListing) {
            
            if !self.laterButton.isSelected {
                self.laterButton.isSelected = true
                self.nowButton.isSelected = false
                self.shouldAnimate = true
                reset()
            }
        }
    }
}

extension AiringNowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listingItem = self.listItems[indexPath.row] as! ListingMediaItem
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RemoteCellIdentifiers.ChannelPlayWithAiringNowCell.rawValue, for: indexPath) as! ChannelPlayWithAiringNowCell
        
        cell.mediaItem = listingItem
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let listingItem = self.listItems[indexPath.row] as! ListingMediaItem
        
        
        if let data = EscapeItem.createWithMediaItem(mediaItem: listingItem.mediaItem) {
            var params : [String:Any] = [:]
            params["escapeItem"] = data
            
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.WhatsOnItemTap, properties: ["escapeName": data.name, "escapeType": data.escapeType, "Position":"\(indexPath.row)"])
            
            ScreenVader.sharedVader.performUniversalScreenManagerAction(.openMediaItemDescriptionView, queryParams: params)
        }
    }
}

extension AiringNowViewController: RemoteDataProtocol {
    func didReceiveRemoteData(data: [ListingMediaItem], page: Int?) {
        var animationStyle:UITableViewRowAnimation = .none
        if shouldAnimate {
            if self.laterButton.isSelected {
                animationStyle = .left
            } else {
                animationStyle = .right
            }
            shouldAnimate = false
        }
        appendDataToBeListed(appendableData: data, page: page, animated: shouldAnimate, animationStyle: animationStyle)
        
        if data.count > 0 && page == 1 {
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.WhatsOnDataLoaded)
        }
        
    }
    func errorRecievingRemoteData() {
        
    }
    
    func didReceiveCategories(data: [ListingCategory]) {
        self.listingCategories = data
        
    }
    
    func errorRecievingCategories() {
        
    }
}
