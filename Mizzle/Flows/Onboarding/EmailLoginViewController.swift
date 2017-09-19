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
    
    
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var signUpView: UIView!
    
    @IBOutlet weak var signInTabButton: UIButton!
    @IBOutlet weak var signUpTabButton: UIButton!
    
    
    @IBOutlet weak var doneButton: CustomDoneButton!
    
    @IBOutlet weak var fullNameSignUp: HighlightableTextView!
    @IBOutlet weak var emailSignUp: HighlightableTextView!
    @IBOutlet weak var passwordSignUp: HighlightableTextView!
    
    @IBOutlet weak var emailSignIn: HighlightableTextView!
    @IBOutlet weak var passwordSignIn: HighlightableTextView!
    
    let defaultMarginForViews:CGFloat = 15
    
    var emailSignInDefault: String?
    
    var screen: String = "original"
    
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
        
        if let emailSignInDefault = emailSignInDefault {
            signInViewVisible()
            self.signInTabButton.isSelected = true
            self.signUpTabButton.isSelected = false
            
            self.emailSignIn.textField.text = emailSignInDefault
            self.passwordSignIn.textField.becomeFirstResponder()
        } else {
            signUpViewVisible()
            self.signInTabButton.isSelected = false
            self.signUpTabButton.isSelected = true
        }
        
        
        if screen == "popup" {
            self.title = "Authenticate"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(EmailLoginViewController.closeButton))
        }
        
    }
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        if let screen = queryParams["screen"] as? String {
            self.screen = screen
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(EmailLoginViewController.keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(EmailLoginViewController.keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func closeButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func loadErrorPopUp(_ str : String){
        
        AnalyticsVader.sharedVader.emailLoginIssue(reason: str)
        
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        alert.view.tintColor = UIColor.escapeRedColor()
        self.present(alert, animated: true, completion: nil)
    }
    
    func initialVisualSetup() {
        
        setNeedsStatusBarAppearanceUpdate()
        
        doneButton.enableButton = false
        
    }
    
    func signUpViewVisible() {
        doneButton.setTitle("Sign up", for: .normal)
        self.signUpView.isHidden = false
        self.signInView.isHidden = true
    }
    
    func signInViewVisible() {
        doneButton.setTitle("Log in", for: .normal)
        self.signUpView.isHidden = true
        self.signInView.isHidden = false
    }
    
    @IBAction func tabButtonTapped(_ sender: UIButton) {
        self.signInTabButton.isSelected = false
        self.signUpTabButton.isSelected = false
        
        sender.isSelected = true
        
        if self.signUpTabButton.isSelected {
            
            signUpViewVisible()
            var str = ""
            if let passwordText = self.passwordSignUp.textField.text {
                str = passwordText
            }
            determineSignUpButtonState(newString: str)
            AnalyticsVader.sharedVader.basicEvents(eventName: .signUpTabClick)
        }
        
        if self.signInTabButton.isSelected {
            signInViewVisible()
            var str = ""
            if let passwordText = self.passwordSignIn.textField.text {
                str = passwordText
            }
            determineSignInButtonState(newString: str)
            AnalyticsVader.sharedVader.basicEvents(eventName: .signInTabClick)
        }
    }
    
    func keyboardWillAppear(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                doneButtonChangeBottomConstantWithAnimation(keyboardFrame.cgRectValue.height)
            }
        }
        
    }
    
    func keyboardWillDisappear(_ notification: Notification) {
        doneButtonChangeBottomConstantWithAnimation(0)
    }
    
    func doneButtonChangeBottomConstantWithAnimation(_ constant: CGFloat) {
        
    }
    
    func layoutWithAnimation() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @IBAction func doneButtonTappedWithSender(_ sender: AnyObject) {
        
        
        
        if self.signUpTabButton.isSelected {
            
            AnalyticsVader.sharedVader.basicEvents(eventName: .doneButtonOnEmailSignup)
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
                
                doneButton.isLoading = true
                UserDataProvider.sharedDataProvider.registerUserWithEmail(fullName, email: email, password: password)
                
            }
        }
        
        
        if self.signInTabButton.isSelected {
            AnalyticsVader.sharedVader.basicEvents(eventName: .doneButtonOnEmailLogin)
            if emailSignIn.textField.text == "" {
                loadErrorPopUp("Enter your email address")
                return
            }
            if passwordSignIn.textField.text == ""{
                loadErrorPopUp("Enter your password")
                return
            }
            
            if let email = emailSignIn.textField.text, let password = passwordSignIn.textField.text {
                doneButton.isLoading = true
                UserDataProvider.sharedDataProvider.signInWithEmail(email, password: password)
            }
        }
    }
    
    @IBAction func fbLoginTapped(_ sender: AnyObject) {
        
        AnalyticsVader.sharedVader.continueWtihFBTapped(screenName: "Email")
        
        let fbLoginManager : FBSDKLoginManager =  FBSDKLoginManager()
        let fbPermission = ["user_likes" , "user_friends" , "public_profile" , "email"]
        
        fbLoginManager.logIn(withReadPermissions: fbPermission, from: self) { (result, error) in
            if error == nil{
                guard let result = result else {
                    return
                }
                let fbLoginResult : FBSDKLoginManagerLoginResult = result
                if fbLoginResult.isCancelled {
                    AnalyticsVader.sharedVader.fbLoginFailure(reason: "User Cancelled")
                }
                if let _ = fbLoginResult.grantedPermissions {
                    if fbLoginResult.grantedPermissions.contains("public_profile"){
                        
                        if let token = FBSDKAccessToken.current(){
                            
                            if let tokenString = token.tokenString {
                                
                                let expires_in = token.expirationDate.timeIntervalSince1970
                                
                                UserDataProvider.sharedDataProvider.postFBtoken(tokenString, expires_in: expires_in)
                                
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
    
    func determineSignUpButtonState(newString: String) {
        if let fullNameText = self.fullNameSignUp.textField.text, let emailSignUpText = self.emailSignUp.textField.text {
            
            if fullNameText.characters.count > 0 && emailSignUpText.characters.count > 0 && newString.characters.count > 0 {
                doneButton.enableButton = true
            } else {
                doneButton.enableButton = false
            }
        }
    }
    
    func determineSignInButtonState(newString: String) {
        if let emailSignInText = self.emailSignIn.textField.text {
            
            if emailSignInText.characters.count > 0 && newString.characters.count > 0 {
                doneButton.enableButton = true
            } else {
                doneButton.enableButton = false
            }
        }
    }
    
    func openInteresetVC(){
        performSegue(withIdentifier: "showInterestSegue", sender: self)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if UI_USER_INTERFACE_IDIOM() == .phone {
            return .lightContent
        }
        
        return .default
    }
}

extension EmailLoginViewController: HighlightableTextViewProtocol {
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if self.signUpTabButton.isSelected {
            determineSignUpButtonState(newString: txtAfterUpdate)
        }
        
        
        if self.signInTabButton.isSelected {
            determineSignInButtonState(newString: txtAfterUpdate)
        }
        
        return true
    }
}

extension EmailLoginViewController : LoginProtocol {
    
    func signInError(_ data : Any?){
        
        if let data = data as? [String:Any]{
            
            if let error = data["error"] as? String{
                self.loadErrorPopUp(error)
            }
            
        }else{
            self.loadErrorPopUp("Something went wrong, please try after some time")
        }
        self.doneButton.isLoading = false
        self.doneButton.isEnabled = true
    }
    
    func signInSuccessfull(_ data : [String:AnyObject] , type : LoginTypeEnum, subServiceType: SubServiceType){
        
        if type == .Email && subServiceType == .EmailSignUp {
//            openInteresetVC()
//            return
        }
        ScreenVader.sharedVader.loginActionAfterDelay()
        
    }
}
