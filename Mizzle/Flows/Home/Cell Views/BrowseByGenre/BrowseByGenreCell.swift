//
//  BrowseByGenreCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 29/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

enum BrowseByGenreCollectionCellIdentifier: String {
    case GenreCollectionViewCell = "GenreCollectionViewCell"
}

enum HeightForBrowseByGenreSection: CGFloat {
    case GenreCollectionViewCellHeight = 60
}

class BrowseByGenreCell: HomeSectionBaseCell {
    
    var collectionView: UICollectionView!
    
    
    var matricallyArranged:[[GenreItem]] = []
    
    weak var viewAllTapDelegate: ViewAllTapProtocol?
    
    var registerableCells:[BrowseByGenreCollectionCellIdentifier] = [.GenreCollectionViewCell]
    let letters = (0..<26).map({Character(UnicodeScalar("a".unicodeScalars.first!.value + $0)!)})
    
    class func totalHeight(count: Int) -> CGFloat {
        if count > 0 {
            return CGFloat(kNumberOfFixedSections)*HeightForBrowseByGenreSection.GenreCollectionViewCellHeight.rawValue
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
    
    func setDataAndInitialiseView(data: [GenreItem]) {
        
        if collectionView == nil {
            self.layoutIfNeeded()
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: self.containerView.bounds.width/2-10, height: HeightForBrowseByGenreSection.GenreCollectionViewCellHeight.rawValue)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            
            collectionView = UICollectionView(frame: self.containerView.bounds, collectionViewLayout: flowLayout)
            collectionView.isScrollEnabled = false
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = UIColor.white
            
            self.containerView.addSubview(collectionView)
            initXibs()
        }
        self.addItemsMatrically(data)
        
        
        self.collectionView.reloadData()
    }
    
    
    func addItemsMatrically(_ items: [GenreItem]) {
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

extension BrowseByGenreCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genreItem = self.matricallyArranged[indexPath.section][indexPath.row]
        
        ScreenVader.sharedVader.performScreenManagerAction(.OpenBrowseByGenreView, queryParams: ["genreItem": genreItem])
        if let genreItemName = genreItem.name {
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.HomeGenreItemClick, properties: ["Grid":"\(indexPath.section+1)_\(letters[indexPath.row])", "genreName": genreItemName])
        }
    }
}

extension BrowseByGenreCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.matricallyArranged[indexPath.section][indexPath.row]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowseByGenreCollectionCellIdentifier.GenreCollectionViewCell.rawValue, for: indexPath) as? GenreCollectionViewCell {
            
            cell.genreItem = item
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
