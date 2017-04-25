//
//  FriendsViewController.swift
//  Escape
//
//  Created by Ankit on 04/12/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol FriendsProtocol : class {
    func taggedFriendIds(_ ids : [String])
}

class FriendsViewController: UIViewController {
    
    var dataArray : [MyAccountItems] = []
    var searchDataArray : [MyAccountItems] = []
    var selectedDict : [String:Bool] = [:]
    var selectedIds : [String] = []
    weak var freindsDelegate : FriendsProtocol?
    
    @IBOutlet weak var doneButton: CustomDoneButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var noFriendsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Friends"
        MyAccountDataProvider.sharedDataProvider.followersDelegate = self
        MyAccountDataProvider.sharedDataProvider.getUserFriends()
        addCancelButton()
        setupSearchBar()
        
        noFriendsView.isHidden = true
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        if let delegate = freindsDelegate{
            delegate.taggedFriendIds(selectedIds)
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func setupSearchBar(){
        
        searchBar.delegate = self
        searchBar.setGreyAppearance(self.view.frame.size.width-90, height: 30.0, clearColor : false)
        
    }
    
    @IBAction func inviteFriendsTapped(sender: UIButton) {
        let text:String = "Check out Escape, it makes it easy to recommend new Movies, Books & TV Shows to each other. Download now: http://appurl.io/j1q73s0r"
        
        let activityController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = self.view
        self.present(activityController, animated: true, completion: nil)
    }
    
    func addCancelButton(){
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action:#selector(FriendsViewController.cancelButtonTapped))
        
        leftBarButtonItem.setTitleTextAttributes([
            NSFontAttributeName : UIFont.init(name: "SFUIDisplay-Medium", size: 15)!,
            NSForegroundColorAttributeName : UIColor.escapeBlueColor(),NSBackgroundColorAttributeName:UIColor.escapeBlueColor()], for: UIControlState())
        leftBarButtonItem.setTitleTextAttributes([
            NSFontAttributeName : UIFont.init(name: "SFUIDisplay-Medium", size: 15)!,
            NSForegroundColorAttributeName : UIColor.gray,NSBackgroundColorAttributeName:UIColor.gray], for: UIControlState.disabled)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func cancelButtonTapped(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func addIds(_ id : String){
        selectedIds.append(id)
    }
    
    func removeIds(_ id : String){
        
        for (index,idExist) in selectedIds.enumerated(){
            if idExist == id{
                selectedIds.remove(at: index)
                break
            }
        }
        
    }
    
    
}
extension FriendsViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FollowersTableViewCell{
            
            let data = searchDataArray[indexPath.row]
            
            if let id = data.id{
                if let check = selectedDict["\(id)"]{
                    if check{
                        selectedDict["\(id)"] = false
                        cell.friendsCheckImage.image = UIImage(named: "unselect")
                        removeIds(id)
                    }else{
                        selectedDict["\(id)"] = true
                        cell.friendsCheckImage.image = UIImage(named: "select")
                        addIds(id)
                    }
                }else{
                    selectedDict["\(id)"] = true
                    cell.friendsCheckImage.image = UIImage(named: "select")
                    addIds(id)
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = searchDataArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "followCellIdentifier") as! FollowersTableViewCell
        
        cell.followerImage.downloadImageWithUrl(data.profilePicture, placeHolder: UIImage(named: "profile_placeholder"))
        cell.nameLabel.text = "\(data.firstName) \(data.lastName)"
        cell.countLabel.text = "\(data.followers) Followers"
        
        
        if let id = data.id{
            cell.userId = id  // id should not be optinal here.
            
            if let check = selectedDict["\(id)"]{
                if check {
                    cell.friendsCheckImage.image = UIImage(named: "select")
                }else{
                    cell.friendsCheckImage.image = UIImage(named: "unselect")
                }
                
            }else{
                cell.friendsCheckImage.image = UIImage(named: "unselect")
            }
        }
        
        return cell
        
    }
}
extension FriendsViewController : FollowersProtocol{
    func recievedFollowersData(_ data: [MyAccountItems], userType: UserType) {
        
        if data.count == 0 {
            self.noFriendsView.visibleWithAnimation()
        }
        dataArray = data
        searchDataArray = data
        tableView.reloadData()
    }
    
    func error() {
        
    }
}
extension FriendsViewController : UISearchBarDelegate{
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchDataArray = []
        searchDataArray.append(contentsOf: dataArray.filter({ (item) -> Bool in
            let tmp = item
            let str = tmp.firstName
            let range = str.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            return range != nil
            
        }))
        
        if searchText == ""{
            searchDataArray.append(contentsOf: dataArray)
            searchBar.resignFirstResponder()
        }
        
        self.tableView.reloadData()
    }
    
}
extension FriendsViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

