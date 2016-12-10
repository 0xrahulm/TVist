//
//  FriendsViewController.swift
//  Escape
//
//  Created by Ankit on 04/12/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol FriendsProtocol : class {
    func taggedFriendIds(ids : [String])
}

class FriendsViewController: UIViewController {
    
    var dataArray : [MyAccountItems] = []
    weak var freindsDelegate : FriendsProtocol?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Friends"
        MyAccountDataProvider.sharedDataProvider.followersDelegate = self
        MyAccountDataProvider.sharedDataProvider.getUserFriends()

        
    }

}
extension FriendsViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data = dataArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("followCellIdentifier") as! FollowersTableViewCell
        
        cell.followerImage.downloadImageWithUrl(data.profilePicture, placeHolder: UIImage(named: "profile_placeholder"))
        cell.nameLabel.text = "\(data.firstName) \(data.lastName)"
        cell.countLabel.text = "\(data.followers) Followers"
        
        
        if let id = data.id{
            cell.userId = id  // id should not be optinal here.
        }
        
        return cell
        
    }
}
extension FriendsViewController : FollowersProtocol{
    func recievedFollowersData(data: [MyAccountItems], userType: UserType) {
        
            dataArray = data
            tableView.reloadData()
        
    }
    
    func error() {
        
    }
}
