//
//  MasterHeaderView.swift
//  TVist
//
//  Created by Rahul Meena on 10/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

protocol MasterHeaderViewProtocol: class {
    func didTapLeftNavButton()
}

class MasterHeaderView: UIView {
    
    @IBOutlet weak var largeTitleLabel: UILabel!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var resizerButton: UIButton!
    
    weak var delegate: MasterHeaderViewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headerTitleLabel.isHidden = true
        self.resizerButton.isHidden = true
        
    }
    
    func setMasterHeaderViewWithTitle(title: String) {
        self.largeTitleLabel.text = title
        self.headerTitleLabel.text = title
    }
    
    func setUserProfileBackButton() {
        self.leftView.isHidden = false
        self.resizerButton.isHidden = true
        
        setupUserProfileImage()
        
            
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MasterHeaderView.didTapOnLeftNavigationButton))
        self.leftView.addGestureRecognizer(tapGesture)
        
    }
    
    func didTapOnLeftNavigationButton() {
        if let delegate = delegate {
            delegate.didTapLeftNavButton()
        }
    }
    
    func setResizerButton(displayModeButton: UIBarButtonItem) {
        self.leftView.isHidden = true
        self.resizerButton.isHidden = false
        
        if let action = displayModeButton.action {
            self.resizerButton.addTarget(displayModeButton.target, action: action, for: .touchUpInside)
        }
    }
    
    func setupUserProfileImage() {
        
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
            userProfileImageView.downloadImageWithUrl(user.profilePicture, placeHolder: UIImage(named: "profile_placeholder"))
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
