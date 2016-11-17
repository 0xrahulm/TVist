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
    
    
    @IBOutlet weak var fullNameSignUp: HighlightableTextView!
    @IBOutlet weak var emailSignUp: HighlightableTextView!
    @IBOutlet weak var passwordSignUp: HighlightableTextView!
    
    @IBOutlet weak var emailSignIn: HighlightableTextView!
    @IBOutlet weak var passwordSignIn: HighlightableTextView!
    
    @IBOutlet weak var signUpSceneWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInSceneWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signUpSceneXConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInSceneXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var doneButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var doneButton:CustomDoneButton!
    
    let defaultMarginForViews:CGFloat = 15
    
    enum SegmentTab:Int {
        case SignUp=0, SignIn=1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialVisualSetup()
        
        UserDataProvider.sharedDataProvider.emailLoginDelegate = self
        UserDataProvider.sharedDataProvider.fbLoginDelegate = self
        
        self.fullNameSignUp.delegate = self
        self.emailSignUp.delegate = self
        self.passwordSignUp.delegate = self
        
        self.emailSignIn.delegate = self
        self.passwordSignIn.delegate = self
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EmailLoginViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EmailLoginViewController.keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func loadErrorPopUp(str : String){
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        alert.view.tintColor = UIColor.escapeRedColor()
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func initialVisualSetup() {
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        setNeedsStatusBarAppearanceUpdate()
        
        doneButton.enableButton = false
        
        let defaultMarginDifference = defaultMarginForViews*2
        signInSceneWidthConstraint.constant = UIScreen.mainScreen().bounds.width - defaultMarginDifference
        signUpSceneWidthConstraint.constant = UIScreen.mainScreen().bounds.width - defaultMarginDifference
        
        self.view.layoutIfNeeded()
    }
    
    @IBAction func segmentChanged(sender: AnyObject) {
        
        if segmentController.selectedSegmentIndex == SegmentTab.SignUp.rawValue {
            self.signUpSceneXConstraint.constant = 0
            self.signInSceneXConstraint.constant = 600
            
            determineSignUpButtonState()
        }
        
        if segmentController.selectedSegmentIndex == SegmentTab.SignIn.rawValue {
            self.signInSceneXConstraint.constant = 0
            self.signUpSceneXConstraint.constant = -600
            
            determineSignInButtonState()
        }
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                doneButtonChangeBottomConstantWithAnimation(keyboardFrame.CGRectValue().height)
            }
        }
        
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        doneButtonChangeBottomConstantWithAnimation(0)
    }
    
    func doneButtonChangeBottomConstantWithAnimation(constant: CGFloat) {
        doneButtonBottomConstraint.constant = constant
        layoutWithAnimation()
    }
    
    func layoutWithAnimation() {
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @IBAction func doneButtonTappedWithSender(sender: AnyObject) {
        
        if segmentController.selectedSegmentIndex == SegmentTab.SignUp.rawValue {
            
            
            if fullNameSignUp.textField.text == "" {
                loadErrorPopUp("Please enter your full name")
                return
            }
            if emailSignUp.textField.text == "" {
                loadErrorPopUp("Please enter your email address")
                return
            }
            if passwordSignUp.textField.text == ""{
                loadErrorPopUp("Please set your password")
                return
            }
            
            if let fullName = fullNameSignUp.textField.text, let email = emailSignUp.textField.text, let password = passwordSignUp.textField.text  {
                
                if !OnBoardingUtility.isValidEmail(email){
                    loadErrorPopUp("Please Enter Valid Email address")
                    return
                }
                if !OnBoardingUtility.isValidPassword(password){
                    loadErrorPopUp("Password should be atleast 6 characters")
                    return
                }
                
                doneButton.loading = true
                UserDataProvider.sharedDataProvider.registerUserWithEmail(fullName, email: email, password: password)
                
            }
        }
        
        
        if segmentController.selectedSegmentIndex == SegmentTab.SignIn.rawValue {
            
            if emailSignIn.textField.text == "" {
                loadErrorPopUp("Enter your email address")
                return
            }
            if passwordSignIn.textField.text == ""{
                loadErrorPopUp("Enter your password")
                return
            }
            
            if let email = emailSignIn.textField.text, let password = passwordSignIn.textField.text {
                doneButton.loading = true
                UserDataProvider.sharedDataProvider.signInWithEmail(email, password: password)
            }
        }
    }
    
    @IBAction func fbLoginTapped(sender: AnyObject) {
        
        let fbLoginManager : FBSDKLoginManager =  FBSDKLoginManager()
        let fbPermission = ["user_likes" , "user_friends" , "public_profile" , "email"]
        
        fbLoginManager.logInWithReadPermissions(fbPermission, fromViewController: self) { (result, error) in
            if error == nil{
                
                let fbLoginResult : FBSDKLoginManagerLoginResult = result
                if let _ = fbLoginResult.grantedPermissions {
                    if fbLoginResult.grantedPermissions.contains("public_profile"){
                        
                        if let token = FBSDKAccessToken.currentAccessToken(){
                            
                            if let tokenString = token.tokenString {
                                
                                let expires_in = token.expirationDate.timeIntervalSince1970
                                
                                UserDataProvider.sharedDataProvider.postFBtoken(tokenString, expires_in: expires_in)
                                
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    func determineSignUpButtonState() {
        if self.fullNameSignUp.textField.text?.characters.count > 0 && self.emailSignUp.textField.text?.characters.count > 0 && self.passwordSignUp.textField.text?.characters.count > 0 {
            doneButton.enableButton = true
        } else {
            doneButton.enableButton = false
        }
    }
    
    func determineSignInButtonState() {
        if self.emailSignIn.textField.text?.characters.count > 0 && self.passwordSignIn.textField.text?.characters.count > 0 {
            doneButton.enableButton = true
        } else {
            doneButton.enableButton = false
        }
    }
    
    func openInteresetVC(){
        performSegueWithIdentifier("showInterestSegue", sender: self)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
}

extension EmailLoginViewController: HighlightableTextViewProtocol {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if segmentController.selectedSegmentIndex == SegmentTab.SignUp.rawValue {
            determineSignUpButtonState()
        }
        
        
        if segmentController.selectedSegmentIndex == SegmentTab.SignIn.rawValue {
            determineSignInButtonState()
        }
        
        return true
    }
}

extension EmailLoginViewController : LoginProtocol {
    
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
        
        if type == .Email {
            openInteresetVC()
        } else if type == .Facebook {
            ScreenVader.sharedVader.performScreenManagerAction(.MainTab, queryParams: nil)
        }
        
    }
}
