//
//  ListingTableViewCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 28/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

enum ListingSectionCollectionCellIdentifier: String {
    case MediaRemotePlayViewCell = "MediaRemotePlayViewCell"
}

enum HeightForListingSection: CGFloat {
    case MediaRemotePlayCellHeight = 130
}

enum WidthForListingSection: CGFloat {
    case MediaRemotePlayCellWidth = 295
}

let kNumberOfFixedSections:Int = 3

protocol ListingSectionProtocol: class {
    func didTapOnChannelNumber(channelNumber: String)
}

class ListingTableViewCell: HomeSectionBaseCell {
    
    var collectionView: UICollectionView!
    weak var listingSectionDelegate: ListingSectionProtocol?
    
    var matricallyArranged:[[ListingMediaItem]] = []

    weak var viewAllTapDelegate: ViewAllTapProtocol?
    
    var registerableCells:[ListingSectionCollectionCellIdentifier] = [.MediaRemotePlayViewCell]
    let letters = (0..<26).map({Character(UnicodeScalar("a".unicodeScalars.first!.value + $0)!)})
    
    class func totalHeight(count: Int) -> CGFloat {
        if count > 0 {
            return CGFloat(kNumberOfFixedSections)*HeightForListingSection.MediaRemotePlayCellHeight.rawValue
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
    
    func setDataAndInitialiseView(data: [ListingMediaItem]) {
        
        if collectionView == nil {
            self.layoutIfNeeded()
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: WidthForListingSection.MediaRemotePlayCellWidth.rawValue, height: HeightForListingSection.MediaRemotePlayCellHeight.rawValue)
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
        self.addItemsMatrically(data)
        
        
        self.collectionView.reloadData()
    }
    
    func addItemsMatrically(_ items: [ListingMediaItem]) {
        self.matricallyArranged = []
        
        var rowIncr = 0
        var colIncr = 0
        for eachItem in items {
            
            let col = colIncr
            let row = rowIncr
            
            if col == 0 {
                self.matricallyArranged.append([])
            }
            self.matricallyArranged[row].append(eachItem)
            
            colIncr += 1
            if colIncr == kNumberOfFixedSections {
                rowIncr += 1
                colIncr = 0
            }
        }
        
    }
    
    @IBAction func viewAllTapped() {
        if let viewAllTapDelegate = viewAllTapDelegate {
            viewAllTapDelegate.viewAllTappedIn(self)
        }
    }
    
    
}

extension ListingTableViewCell: MediaRemotePlayProtocol {
    func didTapOnChannelNumber(channelNumber: String) {
        if let listingSectionDelegate = self.listingSectionDelegate {
            listingSectionDelegate.didTapOnChannelNumber(channelNumber: channelNumber)
        }
    }
}

extension ListingTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listingItem = self.matricallyArranged[indexPath.section][indexPath.row]
        if let mediaItemName = listingItem.mediaItem.name {
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.HomeAiringNowItemClick, properties: ["Grid":"\(indexPath.section+1)_\(letters[indexPath.row])", "escapeName": mediaItemName])
        }
        
        
        if let escapeItem = EscapeItem.createWithMediaItem(mediaItem: listingItem.mediaItem) {
            ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: ["escapeItem":escapeItem])
        }
    }
}

extension ListingTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.matricallyArranged[indexPath.section][indexPath.row]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListingSectionCollectionCellIdentifier.MediaRemotePlayViewCell.rawValue, for: indexPath) as? MediaRemotePlayViewCell {
            cell.mediaRemoteDelegate = self
            cell.mediaItem = item
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.matricallyArranged[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.matricallyArranged.count
    }
}
