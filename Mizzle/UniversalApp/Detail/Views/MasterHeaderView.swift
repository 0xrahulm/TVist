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

    @IBOutlet weak var redDotView: UIView!
    
    var contentView : UIView?
    
    var rightNavButtonTarget: Any?
    var rightNavButtonAction: Selector?
    
    
    var resizerButtonTarget: Any?
    var resizerButtonAction: Selector?
    
    weak var delegate: MasterHeaderViewProtocol?
    
    var isCollapsed: Bool = false
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        self.redDotView.isHidden = LocalStorageVader.sharedVader.flagValueForKey(.TappedOnRedDot)
    }
    
    func setBackButton(withUserProfile: Bool) {
        
        self.leftView.isHidden = false
        self.resizerButton.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(MasterHeaderView.setupUserProfileImage), name: NSNotification.Name(NotificationObservers.UserDetailsDataObserver.rawValue), object: nil)
        
        if withUserProfile {
            setupUserProfileImage()
        } else {
            self.userProfileImageView.alpha = 0
            self.redDotView.alpha = 0
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MasterHeaderView.didTapOnLeftNavigationButton))
        self.leftView.addGestureRecognizer(tapGesture)
        
    }
    
    func setUserProfileBackButton() {
        setBackButton(withUserProfile: true)
    }
    
    @objc func didTapOnLeftNavigationButton() {
        if let delegate = delegate {
            delegate.didTapLeftNavButton()
        }
    }
    
    func setResizerButton(displayModeButton: UIBarButtonItem) {
        self.leftView.isHidden = true
        self.resizerButton.isHidden = false
        
        self.resizerButtonTarget = displayModeButton.target
        self.resizerButtonAction = displayModeButton.action
        
        self.resizerButton.addTarget(self, action: #selector(MasterHeaderView.resizerButtonTap), for: .touchUpInside)
    }
    
    @objc func setupUserProfileImage() {
        
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
            userProfileImageView.downloadImageWithUrl(user.profilePicture, placeHolder: UIImage(named: "profile_placeholder"))
        }
    }
    
    func setupRightNavWithImage(image: String, action: Selector, target: Any) {
        let button = UIButton(frame: self.rightView.bounds)
        
        button.setImage(UIImage(named: image), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        button.contentHorizontalAlignment = .right
        rightNavButtonAction = action
        rightNavButtonTarget = target
        button.addTarget(self, action: #selector(MasterHeaderView.rightNavButtonTap), for: .touchUpInside)
        
        self.rightView.addSubview(button)
    }
    
    @objc func rightNavButtonTap() {
        if let action = self.rightNavButtonAction, let target = self.rightNavButtonTarget {
            sendAction(action: action, target: target)
        }
    }
    
    func sendAction(action: Selector, target: Any) {
        UIApplication.shared.sendAction(action, to: target, from: self, for: nil)
    }
    
    @objc func resizerButtonTap() {
        AnalyticsVader.sharedVader.basicEvents(eventName: .ResizerButtonTap)
        
        if let action = self.resizerButtonAction, let target = self.resizerButtonTarget {
            sendAction(action: action, target: target)
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
