//
//  MyAccountSettingViewController.swift
//  Escape
//
//  Created by Ankit on 15/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class MyAccountSettingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let dataArray = ["Connected Accounts" , "Add Interests" , "Logout"]

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
        cell.textLabel?.text = dataArray[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataArray[indexPath.row] == "Logout"{
            MyAccountDataProvider.sharedDataProvider.logoutUser()
        }
    }
}
