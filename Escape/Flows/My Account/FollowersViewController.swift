//
//  FollowersViewController.swift
//  Escape
//
//  Created by Ankit on 06/07/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class FollowersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray : [MyAccountItems] = []
    var userType : UserType?
    var id : String?
    
    override func setObjectsWithQueryParameters(queryParams: [String : AnyObject]) {
        if let userType = queryParams["userType"]{
            self.userType = UserType(rawValue :  Int(userType as! NSNumber))
        }
        if let id = queryParams["id"] as? String{
            self.id = id
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyAccountDataProvider.sharedDataProvider.followersDelegate = self
        
        if userType == .Followers{
            MyAccountDataProvider.sharedDataProvider.getUserFollowers(id)
            self.title = "Followers"
        }else if userType == .Following{
            MyAccountDataProvider.sharedDataProvider.getUserFollowing(id)
            self.title = "Following"
        }

        
    }
   
}
extension FollowersViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data = dataArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("followCellIdentifier") as! FollowersTableViewCell
        cell.followerImage.downloadImageWithUrl(data.profilePicture, placeHolder: UIImage(named: "profile_placeholder"))
        cell.nameLabel.text = "\(data.firstName) \(data.lastName)"
        cell.countLabel.text = "\(data.followers) Followers"
        
        return cell
        
    }
}
extension FollowersViewController : FollowersProtocol{
    func recievedFollowersData(data: [MyAccountItems], userType: UserType) {
        
        if self.userType == userType{
            dataArray = data
            tableView.reloadData()
        }
        
    }
    func error() {
        
    }
}
