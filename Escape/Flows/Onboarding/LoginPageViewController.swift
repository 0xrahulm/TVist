//
//  LoginPageViewController.swift
//  Escape
//
//  Created by Ankit on 25/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LoginPageViewController: UIViewController {
    
    var pageViewController : UIPageViewController!
    var pageController : UIPageControl!
    
    fileprivate let onBoardingImages:[String] = ["Promo_4", "Promo_1",
                                        "Promo_2"];
    
    let onboardingStrings:[String] = ["Share your favourites with friends & followers", "Beautifully organise your favourite Movies, Tv Shows & Books", "Discover new Movies, Tv Shows & Books specific to your taste"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDataProvider.sharedDataProvider.fbLoginDelegate = self
        
        setVisuals()
        setNeedsStatusBarAppearanceUpdate()
        
        self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.layoutIfNeeded()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (ECUserDefaults.isLoggedIn() &&
            !LocalStorageVader.sharedVader.flagValueForKey(.InterestsSelected)) {
            openInteresetVC()
        }
        
        AnalyticsVader.sharedVader.onboardingStarted()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AnalyticsVader.sharedVader.onboardingFinished()
    }
    
    
    func openInteresetVC(){
        performSegue(withIdentifier: "showInterestsSegue", sender: self)
    }
    
    func setVisuals(){
        
        setPageViewController()
        setPageDots()
        setFBbutton()
        setEmailButton()
        
        
    }
    
    func setPageViewController() {
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewVC") as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        
        if let startingVC = self.viewControllerAtIndex(0) {
            let VCs:[PageContentViewController] = [startingVC]
            self.pageViewController.setViewControllers(VCs, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height);
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        
    }
    func setPageDots(){
        
        self.pageController = UIPageControl(
            frame: CGRect(
                x: 0,
                y: self.view.frame.size.height - 125,
                width: self.view.frame.size.width,
                height: 10
            )
        )
        self.pageController.pageIndicatorTintColor = UIColor.lineGrayColor().withAlphaComponent(0.5)
        self.pageController.currentPageIndicatorTintColor = UIColor.white
        self.pageController.numberOfPages = onBoardingImages.count
        
        self.view.addSubview(pageController)
        
    }
    func setFBbutton(){
        
        let button   = UIButton(type: UIButtonType.system)
        let buttonWidth = view.frame.width - 40
        button.frame = CGRect(x: 20, y: self.view.frame.height - 105, width: buttonWidth, height: 50)
        button.backgroundColor = UIColor.fbThemeColor()
        button.setTitle("Continue with facebook", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.setImage(UIImage(named: "fb_white_icon"), for: UIControlState())
        button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 4
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 2.5, left: buttonWidth/2-100, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(LoginPageViewController.fbLoginButtonTapped), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(button)
        
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func setEmailButton(){
        
        let button   = UIButton(type: UIButtonType.system) as UIButton
        button.frame = CGRect(x: 20, y: self.view.frame.height - 55, width: view.frame.width - 40, height: 50)
        
        //button.setBackgroundImage(UIImage(named: "menu.png"), forState: UIControlState.Normal)
        
        button.setTitle("Continue with email", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.addTarget(self, action: #selector(LoginPageViewController.emailLoginButtonTapped), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
        
    }
    
    
    func viewControllerAtIndex(_ index : Int) -> PageContentViewController? {
        
        if self.onBoardingImages.count == 0 || index > self.onBoardingImages.count{
            return nil
        }
        let pageContentVC = self.storyboard?.instantiateViewController(withIdentifier: "PageContentVC") as! PageContentViewController
        
        pageContentVC.imageFile = self.onBoardingImages[index]
        pageContentVC.text = self.onboardingStrings[index]
        pageContentVC.pageIndex = index
        return pageContentVC
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fbLoginButtonTapped(){
        
        AnalyticsVader.sharedVader.continueWtihFBTapped(screenName: "Carousel")
        let fbLoginManager : FBSDKLoginManager =  FBSDKLoginManager()
        fbLoginManager.loginBehavior = .systemAccount
        let fbPermission = ["user_likes" , "user_friends" , "public_profile" , "email"]
        
        fbLoginManager.logIn(withReadPermissions: fbPermission, from: self) { (result, error) in
            if error == nil{
                
                if let fbLoginResult = result {
                    if fbLoginResult.isCancelled {
                        AnalyticsVader.sharedVader.fbLoginFailure(reason: "User Cancelled")
                    }
                    if let _ = fbLoginResult.grantedPermissions{
                        if fbLoginResult.grantedPermissions.contains("public_profile"){
                            
                            if let token = FBSDKAccessToken.current(){
                                
                                if let tokenString = token.tokenString{
                                    
                                    let expires_in = token.expirationDate.timeIntervalSince1970
                                    
                                    UserDataProvider.sharedDataProvider.postFBtoken(tokenString, expires_in: expires_in)
                                    
                                }
                                
                            }
                        }
                        
                    }
                }
                
            } else {
                if let error = error {
                    AnalyticsVader.sharedVader.fbLoginFailure(reason: error.localizedDescription)
                }
            }
        }
    }
    
    func emailLoginButtonTapped(){
        
        AnalyticsVader.sharedVader.basicEvents(eventName: .continueWithEmail)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func loadErrorPopUp(_ str : String){
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        AnalyticsVader.sharedVader.fbLoginFailure(reason: str)
        
        alert.view.tintColor = UIColor.escapeRedColor()
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginPageViewController : LoginProtocol{
    func signInSuccessfull(_ data: [String : AnyObject], type: LoginTypeEnum, subServiceType: SubServiceType) {
        
        if type == .Facebook{
            ScreenVader.sharedVader.loginActionAfterDelay()
        }
    }

    func signInError(_ data: Any?) {
        
        if let data = data as? [String:Any]{
            
            if let error = data["error"] as? String{
                self.loadErrorPopUp(error)
            }
            
        }else{
            self.loadErrorPopUp("Something went wrong, please try after some time")
        }
    }
}

extension LoginPageViewController : UIPageViewControllerDelegate{
    
}

extension LoginPageViewController : UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        
        let vc =    viewController as! PageContentViewController
        if var index = vc.pageIndex{
            if index != 0 {
                index = index - 1
                return self.viewControllerAtIndex(index)
                
            }
        }
        return nil
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return onBoardingImages.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        
        let vc = viewController as! PageContentViewController
        if var index = vc.pageIndex{
            index = index + 1
            if index == self.onBoardingImages.count{
                return nil
            }
            return self.viewControllerAtIndex(index)
        }
        return nil
        
    }
    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers:[UIViewController]){
        if let itemController = pendingViewControllers[0] as? PageContentViewController {
            
            if let index = itemController.pageIndex{
                self.pageController.currentPage = index
            }
            
        }
    }
    
    
}




