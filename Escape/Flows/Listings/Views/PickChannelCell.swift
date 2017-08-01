//
//  PickChannelCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 28/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit


let kListingMediaDetailsCell = "ListingMediaDetailsCell"

class PickChannelCell: UITableViewCell {

    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var pickerView: CategoryPickerView!
    @IBOutlet weak var channelView: ChannelPickerView!
    
    @IBOutlet weak var channelViewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var listingsActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var listingsTableView: UITableView!
    
    let listingData:ListingsDataProvider = ListingsDataProvider.shared
    
    var selectedChannel: TvChannel?
    
    var listingsData: [TvChannel:[ListingMediaItem]] = [:]
    
    
    var updatedOnce: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        if !updatedOnce {
            
            listingsTableView.register(UINib(nibName: kListingMediaDetailsCell, bundle: nil), forCellReuseIdentifier: kListingMediaDetailsCell)
            
            NotificationCenter.default.addObserver(self, selector: #selector(PickChannelCell.receivedChannelData(_:)), name: NSNotification.Name(rawValue: NotificationObservers.ListingsChannelDataObserver.rawValue), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(PickChannelCell.receivedListingsData(_:)), name: NSNotification.Name(rawValue: NotificationObservers.ListingMediaItemsObserver.rawValue), object: nil)
            
            pickerView.categoryPickerDelegate = self
            pickerView.setCategoryItems(categoryItems: listingData.listingCategories, defaultSelected: listingData.categorySelectedIndex)
            
            channelView.channelPickerDelegate = self
            
            updatedOnce = true
        }
    }
    
    func channelById(id: String) -> TvChannel? {
        if let channels = listingData.channelsForSelectedCategory() {
            
            for channel in channels {
                
                if let channelID = channel.id, channelID == id {
                    return channel
                }
            }
        }
        
        return nil
    }
    
    func receivedListingsData(_ notification:Notification) {
        listingsActivityIndicator.stopAnimating()
        
        
        if let userInfo = notification.userInfo {
            if let listData = userInfo["data"] as? [ListingMediaItem], let channelId = userInfo["channel_id"] as? String {
                
                if let channelItem = channelById(id: channelId) {
                    listingsData[channelItem] = listData
                }
                
                if let selectedChannel = self.selectedChannel {
                    
                    if channelId == selectedChannel.id {
                        self.listingsTableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    func receivedChannelData(_ notification:Notification) {
        channelViewActivityIndicator.stopAnimating()
        channelsForCategory(index: listingData.categorySelectedIndex)
    }
    
    
    func channelsForCategory(index: Int) {
        
        if let channels = listingData.channelsForCategoryIndex(index: index) {
            channelView.setChannelItems(channelItems: channels, defaultSelected: 0)
        } else {
            channelViewActivityIndicator.startAnimating()
            listingData.fetchCategoryChannels(categoryIndex: index)
        }
    }

    
    func getDataForChannel(channel: TvChannel) -> [ListingMediaItem]? {
        return listingsData[channel]
    }
    
    func selectedChannelData() -> [ListingMediaItem] {
        if let selectedChannel = self.selectedChannel {
            
            if let channelData = getDataForChannel(channel: selectedChannel) {
                return channelData
            } else {
                listingsActivityIndicator.startAnimating()
                listingData.fetchListingsForChannel(channel: selectedChannel)
            }
        }
        
        return []
    }
    
    @IBAction func allChannelsTapped(sender: UIButton) {
        if let listingDate = listingData.listingDates.first {
            ScreenVader.sharedVader.performScreenManagerAction(.OpenFullListingsView, queryParams: ["selectedListingDate": listingDate])
        }
    }
    
}

extension PickChannelCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension PickChannelCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return selectedChannelData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let listingMediaItem = selectedChannelData()[indexPath.row]
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: kListingMediaDetailsCell, for: indexPath) as? ListingMediaDetailsCell {
            cell.setupCellForListingMediaItem(listingMediaItem: listingMediaItem)
            return cell
        }
        
        
        return UITableViewCell()
    }
}

extension PickChannelCell: CategoryPickerProtocol {
    func didTapOnItemAtIndex(_ index: Int) {
        listingData.categorySelectedIndex = index
        channelsForCategory(index: index)
    }
}

extension PickChannelCell: ChannelPickerProtocol {
    func didTapOnChannel(_ channel: TvChannel) {
        selectedChannel = channel
        self.listingsTableView.reloadData()
    }
}
