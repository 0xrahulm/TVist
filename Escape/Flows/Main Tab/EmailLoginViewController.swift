//
//  EmailLoginViewController.swift
//  Escape
//
//  Created by Ankit on 26/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class EmailLoginViewController: UIViewController {

    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var signUpView: UIView!
    
    @IBOutlet weak var fullNameSignUp: UITextField!
    @IBOutlet weak var emailSignUp: UITextField!
    @IBOutlet weak var passwordSignUp: UITextField!
    
    @IBOutlet weak var emailSignIn: UITextField!
    @IBOutlet weak var passwordSignIn: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDataProvider.sharedDataProvider.emailLoginDelegate = self
        UserDataProvider.sharedDataProvider.fbLoginDelegate = self
            
    }
    
    func loadErrorPopUp(str : String){
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        
        alert.view.tintColor = UIColor.themeColorRed()
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentChanged(sender: AnyObject) {
        
        switch segmentController.selectedSegmentIndex {
        case 0 :
            signInView.hidden = false
            signUpView.hidden = true
            break
        case 1:
            signInView.hidden = true
            signUpView.hidden = false
            break
        default:
            break
        }
    }
    
    @IBAction func signUpDone(sender: AnyObject) {
        
        if fullNameSignUp.text == "" {
            
            loadErrorPopUp("Please enter your full name")
            return
        }
        if emailSignUp.text == "" {
            loadErrorPopUp("Please enter your email address")
            return
        }
        if passwordSignUp.text == ""{
            loadErrorPopUp("Please set your password")
            return
        }
        
        if let fullName = fullNameSignUp.text{
            if let email = emailSignUp.text {
                if let password = passwordSignUp.text {
                    
                    if !OnBoardingUtility.isValidEmail(email){
                        loadErrorPopUp("Please Enter Valid Email address")
                        return
                    }
                    if !OnBoardingUtility.isValidPassword(password){
                        loadErrorPopUp("Password should be atleast 6 characters")
                        return
                    }
                    
                    UserDataProvider.sharedDataProvider.registerUserWithEmail(fullName, email: email, password: password)
                    
                }
            }
            
        }
    }
    
    @IBAction func signInDone(sender: AnyObject) {
        
        if emailSignIn.text == "" {
            loadErrorPopUp("Enter your email address")
            return
        }
        if passwordSignIn.text == ""{
            loadErrorPopUp("Enter your password")
            return
        }
        if let email = emailSignIn.text{
            if let password = passwordSignIn.text{
                
                UserDataProvider.sharedDataProvider.signInWithEmail(email, password: password)
                
            }
        }
    }
    
    @IBAction func fbLoginTapped(sender: AnyObject) {
        
        let fbLoginManager : FBSDKLoginManager =  FBSDKLoginManager()
        let fbPermission = ["user_likes" , "user_friends" , "public_profile"]
        
        fbLoginManager.logInWithReadPermissions(fbPermission, fromViewController: self) { (result, error) in
            if error == nil{
                
                let fbLoginResult : FBSDKLoginManagerLoginResult = result
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
    func openInteresetVC(){
       
        performSegueWithIdentifier("showInterestSegue", sender: self)

    }
    
}
extension EmailLoginViewController : LoginProtocol{
    
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
        
        if type == .Email{
            openInteresetVC()
        }else if type == .Facebook{
            ScreenVader.sharedVader.performScreenManagerAction(.MainTab, queryParams: nil)
        }
  
    }
    
}