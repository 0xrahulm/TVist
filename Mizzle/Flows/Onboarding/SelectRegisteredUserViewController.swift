//
//  SelectRegisteredUserViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 20/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class SelectRegisteredUserViewController: GenericListViewController {
    
    var listItems:[MyAccountItems] = []
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let prefillItems = queryParams["prefillItems"] as? [MyAccountItems], prefillItems.count > 0 {
            listItems = prefillItems
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Registered Users"
        listItems.append(contentsOf: UserDataProvider.sharedDataProvider.temporaryStoredUsers)
        
        // Create new user item
        
        let createNewItem = MyAccountItems(id: nil, firstName: "Create", lastName: "new", email: nil, gender: nil, profilePicture: nil, followers: 0, following: 0, escapes_count: 0)
        createNewItem.loggedInUsing = .Guest
        listItems.append(createNewItem)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func listCount() -> Int {
        return listItems.count
    }
    
    override func listItemAtIndexPath(_ indexPath: IndexPath) -> NormalCell {
        
        let peopleItem = listItems[indexPath.row]
        
        let peopleCell = tableView.dequeueReusableCell(withIdentifier: GenericCellIdentifier.PeopleCell.rawValue, for: indexPath) as! PeopleCell
        peopleCell.loggable = true
        peopleCell.accountItem = peopleItem
        peopleCell.selectionStyle = .none
        
        return peopleCell
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if listItems.count > indexPath.row {
            
            
            let data = listItems[indexPath.row]
            
            if data.loggedInUsing == .Facebook {
                fbLoginButtonTapped()
            } else {
                emailLoginButtonTapped(data: data)
            }
            
        }
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
                                    
                                    UserDataProvider.sharedDataProvider.fbLoginDelegate = self
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
    
    func emailLoginButtonTapped(data: MyAccountItems){
        
        AnalyticsVader.sharedVader.basicEvents(eventName: .continueWithEmail)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginViewController
        vc.emailSignInDefault = data.email
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



extension SelectRegisteredUserViewController : LoginProtocol{
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
