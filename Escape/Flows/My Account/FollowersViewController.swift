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
    var escapeId : String? // for recommedation
    var storyId : String? // for story linked objects
    var txtField: UITextField!
    
    override func setObjectsWithQueryParameters(queryParams: [String : AnyObject]) {
        if let userType = queryParams["userType"]{
            self.userType = UserType(rawValue :  Int(userType as! NSNumber))
        }
        if let id = queryParams["userId"] as? String{
            self.id = id
        }
        if let id = queryParams["escape_id"] as? String{
            self.escapeId = id
        }
        if let id = queryParams["story_id"] as? String{
            self.storyId = id
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyAccountDataProvider.sharedDataProvider.followersDelegate = self
        
        if userType == .Followers {
            self.title = "Followers"
            MyAccountDataProvider.sharedDataProvider.getUserFollowers(id)
        } else if userType == .Following {
            self.title = "Following"
            MyAccountDataProvider.sharedDataProvider.getUserFollowing(id)
        } else if userType == .Friends {
            self.title = "Friends"
            MyAccountDataProvider.sharedDataProvider.getUserFriends()
        }else if userType == .FBFriends {
            self.title = "Facebook Friends"
            if let storyId = storyId{
              MyAccountDataProvider.sharedDataProvider.getStoryLinkedObjects(storyId)
            }
            
        }
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func configurationTextField(textField: UITextField!) {
        textField.placeholder = "Enter message"
        txtField = textField
    }
    
    func postRecommend(friendId : String){
        if let escapeId = escapeId {
            MyAccountDataProvider.sharedDataProvider.postRecommend([escapeId], friendId: [friendId], message: txtField.text)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func showTextBoxPopUP(name : String, id : String){
        let alert = UIAlertController(title: "Write message for \(name)", message: "", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler:{ (UIAlertAction) in
            self.postRecommend(id)
        }))
        self.presentViewController(alert, animated: true, completion: {
            print("completion block")
        })
    }
   
}
extension FollowersViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if dataArray.count > indexPath.row {
            let data = dataArray[indexPath.row]
            if userType == .Friends {
                if let id = data.id {
                    showTextBoxPopUP(data.firstName, id: id)
                }
            }else{
                if let id  = data.id {
                    ScreenVader.sharedVader.performScreenManagerAction(.OpenUserAccount, queryParams: ["user_id":id, "isFollow" : data.isFollow])
                }
            }
        }
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
        if userType == .Friends {
            cell.followButton.hidden = true
        }else{
            cell.followButton.hidden = false
        }
        cell.followerImage.downloadImageWithUrl(data.profilePicture, placeHolder: UIImage(named: "profile_placeholder"))
        cell.nameLabel.text = "\(data.firstName) \(data.lastName)"
        cell.countLabel.text = "\(data.followers) Followers"
        
        cell.isFollow = data.isFollow
        cell.indexPath = indexPath
        cell.followButtonDelegate = self
        
        if let id = data.id{
         cell.userId = id  // id should not be optinal here.
        }
        
        if data.isFollow {
            cell.followButton.followViewWithAnimate(false)
        }else{
            cell.followButton.unfollowViewWithAnimate(false)
        }
        
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
extension FollowersViewController : FollowerButtonProtocol{
    func changeLocalDataArray(indexPath: NSIndexPath?, isFollow: Bool) {
        if let indexPath = indexPath{
            if dataArray.count > indexPath.row{
                dataArray[indexPath.row].isFollow = isFollow
            }
        }
    }
}
