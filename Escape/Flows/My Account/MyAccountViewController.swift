//
//  MyAccountViewController.swift
//  Escape
//
//  Created by Ankit on 30/04/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import ionicons
import RealmSwift

class MyAccountViewController: UIViewController{
    
    @IBOutlet weak var contentView:     UIView!
    @IBOutlet weak var topView:     UIView!
    
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var escapeCount:     UILabel!
    @IBOutlet weak var followerCount:   UILabel!
    @IBOutlet weak var followingCount:  UILabel!
    
    var userId : String?
    var isFollow = false
    var pageMenu:CAPSPageMenu?
    // Segment
    
    var listOfVCType : [EscapeType] = [.Activity, .Movie, .TvShows, .Books]
    var listOfTitles = ["Activity", "Movies", "Tv Shows", "Books"]
    
    var lastContentOffsetY:CGFloat = 0.0
    
    private var viewControllers: [CustomListViewController] = []
    var currentDisplayIndex = -1
    
    
    override func setObjectsWithQueryParameters(queryParams: [String : AnyObject]) {
        if let userId = queryParams["user_id"] as? String{
            self.userId = userId
        }
        if let isFollow = queryParams["isFollow"] as? Bool{
            self.isFollow = isFollow
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setVisuals()
        setupViewControllers()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        
        
        if userId == nil{ // means self user
            fetchDataFromRealm()
        }
        
    }
   
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MyAccountDataProvider.sharedDataProvider.myAccountDetailsDelegate = self
        MyAccountDataProvider.sharedDataProvider.getUserDetails(userId)
        
        ScreenVader.sharedVader.hideTabBar(false)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.size.width, height: self.mainScrollView.frame.size.height+self.topView.frame.size.height)
    }
    
    
    func setVisuals(){
        let settingImage = IonIcons.imageWithIcon(ion_ios_settings_strong, size: 22, color: UIColor.themeColorBlack())
        let settingButton : UIBarButtonItem = UIBarButtonItem(image: settingImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MyAccountViewController.settingTapped))
        
        self.navigationItem.rightBarButtonItem = settingButton
        editProfileButton.layer.borderColor = UIColor.textGrayColor().CGColor
        editProfileButton.layer.borderWidth = 1.0
        editProfileButton.layer.cornerRadius = 2.0
        
        if let _ = userId {
            if isFollow {
                editProfileButton.followViewWithAnimate(false)
            } else {
                editProfileButton.unfollowViewWithAnimate(false)
            }
        }
    }
    
    func settingTapped(){
        
        ScreenVader.sharedVader.performScreenManagerAction(.MyAccountSetting, queryParams: nil)
        
    }
    
    func setupViewControllers() {
        
        var listViewControllers:[CustomListViewController] = []
        
        for (index,listType) in listOfVCType.enumerate() {
            
            if let listVC = UIStoryboard(name: "MyAccount", bundle: nil).instantiateViewControllerWithIdentifier("customListVC") as? CustomListViewController {
                listVC.typeOfList = listType
                listVC.userId = userId
                listVC.parentReference = self
                listVC.title = self.listOfTitles[index]
                listViewControllers.append(listVC)
            }
        }
        
        self.viewControllers = listViewControllers
        
        setSelectedViewColor(.Activity)
        
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor.escapeBlueColor()),
            .BottomMenuHairlineColor(UIColor.textGrayColor()),
            .MenuItemFont(UIFont(name: "SFUIDisplay-SemiBold", size: 15.0)!),
            .MenuHeight(45.0),
            .MenuMargin(0.0),
            .MenuItemWidth(self.contentView.frame.width/4),
            .CenterMenuItems(true),
            .SelectedMenuItemLabelColor(UIColor.themeColorBlack()),
            .UnselectedMenuItemLabelColor(UIColor.textGrayColor()),
            .SelectionIndicatorHeight(1.5)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: listViewControllers, frame: CGRectMake(0.0, 0.0, self.contentView.frame.width, self.contentView.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.contentView.addSubview(pageMenu!.view)
        
        pageMenu!.didMoveToParentViewController(self)
    }
    
    func fetchDataFromRealm(){
        
        print("PATH : \(Realm.Configuration.defaultConfiguration.fileURL)")
        
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser{
            
            var data : MyAccountItems?
            data = MyAccountItems(id: user.id, firstName: user.firstName, lastName: user.lastName, email: user.email, gender: Gender(rawValue :user.gender), profilePicture: user.profilePicture, followers: user.following, following: user.following, movies_count: user.movies_count, books_count: user.books_count, tvShows_count: user.tvShows_count, escapes_count: user.escape_count)
            
            fillData(data)
        }
        
    }
    
    func fillData(userData : MyAccountItems?){
        if let firstName = userData?.firstName{
            
            if let lastName = userData?.lastName{
                self.navigationItem.title = "\(firstName) \(lastName)"
            }else{
                self.navigationItem.title = firstName
            }
            
        }
            
        profileImage.downloadImageWithUrl(userData?.profilePicture , placeHolder: UIImage(named: "profile_placeholder"))
        
        
        if let followers = userData?.followers{
            followerCount.text = "\(followers)"
        }
        if let following = userData?.following{
            followingCount.text = "\(following)"
        }
        var count  = 0
        if let movies = userData?.movies_count{
            count = count + Int(movies)
        }
        if let tvshows = userData?.tvShows_count{
            count = count + Int(tvshows)
        }
        if let books = userData?.books_count{
            count = count + Int(books)
        }
         escapeCount.text = "\(count)"
        
    }

    @IBAction func tapGestureAction(sender: UITapGestureRecognizer) {
        
        if let view = sender.view{
            setSelectedViewColor(Tap(rawValue: view.tag))
        }
        
    }
    
    func setSelectedViewColor(view : Tap?){
    
    }
    
    func enableChildScrolls(enable: Bool) {
        for listViewController in self.viewControllers {
            if listViewController.tableView != nil {
                listViewController.tableView.scrollEnabled = enable
            }
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
        
        if let userId = userId{
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

extension MyAccountViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY > lastContentOffsetY {
            if contentOffsetY > (self.topView.frame.size.height-5) {
                enableChildScrolls(true)
            }
        }
        
        lastContentOffsetY = scrollView.contentOffset.y
    }
}

extension MyAccountViewController : MyAccountDetailsProtocol{
    func recievedUserDetails() {
        fetchDataFromRealm()
    }
    func errorUserDetails() {
    }
}
