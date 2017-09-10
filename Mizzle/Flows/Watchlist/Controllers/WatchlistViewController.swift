//
//  WatchlistViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 02/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class WatchlistViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var userDetailView: UserDetailView!
    
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    var listOfItemType:[FilterType] = [.All, .Television, .Movie]
    var titleForItem: [FilterType: String] = [.All:"All", .Television: "Television", .Movie: "Movies"]
    
    var registerableCells:[MediaWatchlistCellIdentifier] = [.WatchlistCell]
    
    var selectedListType: FilterType = .All
    var loadedOnce:Bool = false
    
    var watchlistItems:[EscapeItem] = []
    
    var nextPage = 1
    
    var fetchingData = false
    var fullDataLoaded = false
    var resetFlag:Bool = false
    
    var shouldHideTabBar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Watchlist"
        self.userDetailView.viewType = "Watchlist"
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(WatchlistViewController.receivedData(notification:)), name: Notification.Name(rawValue:kWatchlistDataNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if watchlistItems.count == 0 {
            loadNexPage()
        } else {
            loadingView.stopAnimating()
        }
        
        if !loadedOnce {
            loadedOnce = true
            initXibs()
        }
    }
    
    
    
    func initXibs() {
        for genericCell in registerableCells {
            tableView.register(UINib(nibName: genericCell.rawValue, bundle: nil), forCellReuseIdentifier: genericCell.rawValue)
        }
    }
    
    func fetchRequest() {
        WatchlistDataProvider.shared.fetchWatchlistData(page: nextPage, type: selectedListType)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)*0.66) {
            loadNexPage()
        }
        scrollEvent()
        
    }
    
    func scrollEvent() {
        // override in base class
    }
    
    func appendDataToBeListed(appendableData: [EscapeItem], page: Int?) {
        
        loadingView.stopAnimating()
        
        if let page = page, page == nextPage {
            
            nextPage += 1
            if appendableData.count < DataConstants.kDefaultFetchSize {
                fullDataLoaded = true
            }
            
            if resetFlag {
                resetFlag = false
                watchlistItems = []
            }
            
            watchlistItems.append(contentsOf: appendableData)
            tableView.reloadData()
            
            fetchingData = false
        }
        
    }
    
    func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let type = data["type"] as? String, type == selectedListType.rawValue {
                
                if let watchlistItems = data["watchlist"] as? [EscapeItem] {
                    appendDataToBeListed(appendableData: watchlistItems, page: data["page"] as? Int)
                    if self.watchlistItems.count == 0 && fullDataLoaded {
                        if self.emptyView.isHidden {
                            self.emptyView.visibleWithAnimationDuration(0.2)
                        }
                    } else {
                        self.emptyView.hideWithAnimationAndRemoveView(false, duration: 0.2)
                    }
                    
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func getName() -> String {
        return ScreenNames.Watchlist.rawValue
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return HeightForMediaCell.WatchlistCell.rawValue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return watchlistItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let escapeItem = watchlistItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaWatchlistCellIdentifier.WatchlistCell.rawValue, for: indexPath) as! MediaWatchlistTableViewCell
        cell.mediaTitleLabel.text = escapeItem.name
        cell.posterImageView.downloadImageWithUrl(escapeItem.posterImage, placeHolder: UIImage(named: "movie_placeholder"))
        if let nextAirtime = escapeItem.nextAirtime {
            
            cell.timeLabel.text = nextAirtime.airTime
            cell.dayLabel.text = nextAirtime.dayText()
            cell.seasonEpisodeLabel.text = nextAirtime.episodeString
            cell.channelImageView.downloadImageWithUrl(nextAirtime.channelIcon, placeHolder: IconsUtility.airtimeIcon())
        } else {
            cell.timeLabel.text = nil
            cell.dayLabel.text = "N/A"
            cell.seasonEpisodeLabel.text = nil
            cell.channelImageView.image = nil
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let escapeItem = watchlistItems[indexPath.row]
        
        var params : [String:AnyObject] = [:]
        
        params["escapeItem"] = escapeItem
        
        ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)
        
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.OpenWatchlistedItem, properties: ["Position":"\(indexPath.row+1)", "escapeName": escapeItem.name])
    }
}

