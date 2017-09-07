//
//  CustomListTableViewCell.swift
//  Escape
//
//  Created by Ankit on 08/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol ViewAllTapProtocol:class {
    func viewAllTappedIn(_ cell: UITableViewCell)
}


enum DiscoverSectionCollectionCellIdentifier: String {
    case MediaItemCollectionViewCell = "MediaItemCollectionViewCell"
}

enum HeightForDiscoverItems: CGFloat {
    case MediaListSectionHeight = 255
}

class CustomListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var cellTitleLabel: UILabel!
    var lastScrollValue:String = ""
    weak var viewAllTapDelegate: ViewAllTapProtocol?
    
    var registerableCells:[DiscoverSectionCollectionCellIdentifier] = [.MediaItemCollectionViewCell]
    var escapesDataList: [EscapeItem] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    class func totalHeight(itemsCount: Int) -> CGFloat {
        
        return HeightForDiscoverItems.MediaListSectionHeight.rawValue
    }
    
    func setDataAndInitialiseView(data: [EscapeItem]) {
        collectionView.delegate = self
        collectionView.dataSource = self
        escapesDataList = data
        initXibs()
        collectionView.reloadData()
    }
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.register(UINib(nibName: "MediaItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MediaItemCollectionViewCell")
        
    }
    
    @IBAction func viewAllTapped() {
        if let viewAllTapDelegate = viewAllTapDelegate {
            viewAllTapDelegate.viewAllTappedIn(self)
        }
    }
    

}
extension CustomListTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        if let escapeItemCell = collectionView.cellForItem(at: indexPath) as? CustomListCollectionViewCell {
            
            escapeItemCell.popTheImage()
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        var params : [String:AnyObject] = [:]
        
        let escapeItem = escapesDataList[indexPath.row]
        params["escapeItem"] = escapeItem
        
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.HomeDiscoverItemClick, properties: ["Position":"\(indexPath.row+1)", "escapeName": escapeItem.name])
        
        ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return escapesDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaItemCollectionViewCell", for: indexPath) as! CustomListCollectionViewCell
        
        let item = escapesDataList[indexPath.row]
        cell.dataItems = item
        
        cell.trackPosition = "Home_Discover"
        
        return cell
    }
    
    func scrollBucket(scrollValue: CGFloat) -> String {
        
        if scrollValue < 30.0 {
            return "0-30"
        }
        if scrollValue >= 30.0 && scrollValue < 60.0 {
            return "30-60"
        }
        if scrollValue >= 60.0 && scrollValue <= 90.0 {
            return "60-90"
        }
        
        if scrollValue > 120 {
            return "> 120"
        }
        
        if scrollValue > 90 {
            return "> 90"
        }
        
        return "Unknown"
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let percentageScroll:CGFloat = ((scrollView.contentOffset.x+scrollView.frame.size.width)/scrollView.contentSize.width)*100
        let scrollBucketStr = scrollBucket(scrollValue: percentageScroll)
        if self.lastScrollValue != scrollBucketStr {
            if let sectionTitle = self.cellTitleLabel.text {
                
                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.HomeSectionHorizontalScroll, properties: ["percentage":String(format:"%.1f",percentageScroll), "scrollBucket": scrollBucketStr, "SectionName": sectionTitle])
            }
            self.lastScrollValue = scrollBucketStr
            
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            
            let percentageScroll:CGFloat = ((scrollView.contentOffset.x+scrollView.frame.size.width)/scrollView.contentSize.width)*100
            let scrollBucketStr = scrollBucket(scrollValue: percentageScroll)
            if self.lastScrollValue != scrollBucketStr {
                if let sectionTitle = self.cellTitleLabel.text {
                    AnalyticsVader.sharedVader.basicEvents(eventName: EventName.HomeSectionHorizontalScroll, properties: ["percentage":String(format:"%.1f",percentageScroll), "scrollBucket": scrollBucketStr, "SectionName": sectionTitle])
                }
                self.lastScrollValue = scrollBucketStr
            }
        }
    }

}
