//
//  MyAccountViewController.swift
//  Escape
//
//  Created by Ankit on 30/04/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
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
    
    var listOfVCType : [ProfileListType] = [.Activity, .Movie, .TvShows, .Books]
    var listOfTitles = ["Activity", "Movies", "Tv Shows", "Books"]
    
    var lastContentOffsetY:CGFloat = 0.0
    
    fileprivate var viewControllers: [CustomListViewController] = []
    var currentDisplayIndex = -1
    
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
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
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        if userId == nil{ // means self user
            fetchDataFromRealm()
        }
        
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ScreenVader.sharedVader.hideTabBar(false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.size.width, height: self.mainScrollView.frame.size.height+self.topView.frame.size.height)
    }
    
    
    func setVisuals(){
        editProfileButton.layer.borderColor = UIColor.textGrayColor().cgColor
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
        
        for (index,listType) in listOfVCType.enumerated() {
            
            if let listVC = UIStoryboard(name: "MyAccount", bundle: nil).instantiateViewController(withIdentifier: "customListVC") as? CustomListViewController {
                listVC.typeOfList = listType
                listVC.userId = userId
                listVC.parentReference = self
                listVC.title = self.listOfTitles[index]
                listViewControllers.append(listVC)
            }
        }
        
        self.viewControllers = listViewControllers
        
        setSelectedViewColor(.activity)
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.mizzleBlueColor()),
            .bottomMenuHairlineColor(UIColor.textGrayColor()),
            .menuItemFont(UIFont(name: "SFUIDisplay-SemiBold", size: 15.0)!),
            .menuHeight(45.0),
            .menuMargin(0.0),
            .menuItemWidth(self.contentView.frame.width/4),
            .centerMenuItems(true),
            .selectedMenuItemLabelColor(UIColor.themeColorBlack()),
            .unselectedMenuItemLabelColor(UIColor.textGrayColor()),
            .selectionIndicatorHeight(1.5)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: listViewControllers, frame: CGRect(x: 0.0, y: 0.0, width: self.contentView.frame.width, height: self.contentView.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.contentView.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: self)
    }
    
    func fetchDataFromRealm(){
        
        Logger.debug("PATH : \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
        
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser{
            
            var data : MyAccountItems?
            
            data = MyAccountItems(id: user.id, firstName: user.firstName, lastName: user.lastName, email: user.email, gender: Gender(rawValue :user.gender), profilePicture: user.profilePicture, followers: NSNumber(integerLiteral: user.followers), following: NSNumber(integerLiteral: user.following), escapes_count: NSNumber(integerLiteral: user.escape_count))
            
            fillData(data)
        }
        
    }
    
    func fillData(_ userData : MyAccountItems?){
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
        
         escapeCount.text = "0"
        
    }

    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        
        if let view = sender.view{
            setSelectedViewColor(Tap(rawValue: view.tag))
        }
        
    }
    
    func setSelectedViewColor(_ view : Tap?){
    
    }
    
    func enableChildScrolls(_ enable: Bool) {
        for listViewController in self.viewControllers {
            if listViewController.tableView != nil {
                listViewController.tableView.isScrollEnabled = enable
            }
        }
    }
    
    @IBAction func followerFollowingClicked(_ sender: UITapGestureRecognizer) {
        if let view = sender.view{
            
        }
    }
    
    @IBAction func editProfileButtonTapped(_ sender: AnyObject) {
        
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
        }else{
            settingTapped()
        }
    }
    
}

extension MyAccountViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
