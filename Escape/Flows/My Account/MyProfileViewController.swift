//
//  MyProfileViewController.swift
//  Escape
//
//  Created by Rahul Meena on 13/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Messages
import MessageUI


let kReferText = "Suggest me a Movie, Book or a Tv Show you think I might like? Use Mizzle App to send me Suggestions: http://appurl.io/j27havwa"

enum CellIdentifierMyAccount : String{
    case FBFriends = "FBFriendViewMyAccount"
    case PlaceHolder = "PlaceHolderViewMyAccount"
    case AddToEscape = "AddToEscapeViewMyAccount"
    case DiscoverNow = "DiscoverNowViewMyAccount"
}

class MyProfileViewController: UIViewController {
    
//    @IBOutlet weak var editProfileButton: UIButton!
//    @IBOutlet weak var followUnfollowButton: UIButton!
    
//    @IBOutlet weak var profileImage: UIImageView!
//    
//    @IBOutlet weak var escapeCount:     UILabel!
//    @IBOutlet weak var followerCount:   UILabel!
//    @IBOutlet weak var followingCount:  UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userDetailView: UserDetailView!
    
    let kHeightOfSegmentedControl:CGFloat = 60.0
    
    var firstLoad:Bool = true
    var userId : String?
    
    var listOfItemType:[ProfileListType] = [.Movie, .TvShows]
    var listOfTitles:[String] = ["Movies", "Tv Shows"]
    var tabItems:[TabButton] = []
    var isFollow:Bool = false
    var profileItemUpdateNotification:NotificationToken?
    var reload:Bool = true
    
    fileprivate var _profileList:Results<ProfileList>?
    
    fileprivate var _otherUserProfileList:[ProfileListType:[ProfileList]] = [:]
    
    
    var profileListData: [ProfileList] {
        get {
            
            let listItem = listOfItemType[currentSelectedIndex]
            
            if currentSelectedIndex == lastSelectedIndex {
                if let _profileList = _profileList {
                    return Array(_profileList)
                }
                
                if let otherUserProfile = _otherUserProfileList[listItem] {
                    return otherUserProfile
                }
            } else {
                
                lastSelectedIndex = currentSelectedIndex
                
                
                if isLoggedInUser() && listItem != .Activity {
                    self._profileList = MyAccountDataProvider.sharedDataProvider.getProfileList(listItem, forUserId: userId)
                    profileItemUpdateNotification = _profileList!.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
                        guard let tableView = self?.tableView else { return }
                        switch changes {
                            
                        case .initial(_):
                            // Results are now populated and can be accessed without blocking the UI
                            tableView.reloadData()
                            break
                        case .update(_, deletions: _, insertions: _, modifications: _):
                            tableView.reloadData()
                            break
                        case .error(_):
                            Logger.debug("Error in notificationBlock")
                            break
                        }
                    }
                    if let _profileList = self._profileList {
                        
                        return Array(_profileList)
                    }
                } else {
                    _ = MyAccountDataProvider.sharedDataProvider.getProfileList(listItem, forUserId: userId)
                    if let otherUserProfile = _otherUserProfileList[listItem] {
                        return otherUserProfile
                    }
                }
                
            }
            
            
            let emptyProfileList = ProfileList.getLoadingTypePorfileList()
            return [emptyProfileList]
        }
    }
    
    
    var currentSelectedIndex = 0
    var lastSelectedIndex = -1
    
    var sectionLoadedOnce = false
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        if let userId = queryParams["user_id"] as? String {
            self.userId = userId
        }
    }
    
    
    var cardsTypeArray: [CellIdentifierMyAccount] = [.FBFriends, .PlaceHolder, .AddToEscape, .DiscoverNow]
    
    func initXibs() {
        
        for cardType in cardsTypeArray{
            tableView.register(UINib(nibName: cardType.rawValue, bundle: nil), forCellReuseIdentifier: cardType.rawValue)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userDetailView.viewType = "Watchlist"
        setVisuals()
        initXibs()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if isLoggedInUser() {
            fetchDataFromRealm()
        } else {
            
//            NotificationCenter.default.addObserver(self, selector: #selector(MyProfileViewController.otherUserData(_:)), name: NSNotification.Name(rawValue: NotificationObservers.GetProfileDetailsObserver.rawValue), object: nil)
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyProfileViewController.receivedListData(_:)), name: NSNotification.Name(rawValue: NotificationObservers.OtherUserProfileListFetchObserver.rawValue), object: nil)
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        profileItemUpdateNotification?.stop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if reload {
            MyAccountDataProvider.sharedDataProvider.myAccountDetailsDelegate = self
            MyAccountDataProvider.sharedDataProvider.getUserDetails(userId)
        }
        
        self.reload = true
        
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
        
        ScreenVader.sharedVader.hideTabBar(false)
        let listItem = listOfItemType[currentSelectedIndex]
        if !self.firstLoad {
            
            _ = MyAccountDataProvider.sharedDataProvider.getProfileList(listItem, forUserId: userId)
        }
        self.firstLoad = false
    }
    
    func fetchEscapesDataFromRealm(_ typeOfList: ProfileListType) -> [MyAccountEscapeItem]  {
        
        if let currentUserId = ECUserDefaults.getCurrentUserId() {
            
            let escapeType = typeOfList.rawValue
            
            let userDataPredicate = NSPredicate(format: "userId == %@ AND escapeType == %@", currentUserId, escapeType)
            
            do{
                let escapeData = try Realm().objects(UserEscapeData.self).filter(userDataPredicate)
                
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
//            pushUpUserData(user.firstName, lastName: user.lastName, profilePicture: user.profilePicture, followers: user.followers, following: user.following, escapesCount: user.escape_count)
        }
        
    }
    
    
//    func pushUpUserData(_ firstName: String, lastName: String?, profilePicture: String?, followers:Int, following: Int, escapesCount: Int) {
//        if let lastName = lastName, lastName.characters.count > 0 {
//            self.navigationItem.title = "\(firstName) \(lastName)"
//        } else {
//            self.navigationItem.title = firstName
//        }
//        
//        profileImage.downloadImageWithUrl(profilePicture, placeHolder: UIImage(named: "profile_placeholder"))
//        
//        followerCount.text = "\(followers)"
//        
//        followingCount.text = "\(following)"
//        
//        
//        escapeCount.text = "\(escapesCount)"
//    }
    
//    func otherUserData(_ notification: Notification) {
//        if let userInfo = notification.userInfo, let userData = userInfo["userData"] as? MyAccountItems {
//            if let userId = userId, let userDataId = userData.id {
//                if userId == userDataId {
//                    pushUpUserData(userData.firstName, lastName: userData.lastName, profilePicture: userData.profilePicture, followers: userData.followers.intValue, following: userData.following.intValue, escapesCount: userData.escapes_count.intValue)
//                    self.isFollow = userData.isFollow
//                    if self.isFollow {
////                        self.followUnfollowButton.followViewWithAnimate(false)
//                    } else {
////                        self.followUnfollowButton.unfollowViewWithAnimate(false)
//                    }
//                }
//            }
//            
//        }
//    }
    
    func receivedListData(_ notification:Notification) {
        if let userInfo = notification.userInfo {
            
            
            if let listType = userInfo["type"] as? String, let listTypePresent = ProfileListType(rawValue: listType) {
                
                if let listData = userInfo["data"] as? ProfileList {
                    let userIdForData = listData.userId
                    if let userId = self.userId, userId == userIdForData {
                        
                        self._otherUserProfileList[listTypePresent] = [listData]
                        self.tableView.reloadData()
                        
                    } else if isLoggedInUser() && listTypePresent == .Activity {
                        
                        self._otherUserProfileList[listTypePresent] = [listData]
                        self.tableView.reloadData()
                    }
                }
                
            }
        }
    }
    
    
    
    func configureFBFriendCell(_ tableView : UITableView , indexPath : IndexPath, data: FBFriendCard) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierMyAccount.FBFriends.rawValue) as! FBFriendsTableViewCell
        cell.friendItems = data
        cell.indexPath = indexPath
        return cell
    }
    
    func configurePlaceHolderCell(_ tableView : UITableView, indexPath : IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierMyAccount.PlaceHolder.rawValue, for: indexPath)
        
        return cell
    }
    
    func configureAddToEscapeCell(_ tableView : UITableView, indexPath : IndexPath, data: AddToEscapeCard) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierMyAccount.AddToEscape.rawValue, for: indexPath) as! AddToEscapeTableViewCell
        
        cell.indexPath = indexPath
        cell.escapeItems = data
        return cell
    }
    
    func setVisuals() {
        
        if isLoggedInUser() {
            
            let settingImage = IonIcons.image(withIcon: ion_android_notifications, size: 22, color: UIColor.themeColorBlack())
            let settingButton : UIBarButtonItem = UIBarButtonItem(image: settingImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(MyProfileViewController.notificationTapped))
            
            self.navigationItem.rightBarButtonItem = settingButton
            
//            editProfileButton.isHidden = false
//            followUnfollowButton.isHidden = true
//            
//            editProfileButton.layer.borderColor = UIColor.textGrayColor().cgColor
//            editProfileButton.layer.borderWidth = 1.0
//            editProfileButton.layer.cornerRadius = 4.0
            
        } else {
            
//            editProfileButton.isHidden = true
//            followUnfollowButton.isHidden = false
//            
//            followUnfollowButton.layer.cornerRadius = 4.0
//            self.followUnfollowButton.disableButton(false)
            
        }
        
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func isLoggedInUser() -> Bool {
        return self.userId == nil
    }
    
    func notificationTapped(){
        ScreenVader.sharedVader.performScreenManagerAction(.OpenNotificationView, queryParams: nil)
        
    }
    
    func settingsTapped() {
        ScreenVader.sharedVader.performScreenManagerAction(.MyAccountSetting, queryParams: ["delegate": self])
    }
    
    func didSelectATab(_ sender: AnyObject) {
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
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        
        if let userId = userId {
            if isFollow {
                isFollow = false
//                self.followUnfollowButton.unfollowViewWithAnimate(true)
                UserDataProvider.sharedDataProvider.unfollowUser(userId)
                
            }else{
                isFollow = true
//                self.followUnfollowButton.followViewWithAnimate(true)
                UserDataProvider.sharedDataProvider.followUser(userId)
            }
        }
    }
    
    @IBAction func followerFollowingClicked(_ sender: UITapGestureRecognizer) {
        if let view = sender.view{
            var userType : UserType = .followers
            if view.tag == 6{
                userType = .following
            }
            if let userId = userId{
                ScreenVader.sharedVader.performScreenManagerAction(.OpenFollowers, queryParams: ["userType": userType.rawValue, "userId" : userId])
            }else{
                ScreenVader.sharedVader.performScreenManagerAction(.OpenFollowers, queryParams: ["userType": userType.rawValue])
            }
        }
    }
    
    @IBAction func escapeViewTapped(_ sender: UITapGestureRecognizer) {
        
        if let tableHeader = tableView.tableHeaderView {
            
            tableView.setContentOffset(CGPoint(x: 0, y: tableHeader.frame.size.height), animated: true)
        }
        
    }
    @IBAction func editProfileButtonTapped(_ sender: AnyObject) {
        settingsTapped()
        
    }
    
}

extension MyProfileViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension MyProfileViewController: DiscoverNowAskFriendsProtocol {
    func didTapiMessage() {
        
        let composeVC = MFMessageComposeViewController()
        
        composeVC.body = kReferText
        composeVC.messageComposeDelegate = self
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func didTapWhatsapp() {
        
        let url = "whatsapp://send?text=\(kReferText)"
        
        if let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            if let appUrl = URL(string: urlString) {
                
                if UIApplication.shared.canOpenURL(appUrl) {
                    UIApplication.shared.openURL(appUrl)
                }
            }
        }
        
    }
    
    func didTapMessanger() {
        
        let activityController = UIActivityViewController(activityItems: [kReferText], applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = self.view
        self.present(activityController, animated: true, completion: nil)
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: kHeightOfSegmentedControl))
        headerView.backgroundColor = UIColor.white
        
        var xMovement:CGFloat = 0.0
        let widthOfButton = (headerView.frame.size.width/CGFloat(listOfItemType.count))
        
        self.tabItems = []
        
        let topLineView = UIView(frame: CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: 1.0))
        topLineView.backgroundColor = UIColor.hairlineGrayColor()
        headerView.addSubview(topLineView)
        
        for (index,aListTitle) in listOfTitles.enumerated() {
            let tabButton = TabButton(frame: CGRect(x: xMovement, y: 12, width: widthOfButton, height: headerView.frame.size.height-12))
            
            tabButton.setTabTitle(aListTitle, type: listOfItemType[index])
            tabButton.tag = index
            xMovement += widthOfButton
            tabButton.addTarget(self, action: #selector(MyProfileViewController.didSelectATab(_:)), for: .touchUpInside)
            
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeightOfSegmentedControl
    }
}

extension MyProfileViewController: ProfileImageChangeProtocol {
    func didChangeProfilePic(image: UIImage) {
        self.reload = false
//        self.profileImage.image = image
    }
}

extension MyProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileItemsForSelectedTab().endIndex
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let selectedProfileItem = profileItemsForSelectedTab()[indexPath.row]
        
        if selectedProfileItem.itemTypeEnumValue() == ProfileItemType.showLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomLoadingTableViewCellIdentifier") as! CustomLoadingTableViewCell
            
            cell.activityIndicator.startAnimating()
            return cell
        }
        
        if selectedProfileItem.itemTypeEnumValue() == ProfileItemType.showDiscoverNow {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierMyAccount.DiscoverNow.rawValue, for: indexPath) as! DiscoverNowViewMyAccountTableViewCell
            cell.message.text = selectedProfileItem.title
            cell.tapDelegate = self
            return cell
        }
        
        if selectedProfileItem.itemTypeEnumValue() == ProfileItemType.userStory {
            if let storyCard = selectedProfileItem.associatedStoryCard, let storyType = storyCard.storyType {
                
                switch storyType {
                    
                case .fbFriendFollow:
                    if let fbCard = storyCard as? FBFriendCard {
                        
                        return configureFBFriendCell(tableView, indexPath: indexPath, data: fbCard)
                    }
                    break
                case .addToEscape:
                    if let addToEscapeCard = storyCard as? AddToEscapeCard {
                        return configureAddToEscapeCell(tableView, indexPath: indexPath, data: addToEscapeCard)
                    }
                    break
                case .recommeded:
                    if let addToEscapeCard = storyCard as? AddToEscapeCard {
                        return configureAddToEscapeCell(tableView, indexPath: indexPath, data: addToEscapeCard)
                    }
                default:
                    return configurePlaceHolderCell(tableView, indexPath: indexPath)
                }
            }
        } else {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "escapesSectionHorizontalidentifier") as! CustomListTableViewCell
            cell.viewAllTapDelegate = self
            if let cellTitle = selectedProfileItem.title {
                cell.cellTitleLabel.text = cellTitle+" (\(selectedProfileItem.totalItemsCount))"
            }
            return cell
        }
        
        return configurePlaceHolderCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? CustomListTableViewCell else{
            return
        }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
    
    
    
}


extension MyProfileViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        if let escapeItemCell = collectionView.cellForItem(at: indexPath) as? CustomListCollectionViewCell {
            
            escapeItemCell.popTheImage()
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if profileItemsForSelectedTab().endIndex > collectionView.tag{
            let data = profileItemsForSelectedTab()[collectionView.tag].escapeDataList
            
            if data.endIndex > 0 {
                
                var params : [String:AnyObject] = [:]
                
                params["escapeItem"] = data[indexPath.row]
                
                ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dataList = profileItemsForSelectedTab()[collectionView.tag].escapeDataList
        return dataList.endIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaItemCollectionViewCell", for: indexPath) as! CustomListCollectionViewCell
        
        
        let item = profileItemsForSelectedTab()[collectionView.tag].escapeDataList
        cell.dataItems = item[indexPath.row]
        
        return cell
    }
}

extension MyProfileViewController: ViewAllTapProtocol {
    func viewAllTappedIn(_ cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            
            let selectedProfileItem = profileItemsForSelectedTab()[indexPath.row]
            
            
            if let selectedProfileList = selectedProfileList(), let escapeAction = selectedProfileItem.title {
                var queryParams:[String:Any] = [:]
                
                let escapeType = selectedProfileList.type
                queryParams["escapeType"] = escapeType
                queryParams["escapeAction"] = escapeAction
                
                if escapeAction == EscapeAddActions.ToWatch.rawValue {
                    
                    
                } else if escapeAction == EscapeAddActions.Watched.rawValue {
                    
                    
                }
                
                if let userId = userId {
                    queryParams["userId"] = userId
                }
                
                ScreenVader.sharedVader.performScreenManagerAction(.OpenUserEscapesList, queryParams: queryParams)
            }
            
        }
    }
}

