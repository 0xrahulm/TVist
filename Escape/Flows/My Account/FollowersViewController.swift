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
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
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
        loadingView.startAnimating()
        MyAccountDataProvider.sharedDataProvider.followersDelegate = self
        
        if userType == .followers {
            self.title = "Followers"
            MyAccountDataProvider.sharedDataProvider.getUserFollowers(id)
        } else if userType == .following {
            self.title = "Following"
            MyAccountDataProvider.sharedDataProvider.getUserFollowing(id)
        } else if userType == .friends {
            self.title = "Friends"
            MyAccountDataProvider.sharedDataProvider.getUserFriends()
        }else if userType == .fbFriends {
            self.title = "Facebook Friends"
            if let storyId = storyId{
              MyAccountDataProvider.sharedDataProvider.getStoryLinkedObjects(storyId)
            }
        }else if userType == .sharedUsersOfStory{
            self.title = "Shared by"
            if let storyId = storyId{
                MyAccountDataProvider.sharedDataProvider.getSharedUsersOfStory(storyId)
            }
        }
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func configurationTextField(_ textField: UITextField!) {
        textField.placeholder = "Enter message"
        txtField = textField
    }
    
    func postRecommend(_ friendId : String){
        if let escapeId = escapeId {
            MyAccountDataProvider.sharedDataProvider.postRecommend([escapeId], friendId: [friendId], message: txtField.text)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showTextBoxPopUP(_ name : String, id : String){
        let alert = UIAlertController(title: "Write message for \(name)", message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler:{ (UIAlertAction) in
            self.postRecommend(id)
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
   
}
extension FollowersViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataArray.count > indexPath.row {
            let data = dataArray[indexPath.row]
            if userType == .friends {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = dataArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "followCellIdentifier") as! FollowersTableViewCell
        if userType == .friends {
            cell.followButton.isHidden = true
        }else{
            cell.followButton.isHidden = false
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
        
        var isCurrentUser = false
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
            if let currentUserId = user.id{
                if let id = data.id{
                    if id == currentUserId{
                        isCurrentUser = true
                    }
                }
            }
        }
        if isCurrentUser{
            cell.followButton.isHidden = true
        }else{
            cell.followButton.isHidden = false
        }
        
        
        return cell
        
    }
}
extension FollowersViewController : FollowersProtocol{
    func recievedFollowersData(_ data: [MyAccountItems], userType: UserType) {
        loadingView.stopAnimating()
        if self.userType == userType{
            dataArray = data
            tableView.reloadData()
        }
        
    }
    func error() {
        
    }
}
extension FollowersViewController : FollowerButtonProtocol{
    func changeLocalDataArray(_ indexPath: IndexPath?, isFollow: Bool) {
        if let indexPath = indexPath{
            if dataArray.count > indexPath.row{
                dataArray[indexPath.row].isFollow = isFollow
            }
        }
    }
}
