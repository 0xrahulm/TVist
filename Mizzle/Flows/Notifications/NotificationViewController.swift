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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let deepLink = dataArray[indexPath.row].deepLink{
            ScreenVader.sharedVader.processDeepLink(deepLink)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
extension NotificationViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCellIdentifier", for: indexPath) as! NotificationTableViewCell
        let data = dataArray[indexPath.row]
        if let text = data.body{
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
}



extension NotificationViewController : NotificationProtocol{
    func recievedNotification(_ data: [NotificationItem]) {
        dataArray = data
        loadingView.stopAnimating()
        tableView.reloadData()
        
    }
    func error() {
        loadingView.stopAnimating()
    }
}
