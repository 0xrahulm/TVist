//
//  MyProfileViewController.swift
//  Escape
//
//  Created by Rahul Meena on 13/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import ionicons
import Realm
import RealmSwift

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var escapeCount:     UILabel!
    @IBOutlet weak var followerCount:   UILabel!
    @IBOutlet weak var followingCount:  UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let kHeightOfSegmentedControl:CGFloat = 45.0
    
    var userId : String?
    var isFollow = false
    
    var listOfItemType:[ProfileListType] = [.Activity, .Movie, .TvShows, .Books]
    var listOfTitles:[String] = ["Activity", "Movies", "Tv Shows", "Books"]
    var tabItems:[TabButton] = []
    
    var profileItemUpdateNotification:NotificationToken?
    
    private var _profileList:Results<ProfileList>?
    
    var profileListData:Results<ProfileList> {
        get {
            if currentSelectedIndex == lastSelectedIndex {
                if let profileList = _profileList {
                    return profileList
                }
            }
            let listItem = listOfItemType[currentSelectedIndex]
            lastSelectedIndex = currentSelectedIndex
            _profileList = MyAccountDataProvider.sharedDataProvider.getProfileList(listItem, forUserId: userId)
            
            profileItemUpdateNotification = _profileList!.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .Initial(_):
                    // Results are now populated and can be accessed without blocking the UI
                    tableView.reloadData()
                    break
                case .Update(_, _, _, _):
                    tableView.reloadData()
                    break
                case .Error:
                    Logger.debug("Error in notificationBlock")
                    break
                }
            }
            return _profileList!
        }
    }
    
    var currentSelectedIndex = 1
    var lastSelectedIndex = -1
    
    var sectionLoadedOnce = false
    
    override func setObjectsWithQueryParameters(queryParams: [String : AnyObject]) {
        if let userId = queryParams["user_id"] as? String {
            self.userId = userId
        }
        
        if let isFollow = queryParams["isFollow"] as? Bool {
            self.isFollow = isFollow
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setVisuals()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        if userId == nil { // means self user
            fetchDataFromRealm()
        } else {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyProfileViewController.otherUserData(_:)), name: NotificationObservers.GetProfileDetailsObserver.rawValue, object: nil)
        }
        
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        profileItemUpdateNotification?.stop()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        MyAccountDataProvider.sharedDataProvider.myAccountDetailsDelegate = self
        MyAccountDataProvider.sharedDataProvider.getUserDetails(userId)
        
        ScreenVader.sharedVader.hideTabBar(false)
        
    }
    
    func fetchEscapesDataFromRealm(typeOfList: ProfileListType) -> [MyAccountEscapeItem]  {
        
        if let currentUserId = ECUserDefaults.getCurrentUserId() {
            
            let escapeType = typeOfList.rawValue
            
            let userDataPredicate = NSPredicate(format: "userId == %@ AND escapeType == %@", currentUserId, escapeType)
            
            do{
                let escapeData = try Realm().objects(UserEscapeData).filter(userDataPredicate)
                
                var dataArray : [MyAccountEscapeItem] = []
                
                let list = escapeData
                if list.count > 0 {
                    var distinctElement : [String] = []
                    
                    for i in list{
                        if let section = i.sectionTitle {
                            
                            var check = true
                            for j in distinctElement {
                                if j == section{
                                    check = false
                                    break
                                }
                            }
                            if (check){
                                distinctElement.append(section)
                            }
                        }
                    }
                    
                    for item in distinctElement{
                        let predicate = NSPredicate(format: "sectionTitle == %@", item)
                        let sectionList = list.filter(predicate)
                        if sectionList.count > 0 {
                            
                            var title : String?
                            var count : NSNumber?
                            var rating : NSNumber?
                            var year : String?
                            var escapeData : [EscapeDataItems] = []
                            
                            for item in sectionList{
                                title = item.sectionTitle
                                count = item.sectionCount
                                rating = item.rating
                                year = item.year
                                
                                if let escapeType = item.escapeType{
                                    escapeData.append(EscapeDataItems(id: item.id, name: item.name, image: item.posterImage, escapeType: EscapeType(rawValue:escapeType), escapeRating: rating, year: year))
                                }
                                
                            }
                            dataArray.append(MyAccountEscapeItem(title: title, count: count, escapeData: escapeData))
                        }
                    }
                    
                    return dataArray
                }
                
            } catch let error as NSError {
                print("fetchEscapesDataFromRealm error : \(error.userInfo)")
            }
        }
        
        return []
    }
    
    func profileItemsForSelectedTab() -> List<ProfileItem> {
        
        if let profileList = selectedProfileList() {
            return profileList.data
        }
        return List<ProfileItem>()
    }
    
    func selectedProfileList() -> ProfileList? {
        return profileListData.first
    }
    
    func fetchDataFromRealm() {
        
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
            pushUpUserData(user.firstName, lastName: user.lastName, profilePicture: user.profilePicture, followers: user.followers, following: user.following, booksCount: user.books_count, moviesCount: user.movies_count, tvShowsCount: user.tvShows_count)
        }
        
    }
    
    
    func pushUpUserData(firstName: String, lastName: String?, profilePicture: String?, followers:Int, following: Int, booksCount: Int, moviesCount: Int, tvShowsCount: Int) {
        if let lastName = lastName where lastName.characters.count > 0 {
            self.navigationItem.title = "\(firstName) \(lastName)"
        } else {
            self.navigationItem.title = firstName
        }
        
        profileImage.downloadImageWithUrl(profilePicture, placeHolder: UIImage(named: "profile_placeholder"))
        
        followerCount.text = "\(followers)"
        
        followingCount.text = "\(following)"
        
        let escapes_count = moviesCount + tvShowsCount + booksCount
        
        escapeCount.text = "\(escapes_count)"
    }
    
    func otherUserData(notification: NSNotification) {
        if let userInfo = notification.userInfo, let userData = userInfo["userData"] as? MyAccountItems {
            if let userId = userId, let userDataId = userData.id {
                if userId == userDataId {
                    pushUpUserData(userData.firstName, lastName: userData.lastName, profilePicture: userData.profilePicture, followers: userData.followers.integerValue, following: userData.following.integerValue, booksCount: userData.books_count.integerValue, moviesCount: userData.movies_count.integerValue, tvShowsCount: userData.tvShows_count.integerValue)
                }
            }
            
        }
    }
    //
    //    func receivedSelectedTabData(notification: NSNotification) {
    //        if let userInfo = notification.userInfo {
    //            if let listType = userInfo["type"] as? String, let listTypePresent = ProfileListType(rawValue: listType) {
    //
    //                if let dataUserId = userInfo["userId"] as? String, let userId = userId {
    //                    if dataUserId == userId {
    //                        if let listItems = userInfo["data"] as? [MyAccountEscapeItem] {
    //                            allProfileData[listTypePresent.rawValue] = listItems
    //
    //                        }
    //                        if listOfItemType[currentSelectedIndex] == listTypePresent {
    //                            tableView.reloadData()
    //                        }
    //                    }
    //                } else {
    //                    if listOfItemType[currentSelectedIndex] == listTypePresent {
    //                        tableView.reloadData()
    //                    }
    //                }
    //            }
    //        }
    //
    //    }
    
    func setVisuals() {
        let settingImage = IonIcons.imageWithIcon(ion_ios_settings_strong, size: 22, color: UIColor.themeColorBlack())
        let settingButton : UIBarButtonItem = UIBarButtonItem(image: settingImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MyProfileViewController.settingsTapped))
        
        self.navigationItem.rightBarButtonItem = settingButton
        
        editProfileButton.layer.borderColor = UIColor.textGrayColor().CGColor
        editProfileButton.layer.borderWidth = 1.0
        editProfileButton.layer.cornerRadius = 4.0
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func settingsTapped() {
        ScreenVader.sharedVader.performScreenManagerAction(.MyAccountSetting, queryParams: nil)
    }
    
    func didSelectATab(sender: AnyObject) {
        if let selectedTab = sender as? TabButton {
            disableAllTabs()
            
            selectedTab.setButtonEnabled(true)
            
            if !sectionLoadedOnce || currentSelectedIndex != selectedTab.tag {
                
                currentSelectedIndex = selectedTab.tag
                
                tableView.reloadData()
                
            }
            
        }
    }
    
    func disableAllTabs() {
        for aTab in tabItems {
            aTab.setButtonEnabled(false)
        }
    }
    
    
    @IBAction func followerFollowingClicked(sender: UITapGestureRecognizer) {
        if let view = sender.view{
            var userType : UserType = .Followers
            if view.tag == 6{
                userType = .Following
            }
            if let userId = userId{
                ScreenVader.sharedVader.performScreenManagerAction(.OpenFollowers, queryParams: ["userType": userType.rawValue, "userId" : userId])
            }else{
                ScreenVader.sharedVader.performScreenManagerAction(.OpenFollowers, queryParams: ["userType": userType.rawValue])
            }
        }
    }
    
    @IBAction func editProfileButtonTapped(sender: AnyObject) {
        
        if let userId = userId {
            if isFollow{
                isFollow = false
                editProfileButton.unfollowViewWithAnimate(true)
                UserDataProvider.sharedDataProvider.unfollowUser(userId)
                
            }else{
                isFollow = true
                editProfileButton.followViewWithAnimate(true)
                UserDataProvider.sharedDataProvider.followUser(userId)
            }
        }
    }
}


extension MyProfileViewController : MyAccountDetailsProtocol {
    func recievedUserDetails() {
        fetchDataFromRealm()
    }
    
    func errorUserDetails() {
    }
}

extension MyProfileViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: kHeightOfSegmentedControl))
        headerView.backgroundColor = UIColor.whiteColor()
        
        var xMovement:CGFloat = 0.0
        let widthOfButton = (headerView.frame.size.width/CGFloat(listOfItemType.count))
        
        self.tabItems = []
        
        for (index,aListTitle) in listOfTitles.enumerate() {
            let tabButton = TabButton(frame: CGRect(x: xMovement, y: 0, width: widthOfButton, height: headerView.frame.size.height))
            
            tabButton.setTabTitle(aListTitle)
            tabButton.tag = index
            xMovement += widthOfButton
            tabButton.addTarget(self, action: #selector(MyProfileViewController.didSelectATab(_:)), forControlEvents: .TouchUpInside)
            
            headerView.addSubview(tabButton)
            self.tabItems.append(tabButton)
        }
        
        if self.tabItems.count > currentSelectedIndex {
            didSelectATab(self.tabItems[currentSelectedIndex])
        }
        
        sectionLoadedOnce = true
        
        // HairLine at the bottom
        let hairLineView = UIView(frame: CGRect(x: 0, y: headerView.frame.size.height-0.5, width: headerView.frame.size.width, height: 0.5))
        hairLineView.backgroundColor = UIColor.textGrayColor()
        headerView.addSubview(hairLineView)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeightOfSegmentedControl
    }
}

extension MyProfileViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileItemsForSelectedTab().endIndex
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("escapesSectionHorizontalidentifier") as! CustomListTableViewCell
        cell.viewAllTapDelegate = self
        cell.cellTitleLabel.text = profileItemsForSelectedTab()[indexPath.row].title
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? CustomListTableViewCell else{
            return
        }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
    
}


extension MyProfileViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if let escapeItemCell = collectionView.cellForItemAtIndexPath(indexPath) as? CustomListCollectionViewCell {
            
            escapeItemCell.popTheImage()
        }
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if profileItemsForSelectedTab().endIndex > collectionView.tag{
            let data = profileItemsForSelectedTab()[collectionView.tag].escapeDataList
            
            if data.endIndex > 0 {
                
                var params : [String:AnyObject] = [:]
                
                params["escapeItem"] = data[indexPath.row]
                
                ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)
            }
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dataList = profileItemsForSelectedTab()[collectionView.tag].escapeDataList
        return dataList.endIndex
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewBasicCell", forIndexPath: indexPath) as! CustomListCollectionViewCell
        
        
        let item = profileItemsForSelectedTab()[collectionView.tag].escapeDataList
        cell.dataItems = item[indexPath.row]
        
        return cell
    }
}

extension MyProfileViewController: ViewAllTapProtocol {
    func viewAllTappedIn(cell: UITableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            
            let selectedProfileItem = profileItemsForSelectedTab()[indexPath.row]
            
            
            if let selectedProfileList = selectedProfileList(), let escapeAction = selectedProfileItem.title {
                var queryParams:[String:AnyObject] = [:]
                
                let escapeType = selectedProfileList.type
                queryParams["escapeType"] = escapeType
                queryParams["escapeAction"] = escapeAction
                
                if let userId = userId {
                    queryParams["userId"] = userId
                }
                
                ScreenVader.sharedVader.performScreenManagerAction(.OpenUserEscapesList, queryParams: queryParams)
            }
            
        }
    }
}

