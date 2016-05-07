//
//  MyAccountViewController.swift
//  Escape
//
//  Created by Ankit on 30/04/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import ionicons

enum MyAccountSegments : String{
    case Activity = "activity"
    case Movie = "movie"
    case TvShows = "tvshows"
    case Books = "books"
}
enum Tap : Int{
    case Activity = 1
    case Movie = 2
    case TvShows = 3
    case Books = 4
}

class MyAccountViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var escapeCount:     UILabel!
    @IBOutlet weak var followerCount:   UILabel!
    @IBOutlet weak var followingCount:  UILabel!
    
    @IBOutlet weak var movieImage:      UIImageView!
    @IBOutlet weak var activityImage:   UIImageView!
    @IBOutlet weak var booksImage:      UIImageView!
    @IBOutlet weak var tvImage:         UIImageView!
    
    @IBOutlet weak var contentView:     UIView!
    
    @IBOutlet weak var booksView: UIView!
    @IBOutlet weak var tvshowsView: UIView!
    @IBOutlet weak var moviesView: UIView!
    @IBOutlet weak var activityView: UIView!
    // Segment
    
    var listOfVCType : [MyAccountSegments] = [.Activity, .Movie, .TvShows, .Books]
    
    private var viewControllers: [UIViewController] = []
    var currentDisplayIndex = -1
    
    private var activeViewController: UIViewController? {
        didSet {
            changeActiveViewControllerFrom(oldValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setVisuals()
        setupViewControllers()
        
        MyAccountDataProvider.sharedDataProvider.myAccountDetailsDelegate = self
        MyAccountDataProvider.sharedDataProvider.getUserDetails()
        
    }
    
    func setVisuals(){
        let settingImage = IonIcons.imageWithIcon(ion_ios_settings, size: 30, color: UIColor.whiteColor())
        let settingButton : UIBarButtonItem = UIBarButtonItem(image: settingImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MyAccountViewController.settingTapped))
        self.navigationItem.rightBarButtonItem = settingButton
        
        activityImage.image = IonIcons.imageWithIcon(ion_android_clipboard, iconColor: UIColor.themeColorBlue(), iconSize: 25, imageSize: CGSize(width: 25 , height: 25))
        movieImage.image = IonIcons.imageWithIcon(ion_film_marker, iconColor: UIColor.themeColorBlue(), iconSize: 25, imageSize: CGSize(width: 25 , height: 25))
        tvImage.image = IonIcons.imageWithIcon(ion_easel, iconColor: UIColor.themeColorBlue(), iconSize: 25, imageSize: CGSize(width: 25 , height: 25))
        booksImage.image = IonIcons.imageWithIcon(ion_ios_book, iconColor: UIColor.themeColorBlue(), iconSize: 25, imageSize: CGSize(width: 25 , height: 25))
    }
    func settingTapped(){
        
    }
    
    func setupViewControllers() {
        
        var listViewControllers:[CustomListViewController] = []
        
        for listType in listOfVCType {
            
            if let listVC = UIStoryboard(name: "MyAccount", bundle: nil).instantiateViewControllerWithIdentifier("customListVC") as? CustomListViewController {
                listVC.typeOfList = listType
                listViewControllers.append(listVC)
            }
        }
        
        self.viewControllers = listViewControllers
        customSegmentedPageMenu(0)
        setSelectedViewColor(.Activity)
    }
    
    
    private func changeActiveViewControllerFrom(inactiveViewController:UIViewController?) {
        if isViewLoaded() {
            let width = CGRectGetWidth(contentView.frame)
            let height = CGRectGetHeight(contentView.frame)
            
            if let inActiveVC = inactiveViewController {
                inActiveVC.willMoveToParentViewController(nil)
                
                if let activeVC = activeViewController {
                    var offSet = -width
                    if viewControllers.indexOf(activeVC) > viewControllers.indexOf(inActiveVC) {
                        offSet = width
                    }
                    activeVC.view.frame = CGRectMake(offSet, 0, width, height)
                    
                    //disabling segment till animation is completed
                    
                    addChildViewController(activeVC)
                    
                    transitionFromViewController(inActiveVC, toViewController: activeVC, duration: 0.2, options: UIViewAnimationOptions.AllowAnimatedContent,
                                                 animations: { [unowned self] () -> Void in
                                                    inActiveVC.view.frame = CGRectMake(-offSet, 0, width, height)
                                                    inActiveVC.view.alpha = 0
                                                    activeVC.view.frame   = self.contentView.bounds
                        }, completion: { [unowned self] (finished) -> Void in
                            activeVC.didMoveToParentViewController(self)
                        })
                    
                        activeVC.view.visibleWithAnimationDuration(0.15)
                }
                
            } else {
                
                if let activeVC = activeViewController {
                    addChildViewController(activeVC)
                    activeVC.view.frame = self.contentView.bounds
                    self.contentView.addSubview(activeVC.view)
                    activeVC.didMoveToParentViewController(self)
                    activeVC.view.visibleWithAnimationDuration(0.15)
                }
            }
            
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
        if let profilePic = userData?.profilePicture{
            
            profileImage.downloadImageWithUrl(profilePic)
            
            
        }
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
    
    func customSegmentedPageMenu(selectedIndex: Int) {
        if currentDisplayIndex != selectedIndex {
            currentDisplayIndex  = selectedIndex
            activeViewController = viewControllers[selectedIndex]
        }
    }

    @IBAction func tapGestureAction(sender: UITapGestureRecognizer) {
        
        if let view = sender.view{
            setSelectedViewColor(Tap(rawValue: view.tag))
            customSegmentedPageMenu(view.tag - 1)
        }
        
    }
    func setSelectedViewColor(view : Tap?){
        
        var activityColor = UIColor.whiteColor()
        var movieColor = UIColor.whiteColor()
        var tvShowColor = UIColor.whiteColor()
        var booksColor = UIColor.whiteColor()
        
        if view == .Activity{
            activityColor = UIColor.viewSelectedColor()
        }else if view == .Movie{
            movieColor  = UIColor.viewSelectedColor()
        }else if view == .TvShows{
            tvShowColor = UIColor.viewSelectedColor()
        }else if view == .Books{
            booksColor = UIColor.viewSelectedColor()
        }
        
        activityView.backgroundColor = activityColor
        moviesView.backgroundColor = movieColor
        tvshowsView.backgroundColor = tvShowColor
        booksView.backgroundColor = booksColor
    
    }
}
extension MyAccountViewController : MyAccountDetailsProtocol{
    func recievedUserDetails(data: MyAccountItems?) {
        
        fillData(data)
        
    }
    func errorUserDetails() {
        
    }
}
