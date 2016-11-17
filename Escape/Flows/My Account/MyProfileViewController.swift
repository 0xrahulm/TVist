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
    
    var listOfItemType:[EscapeType] = [.Activity, .Movie, .TvShows, .Books]
    var listOfTitles:[String] = ["Activity", "Movies", "Tv Shows", "Books"]
    var tabItems:[TabButton] = []
    
    var allProfileData:[String:[MyAccountEscapeItem]] = [:]
    
    var currentSelectedIndex = 0
    
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
        
        initialDataSetup()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        if userId == nil { // means self user
            fetchDataFromRealm()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        MyAccountDataProvider.sharedDataProvider.myAccountDetailsDelegate = self
        MyAccountDataProvider.sharedDataProvider.getUserDetails(userId)
        
        ScreenVader.sharedVader.hideTabBar(false)
        
    }
    
    func initialDataSetup() {
        allProfileData[EscapeType.Activity.rawValue] = fetchEscapesDataFromRealm(EscapeType.Movie)
        allProfileData[EscapeType.Movie.rawValue]    = fetchEscapesDataFromRealm(EscapeType.Movie)
        allProfileData[EscapeType.TvShows.rawValue]  = fetchEscapesDataFromRealm(EscapeType.TvShows)
        allProfileData[EscapeType.Books.rawValue]    = fetchEscapesDataFromRealm(EscapeType.Books)
        tableView.reloadData()
    }
    
    func fetchEscapesDataFromRealm(typeOfList: EscapeType) -> [MyAccountEscapeItem]  {
        
        if let currentUserId = ECUserDefaults.getCurrentUserId(){
            
            let escapeType = typeOfList.rawValue
            
            let userDataPredicate = NSPredicate(format: "userId == %@ AND escapeType == %@", currentUserId, escapeType)
            
            do{
                let escapeData = try Realm().objects(UserEscapeData).filter(userDataPredicate)
                
                var dataArray : [MyAccountEscapeItem] = []
                
                let list = escapeData
                if list.count > 0 {
                    var distinctElement : [String] = []
                    
                    for i in list{
                        if let section = i.sectionTitle{
                            
                            var check = true
                            for j in distinctElement{
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
    
    func getAllDataItemsForSelectedTab() -> [MyAccountEscapeItem] {
        let escapeType = listOfItemType[currentSelectedIndex]
        if let escapeItems = allProfileData[escapeType.rawValue] {
            return escapeItems
        }
        return []
    }
    
    func fetchDataFromRealm() {
        
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
            
            if user.lastName.characters.count > 0 {
                self.navigationItem.title = "\(user.firstName) \(user.lastName)"
            } else {
                self.navigationItem.title = user.firstName
            }
            
            profileImage.downloadImageWithUrl(user.profilePicture, placeHolder: UIImage(named: "profile_placeholder"))
            
            followerCount.text = "\(user.followers)"
            
            followingCount.text = "\(user.following)"
            
            let escapes_count = user.movies_count + user.tvShows_count + user.books_count
            
            escapeCount.text = "\(escapes_count)"
            
        }
        
    }
    
    func setVisuals() {
        let settingImage = IonIcons.imageWithIcon(ion_ios_settings_strong, size: 22, color: UIColor.themeColorBlack())
        let settingButton : UIBarButtonItem = UIBarButtonItem(image: settingImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MyAccountViewController.settingTapped))
        
        self.navigationItem.rightBarButtonItem = settingButton
        
        editProfileButton.layer.borderColor = UIColor.textGrayColor().CGColor
        editProfileButton.layer.borderWidth = 1.0
        editProfileButton.layer.cornerRadius = 4.0
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func didSelectATab(sender: AnyObject) {
        if let selectedTab = sender as? TabButton {
            disableAllTabs()
            
            currentSelectedIndex = selectedTab.tag
            selectedTab.setButtonEnabled(true)
        }
    }
    
    func disableAllTabs() {
        for aTab in tabItems {
            aTab.setButtonEnabled(false)
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
        return getAllDataItemsForSelectedTab().count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("escapesSectionHorizontalidentifier") as! CustomListTableViewCell
        
        cell.cellTitleLabel.text = getAllDataItemsForSelectedTab()[indexPath.row].title
        
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
        
        if getAllDataItemsForSelectedTab().count > collectionView.tag{
            if let data = getAllDataItemsForSelectedTab()[collectionView.tag].escapeData{
                if data.count > 0 {
                    let id = data[indexPath.row].id
                    let escapeType = data[indexPath.row].escapeType
                    let name = data[indexPath.row].name
                    let image = data[indexPath.row].image
                    
                    var params : [String:AnyObject] = [:]
                    if let id = id {
                        params["id"] = id
                    }
                    if let escapeType = escapeType {
                        params["escapeType"] = escapeType.rawValue
                    }
                    if let name = name {
                        params["name"] = name
                    }
                    if let image = image {
                        params["image"] = image
                    }
                    
                    ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if let data = getAllDataItemsForSelectedTab()[collectionView.tag].escapeData{
            count = data.count
        }
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewBasicCell", forIndexPath: indexPath) as! CustomListCollectionViewCell
        
        if let item = getAllDataItemsForSelectedTab()[collectionView.tag].escapeData{
            
            cell.dataItems = item[indexPath.row]
            
        }
        
        return cell
    }
}

