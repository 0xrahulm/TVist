//
//  ArticlesSectionTableViewCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 29/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit


enum ArticlesSectionCollectionCellIdentifier: String {
    case ArticleCollectionViewCell = "ArticleCollectionViewCell"
}

enum HeightForArticlesSection: CGFloat {
    case ArticleCellHeight = 260
}


enum WidthForArticlesSection: CGFloat {
    case ArticleCellWidth = 285
}

class ArticlesSectionTableViewCell: HomeSectionBaseCell {

    var collectionView: UICollectionView!
    
    var articleItems:[ArticleItem] = []
    
    weak var viewAllTapDelegate: ViewAllTapProtocol?
    
    var registerableCells:[ArticlesSectionCollectionCellIdentifier] = [.ArticleCollectionViewCell]
    
    
    class func totalHeight(count: Int) -> CGFloat {
        if count > 0 {
            return HeightForArticlesSection.ArticleCellHeight.rawValue
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
    
    
    func setDataAndInitialiseView(data: [ArticleItem]) {
        
        if collectionView == nil {
            self.layoutIfNeeded()
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: WidthForArticlesSection.ArticleCellWidth.rawValue, height: HeightForArticlesSection.ArticleCellHeight.rawValue)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 0
            
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            
            collectionView = UICollectionView(frame: self.containerView.bounds, collectionViewLayout: flowLayout)
            collectionView.backgroundColor = UIColor.white
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.delegate = self
            collectionView.dataSource = self
            
            self.containerView.addSubview(collectionView)
            
            collectionView.translatesAutoresizingMaskIntoConstraints = true
            collectionView.center = CGPoint(x: self.containerView.bounds.midX, y: self.containerView.bounds.midY)
            collectionView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            initXibs()
        }
        
        self.articleItems = data
        
        self.collectionView.reloadData()
    }
    
    
    @IBAction func viewAllTapped() {
        if let viewAllTapDelegate = viewAllTapDelegate {
            viewAllTapDelegate.viewAllTappedIn(self)
        }
    }
}

extension ArticlesSectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.articleItems[indexPath.row]
        
        if let url = URL(string: item.url) {
            
            ScreenVader.sharedVader.openSafariWithUrl(url: url, readerMode: true)
            
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.HomeArticlesItemClick, properties: ["Position":"\(indexPath.row+1)", "articleTitle": item.title])
        }
    }
    
}

extension ArticlesSectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.articleItems[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticlesSectionCollectionCellIdentifier.ArticleCollectionViewCell.rawValue, for: indexPath) as? ArticleCollectionViewCell {
            
            cell.articleItem = item
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articleItems.count
    }
}
