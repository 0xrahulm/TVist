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
    
    private let onBoardingImages = ["page1",
                                    "page1",
                                    "page1"];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDataProvider.sharedDataProvider.fbLoginDelegate = self
        
        setVisuals()
        
        // Do any additional setup after loading the view.
    }
    
    func setVisuals(){
        
        setPageViewController()
        setPageDots()
        setFBbutton()
        setEmailButton()
        
    }
    
    func setPageViewController(){
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewVC") as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        let startingVC = self.viewControllerAtIndex(0) as! PageContentViewController
        let VCs = [startingVC]
        self.pageViewController.setViewControllers(VCs, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        
    }
    func setPageDots(){
        
        self.pageController = UIPageControl(
            frame: CGRect(
                x: 0,
                y: self.view.frame.size.height - 150,
                width: self.view.frame.size.width,
                height: 10
            )
        )
        self.pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
        self.pageController.currentPageIndicatorTintColor = UIColor.whiteColor()
        self.pageController.numberOfPages = onBoardingImages.count
        
        self.view.addSubview(pageController)
        
    }
    func setFBbutton(){
        
        let button   = UIButton(type: UIButtonType.System) as UIButton!
        button.frame = CGRectMake(20, self.view.frame.height - 120, CGRectGetWidth(view.frame) - 40, 50)
        button.backgroundColor = UIColor.fbThemeColor()
        button.setTitle("Continue with facebook", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(LoginPageViewController.fbLoginButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
        
    }
    
    func setEmailButton(){
        
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(20, self.view.frame.height - 65, CGRectGetWidth(view.frame) - 40, 50)
        
        //button.setBackgroundImage(UIImage(named: "menu.png"), forState: UIControlState.Normal)
        
        button.setTitle("Continue with email", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(LoginPageViewController.emailLoginButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
    }
    
    
    func viewControllerAtIndex(index : Int) -> UIViewController?{
        
        if self.onBoardingImages.count == 0 || index > self.onBoardingImages.count{
            return nil
        }
        let pageContentVC = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentVC") as! PageContentViewController
        
        pageContentVC.imageFile = self.onBoardingImages[index]
        pageContentVC.pageIndex = index
        return pageContentVC
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fbLoginButtonTapped(){
        
        
        let fbLoginManager : FBSDKLoginManager =  FBSDKLoginManager()
        let fbPermission = ["user_likes" , "user_friends" , "public_profile" , "email"]
        
        fbLoginManager.logInWithReadPermissions(fbPermission, fromViewController: self) { (result, error) in
            if error == nil{
                
                let fbLoginResult : FBSDKLoginManagerLoginResult = result
                if let _ = fbLoginResult.grantedPermissions{
                    if fbLoginResult.grantedPermissions.contains("public_profile"){
                        
                        if let token = FBSDKAccessToken.currentAccessToken(){
                            
                            if let tokenString = token.tokenString{
                                
                                let expires_in = token.expirationDate.timeIntervalSince1970
                                
                                UserDataProvider.sharedDataProvider.postFBtoken(tokenString, expires_in: expires_in)
                                
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    func emailLoginButtonTapped(){
        
        
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("EmailLoginVC") as! EmailLoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func loadErrorPopUp(str : String){
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        
        alert.view.tintColor = UIColor.themeColorRed()
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension LoginPageViewController : LoginProtocol{
    
    func signInError(data : AnyObject?){
        
        if let data = data as? [String:AnyObject]{
            
            if let error = data["error"] as? String{
                self.loadErrorPopUp(error)
            }
            
        }else{
            self.loadErrorPopUp("Something went wrong, please try after some time")
        }
        
    }
    
    func signInSuccessfull(data : [String:AnyObject] , type : LoginTypeEnum){
      
        if type == .Facebook{
            ScreenVader.sharedVader.performScreenManagerAction(.MainTab, queryParams: nil)
        }
        
    }
}

extension LoginPageViewController : UIPageViewControllerDelegate{
    
}

extension LoginPageViewController : UIPageViewControllerDataSource{
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?{
        
        let vc =    viewController as! PageContentViewController
        if var index = vc.pageIndex{
            if index != 0 {
                index = index - 1
                return self.viewControllerAtIndex(index)
                
            }
        }
        return nil
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?{
        
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
        pageViewController: UIPageViewController,
        willTransitionToViewControllers pendingViewControllers:[UIViewController]){
        if let itemController = pendingViewControllers[0] as? PageContentViewController {
            
            if let index = itemController.pageIndex{
                self.pageController.currentPage = index
            }
            
        }
    }
    
    
}




