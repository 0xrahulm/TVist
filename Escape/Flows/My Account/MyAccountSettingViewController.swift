//
//  MyAccountSettingViewController.swift
//  Escape
//
//  Created by Ankit on 15/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
enum settingOptions : String{
    case EditProfile = "Edit Profile Picture"
    case Logout = "Logout"
}

class MyAccountSettingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let dataArray : [settingOptions] = [.EditProfile ,.Logout]

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension MyAccountSettingViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = dataArray[indexPath.row].rawValue
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataArray[indexPath.row] == .Logout{
            MyAccountDataProvider.sharedDataProvider.logoutUser()
        }else if dataArray[indexPath.row] == .EditProfile{
        }
    }
}
