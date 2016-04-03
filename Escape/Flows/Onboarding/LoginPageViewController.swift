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

    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    private let contentImages = ["page1",
                                 "page1",
                                 "page1"];
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFbLogin()

        // Do any additional setup after loading the view.
    }
    
    func configureFbLogin(){
        fbLoginButton.readPermissions = ["user_likes" , "user_friends" , "public_profile"]
        fbLoginButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fbLoginTapped(sender: AnyObject) {
    
    }

    

}
extension LoginPageViewController : FBSDKLoginButtonDelegate{
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        if let token = FBSDKAccessToken.currentAccessToken().tokenString{
            
            let expires_in = FBSDKAccessToken.currentAccessToken().expirationDate.timeIntervalSince1970
            
            UserDataProvider.sharedDataProvider.postFBtoken(token , expires_in: expires_in)
            
        }else{
            // show some error popup
        }
    
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        ECUserDefaults.setLoggedIn(false)
        
    }
    
}




