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
    
    @IBOutlet weak var resizerButton: UIButton!
    
    @IBOutlet weak var bottomLine: UIView!

    @IBOutlet weak var blueDotView: UIView!
    
    var contentView : UIView?
    
    weak var delegate: MasterHeaderViewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headerTitleLabel.alpha = 0
        self.resizerButton.isHidden = true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        contentView!.frame = bounds
        
        // Make the view stretch with containing view
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView!)
    }
    
    func loadViewFromNib() -> UIView! {
        
        let bundle = Bundle(for: MasterHeaderView.self)
        let nib = UINib(nibName: "MasterHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func setMasterHeaderViewWithTitle(title: String) {
        self.largeTitleLabel.text = title
        self.headerTitleLabel.text = title
        self.blueDotView.isHidden = LocalStorageVader.sharedVader.flagValueForKey(.TappedOnBlueDot)
    }
    
    func setUserProfileBackButton() {
        self.leftView.isHidden = false
        self.resizerButton.isHidden = true
        
        setupUserProfileImage()
        
            
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MasterHeaderView.didTapOnLeftNavigationButton))
        self.leftView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func didTapOnLeftNavigationButton() {
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
