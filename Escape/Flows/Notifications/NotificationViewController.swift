//
//  NotificationViewController.swift
//  Escape
//
//  Created by Ankit on 02/01/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    var dataArray : [NotificationItem] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notifications"
        
        UserDataProvider.sharedDataProvider.notificationDelegate = self
        UserDataProvider.sharedDataProvider.getNotification()
        loadingView.startAnimating()
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
        
    }


}
extension NotificationViewController : UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let deepLink = dataArray[indexPath.row].deepLink{
            ScreenVader.sharedVader.processDeepLink(deepLink)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
extension NotificationViewController : UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCellIdentifier", forIndexPath: indexPath) as! NotificationTableViewCell
        let data = dataArray[indexPath.row]
        if let text = data.text{
            cell.titleLabel.text = text
        }else{
            cell.titleLabel.text = ""
        }
        
        if let time = data.timestamp{
            cell.timeLabel.text = TimeUtility.getTimeStampForCard(Double(time))
        }else{
            cell.timeLabel.text = ""
        }
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
}



extension NotificationViewController : NotificationProtocol{
    func recievedNotification(data: [NotificationItem]) {
        dataArray = data
        loadingView.stopAnimating()
        tableView.reloadData()
        
    }
    func error() {
        
    }
}
