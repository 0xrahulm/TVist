//
//  ChannelWiseListCell.swift
//  TVist
//
//  Created by Rahul Meena on 27/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit


enum ChannelWiseCellIdentifier: String {
    case channelViewCell = "ChannelViewCell"
}

enum HeightForChannelSectionCell: CGFloat {
    case channelCellHeight = 90
    case channelCellWidth = 140
}


class ChannelWiseListCell: HomeSectionBaseCell {

    var collectionView: UICollectionView!
    
    var channelItems:[TvChannel] = []
    
    var registerableCells: [ChannelWiseCellIdentifier] = [.channelViewCell]
    
    class func totalHeight(count: Int) -> CGFloat {
        if count > 0 {
            return HeightForChannelSectionCell.channelCellHeight.rawValue
        }
        return 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
    }
    
    func initXibs() {
        for genericCell in registerableCells {
            collectionView.register(UINib(nibName: genericCell.rawValue, bundle: nil), forCellWithReuseIdentifier: genericCell.rawValue)
        }
    }
    
    
    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        
        set {
            collectionView.contentOffset.x = newValue
        }
    }
    
    func setDataAndInitialiseView(data: [TvChannel]) {
        if collectionView == nil {
            self.layoutIfNeeded()
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: HeightForChannelSectionCell.channelCellWidth.rawValue, height: HeightForChannelSectionCell.channelCellHeight.rawValue)
            flowLayout.scrollDirection = .horizontal
            
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            collectionView = UICollectionView(frame: self.containerView.bounds, collectionViewLayout: flowLayout)
            
            collectionView.dataSource = self
            collectionView.delegate = self
            
            collectionView.backgroundColor = UIColor.white
            collectionView.showsHorizontalScrollIndicator = false
            
            self.containerView.addSubview(collectionView)
            
            collectionView.translatesAutoresizingMaskIntoConstraints = true
            collectionView.center = CGPoint(x: self.containerView.bounds.midX, y: self.containerView.bounds.midY)
            collectionView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            
            initXibs()
        }
        
        channelItems = data
        
        collectionView.reloadData()
    }
    
}


extension ChannelWiseListCell: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        if let channelViewCell = collectionView.cellForItem(at: indexPath) as? ChannelViewCell {
            channelViewCell.popTheImage()
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        var params : [String:Any] = [:]
        let channel = channelItems[indexPath.row]
        
        params["channel"] = channel
        params["isToday"] = (self.homeViewType == .today)
        ScreenVader.sharedVader.performUniversalScreenManagerAction(.openChannelListingView, queryParams: params)
        
        if let channelName = channel.name {
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.ChannelItemTap, properties: ["Position":"\(indexPath.row+1)", "channelName": channelName, "ViewType":self.homeViewType.rawValue])
        }
//
//        let escapeItem = escapesDataList[indexPath.row]
//        params["escapeItem"] = escapeItem
//
//        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.DiscoverItemClick, properties: ["Position":"\(indexPath.row+1)", "escapeName": escapeItem.name, "ViewType":self.homeViewType.rawValue])
//
//        ScreenVader.sharedVader.performUniversalScreenManagerAction(.openMediaItemDescriptionView, queryParams: params)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return channelItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelWiseCellIdentifier.channelViewCell.rawValue, for: indexPath) as! ChannelViewCell
        
        let item = channelItems[indexPath.row]
        cell.tvChannel = item
        
        return cell
    }
}
