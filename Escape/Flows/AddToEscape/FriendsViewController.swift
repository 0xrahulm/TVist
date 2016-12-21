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
    var searchDataArray : [MyAccountItems] = []
    var selectedDict : [String:Bool] = [:]
    var selectedIds : [String] = []
    weak var freindsDelegate : FriendsProtocol?

    @IBOutlet weak var doneButton: CustomDoneButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Friends"
        MyAccountDataProvider.sharedDataProvider.followersDelegate = self
        MyAccountDataProvider.sharedDataProvider.getUserFriends()
        addCancelButton()
        setupSearchBar()

        
    }
    
    @IBAction func doneTapped(sender: UIButton) {
        if let delegate = freindsDelegate{
            delegate.taggedFriendIds(selectedIds)
        }
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupSearchBar(){
        
        searchBar.delegate = self
        searchBar.setGreyAppearance(self.view.frame.size.width-90, height: 30.0, clearColor : false)
        
    }
    
    func addCancelButton(){
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(FriendsViewController.cancelButtonTapped))
        
        leftBarButtonItem.setTitleTextAttributes([
            NSFontAttributeName : UIFont.init(name: "SFUIDisplay-Medium", size: 15)!,
            NSForegroundColorAttributeName : UIColor.escapeBlueColor(),NSBackgroundColorAttributeName:UIColor.escapeBlueColor()], forState: UIControlState.Normal)
        leftBarButtonItem.setTitleTextAttributes([
            NSFontAttributeName : UIFont.init(name: "SFUIDisplay-Medium", size: 15)!,
            NSForegroundColorAttributeName : UIColor.grayColor(),NSBackgroundColorAttributeName:UIColor.grayColor()], forState: UIControlState.Disabled)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func cancelButtonTapped(){
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addIds(id : String){
        selectedIds.append(id)
    }
    
    func removeIds(id : String){
        
        for (index,idExist) in selectedIds.enumerate(){
            if idExist == id{
                selectedIds.removeAtIndex(index)
                break
            }
        }
        
    }


}
extension FriendsViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? FollowersTableViewCell{
            
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDataArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data = searchDataArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("followCellIdentifier") as! FollowersTableViewCell
        
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
    func recievedFollowersData(data: [MyAccountItems], userType: UserType) {
        
            dataArray = data
            searchDataArray = data
            tableView.reloadData()
    }
    
    func error() {
        
    }
}
extension FriendsViewController : UISearchBarDelegate{
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
            searchDataArray = []
            searchDataArray.appendContentsOf(dataArray.filter({ (item) -> Bool in
                let tmp = item
                let str = tmp.firstName
                let range = str.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                    
                return range != nil
                
            }))
            
            if searchText == ""{
                searchDataArray.appendContentsOf(dataArray)
                searchBar.resignFirstResponder()
            }

        self.tableView.reloadData()
    }
    
}
extension FriendsViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

