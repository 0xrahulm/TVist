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
    case MediaListSectionHeight = 305
    case MediaListItemWidth = 152
}

class CustomListTableViewCell: HomeSectionBaseCell {
    
    var collectionView: UICollectionView!
    
    weak var viewAllTapDelegate: ViewAllTapProtocol?
    
    var registerableCells:[DiscoverSectionCollectionCellIdentifier] = [.MediaItemCollectionViewCell]
    var escapesDataList: [EscapeItem] = []
    var currentPage: Float = 0
    
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
        if collectionView == nil {
            self.layoutIfNeeded()
            
            let flowLayout = SnappingFlowLayout()
            flowLayout.itemSize = CGSize(width: HeightForDiscoverItems.MediaListItemWidth.rawValue, height: HeightForDiscoverItems.MediaListSectionHeight.rawValue)
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
        
        escapesDataList = data
        
        collectionView.reloadData()
    }
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
    }
    
    @IBAction func viewAllTapped() {
        if let viewAllTapDelegate = viewAllTapDelegate {
            viewAllTapDelegate.viewAllTappedIn(self)
        }
    }
    

}
extension CustomListTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.DiscoverItemClick, properties: ["Position":"\(indexPath.row+1)", "escapeName": escapeItem.name, "ViewType":self.homeViewType.rawValue])
        
        ScreenVader.sharedVader.performUniversalScreenManagerAction(.openMediaItemDescriptionView, queryParams: params)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return escapesDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverSectionCollectionCellIdentifier.MediaItemCollectionViewCell.rawValue, for: indexPath) as! CustomListCollectionViewCell
        
        let item = escapesDataList[indexPath.row]
        cell.dataItems = item
        
        cell.trackPosition = self.homeViewType.rawValue
        
        return cell
    }
}
