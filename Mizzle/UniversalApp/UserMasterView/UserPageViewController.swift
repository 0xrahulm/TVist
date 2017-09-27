//
//  UserPageViewController.swift
//  TVist
//
//  Created by Rahul Meena on 10/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class UserPageViewController: UIViewController {

    @IBOutlet weak var userDetailView: UserDetailView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var userPageItems: [[UserPageItem]] {
        get {
            return [
                [
                    UserPageItem(name: "Watchlist", image: "WatchlistIcon", action: .watchlistDetailView, queryParams: nil),
                    UserPageItem(name: "Seen", image: "SeenIcon", action: .seenDetailView, queryParams: nil)
                ],
                [
                    UserPageItem(name: "What's On Now?", image: "ListingsIcon", action: .airingNowDetailView, queryParams: nil),
                    UserPageItem(name: "Today", image: "TodayIcon", action: .todayDetailView, queryParams: nil),
                    UserPageItem(name: "Next 7 Days", image: "Next7DaysIcon", action: .next7DaysDetailView, queryParams: nil),
                    UserPageItem(name: "Discover", image: "DiscoverIcon", action: .discoverDetailView, queryParams: nil)]
            ]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userDetailView.viewType = "Home"
        self.tableView.backgroundColor = UIColor.styleGuideBackgroundColor()
        
        MyAccountDataProvider.sharedDataProvider.getUserDetails(nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserPageViewController.countsDidUpdate), name: Notification.Name(rawValue:NotificationObservers.CountsDidUpdateObserver.rawValue), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func countsDidUpdate() {
        self.tableView.reloadData()
    }

}

extension UserPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return userPageItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userPageItem = userPageItems[indexPath.section][indexPath.row]
        ScreenVader.sharedVader.performUniversalScreenManagerAction(userPageItem.defaultAction, queryParams: userPageItem.queryParams)
        
        var eventName: EventName = .UserMenuWatchlistTap
        switch userPageItem.defaultAction! {
        case UniversalScreenManagerAction.watchlistDetailView:
            eventName = .UserMenuWatchlistTap
            break
        case UniversalScreenManagerAction.seenDetailView:
            eventName = .UserMenuSeenlistTap
            break
        case UniversalScreenManagerAction.airingNowDetailView:
            eventName = .UserMenuWhatsOnTap
            break
        case UniversalScreenManagerAction.todayDetailView:
            eventName = .UserMenuTodayTap
            break
        case UniversalScreenManagerAction.next7DaysDetailView:
            eventName = .UserMenuNext7DayTap
            break
        case UniversalScreenManagerAction.discoverDetailView:
            eventName = .UserMenuDiscoverTap
            break
        default:
            break
        }
        
        AnalyticsVader.sharedVader.basicEvents(eventName: eventName)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPageItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPageItemTableViewCell", for: indexPath) as! UserPageItemTableViewCell
        cell.userPageItem = userPageItems[indexPath.section][indexPath.row]
        
        if indexPath.row == userPageItems[indexPath.section].count - 1 {
            cell.makeBottomLineFull()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            
            return 28
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            
            let uiView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 28))
            uiView.backgroundColor = UIColor.styleGuideBackgroundColor()
            
            let lineView = UIView(frame: CGRect(x: 0, y: uiView.bounds.height, width: uiView.bounds.width, height: 1))
            lineView.backgroundColor = UIColor.styleGuideTableViewSeparator()
            uiView.addSubview(lineView)
            return uiView
        }
        
        return nil
    }
    
}


