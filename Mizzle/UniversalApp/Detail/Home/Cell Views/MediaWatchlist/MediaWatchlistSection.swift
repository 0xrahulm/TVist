//
//  MediaWatchlistSection.swift
//  Mizzle
//
//  Created by Rahul Meena on 25/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

enum MediaWatchlistCellIdentifier: String {
    case WatchlistCell = "MediaWatchlistWithAirtimeTableViewCell"
    case EmptyStringCell = "EmptyStringTableViewCell"
}

enum HeightForMediaCell:CGFloat {
    case WatchlistCell = 116
    case WatchlistWithAirtime = 130
}

class MediaWatchlistSection: HomeSectionBaseCell {
    
    var tableView: UITableView!
    
    var watchlistItems:[EscapeItem] = []
    
    var emptyString: String?
    
    var registerableCells:[MediaWatchlistCellIdentifier] = [.WatchlistCell, .EmptyStringCell]
    
    class func totalHeight(count: Int) -> CGFloat {
        if count > 0 {
            return CGFloat(count)*HeightForMediaCell.WatchlistCell.rawValue
        } else {
            return HeightForMediaCell.WatchlistCell.rawValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        
    }
    
    func initXibs() {
        for genericCell in registerableCells {
            tableView.register(UINib(nibName: genericCell.rawValue, bundle: nil), forCellReuseIdentifier: genericCell.rawValue)
        }
    }
    
    func setEmptyString(emptyString: String) {
        self.emptyString = emptyString
        setupTableViewIfRequired()
        self.tableView.reloadData()
    }
    
    func setDataAndInitialiseView(data: [EscapeItem]) {
        self.emptyString = nil
        self.watchlistItems.removeAll()
        setupTableViewIfRequired()
        self.watchlistItems.append(contentsOf: data)
        self.tableView.reloadData()
    }
    
    func setupTableViewIfRequired() {
        
        if tableView == nil {
            self.layoutIfNeeded()
            tableView = UITableView(frame: self.containerView.bounds, style: .plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            
            tableView.isScrollEnabled = false
            tableView.separatorColor = nil
            
            self.containerView.addSubview(tableView)
            
            tableView.translatesAutoresizingMaskIntoConstraints = true
            tableView.center = CGPoint(x: self.containerView.bounds.midX, y: self.containerView.bounds.midY)
            tableView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            
            initXibs()
        }
    }
    
    
}


extension MediaWatchlistSection:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = self.emptyString {
            return HeightForMediaCell.WatchlistCell.rawValue
        }
        
        return HeightForMediaCell.WatchlistCell.rawValue
    }
}

extension MediaWatchlistSection:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = self.emptyString {
            return 1
        }
        
        return watchlistItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let emptyString = self.emptyString {
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaWatchlistCellIdentifier.EmptyStringCell.rawValue, for: indexPath) as! EmptyStringTableViewCell
            cell.emptyStringLabel.text = emptyString
            return cell
        }
        
        let escapeItem = watchlistItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaWatchlistCellIdentifier.WatchlistCell.rawValue, for: indexPath) as! MediaWatchlistWithAirtimeTableViewCell

        cell.mediaItem = escapeItem
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let _ = self.emptyString {
            return
        }
        
        let escapeItem = watchlistItems[indexPath.row]
        
        var params : [String:AnyObject] = [:]
        
        params["escapeItem"] = escapeItem
        
        ScreenVader.sharedVader.performUniversalScreenManagerAction(.openMediaItemDescriptionView, queryParams: params)
    
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.WatchlistItemClick, properties: ["Position":"\(indexPath.row+1)", "escapeName": escapeItem.name, "ViewType":self.homeViewType.rawValue])
    }
}
