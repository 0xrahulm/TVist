//
//  FollowFacebookFriendsPopup.swift
//  Escape
//
//  Created by Rahul Meena on 19/04/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class FollowFacebookFriendsPopup: UIViewController {

    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var friendsImageView: UIView!
    
    @IBOutlet weak var image2Width: NSLayoutConstraint!
    @IBOutlet weak var image3Width: NSLayoutConstraint!
    @IBOutlet weak var image4Width: NSLayoutConstraint!
    @IBOutlet weak var image5Width: NSLayoutConstraint!
    
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var followView: UIView!
    
    var storyId : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func seeAllTapped(_ sender: UIButton) {
        openAllUsers()
    }
    
    
    func handleTapGesture(_ sender: UITapGestureRecognizer) {
        openAllUsers()
    }
    
    func openAllUsers(){
        if let storyId = storyId{
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
