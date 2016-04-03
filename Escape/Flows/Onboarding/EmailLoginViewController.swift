//
//  EmailLoginViewController.swift
//  Escape
//
//  Created by Ankit on 26/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

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
                    
                    if !isValidEmail(email){
                        loadErrorPopUp("Please Enter Valid Email address")
                        return
                    }
                    if !isValidPassword(password){
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
    

}
extension EmailLoginViewController : EmailLoginProtocol{
    
    
    func signInError(data : AnyObject?){
       
        ECUserDefaults.setLoggedIn(false)
        
        if let data = data as? [String:AnyObject]{
            
            if let error = data["error"] as? String{
                self.loadErrorPopUp(error)
            }
            
        }else{
            self.loadErrorPopUp("Something went wrong, please try after some time")
        }
        
    }
    func signInSuccessfull(data : [String:AnyObject]){
        
        ScreenVader.sharedVader.performScreenManagerAction(.MainTab, queryParams: nil)
        
        
    }
    
}
extension EmailLoginViewController{
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    func isValidPassword(password : String) -> Bool{
        if password.characters.count >= 6 {
            return true
        }
        return false
    }
    func loadErrorPopUp(str : String){
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        
        alert.view.tintColor = UIColor.themeColorRed()
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
