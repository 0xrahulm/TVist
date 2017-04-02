//
//  OnBoardingInterestViewController.swift
//  Escape
//
//  Created by Ankit on 21/04/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class OnBoardingInterestViewController: UIViewController {
    
    var interests : [InterestItems] = []
    var selectedInterests : [String] = []
    var bubbleView : BubblePickerView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var scrollInsideView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDataProvider.sharedDataProvider.interestDelegate = self
        UserDataProvider.sharedDataProvider.fetchInterest()
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func addInterestBubbles(_ list : [InterestItems]) {
        var frameForBubbles = self.scrollView.bounds
        bubbleView = BubblePickerView(frame: frameForBubbles, preferenceItems: list)
        bubbleView.bubblePickerDelegate = self
        self.scrollView.addSubview(bubbleView)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: bubbleView.heightOfView+20)
        frameForBubbles.size.height = bubbleView.heightOfView+20
        bubbleView.frame = frameForBubbles
    }

    @IBAction func continueTapped(_ sender: AnyObject) {
        for items in interests{
            if let isSelected = items.isSelected{
                if isSelected{
                    if let id = items.id{
                        self.selectedInterests.append(id)
                    }
                }
            }
        }
        if self.selectedInterests.count > 2 {
            LocalStorageVader.sharedVader.setFlagForKey(.InterestsSelected)
            UserDataProvider.sharedDataProvider.postInterest(selectedInterests)
            ScreenVader.sharedVader.performScreenManagerAction(.MainTab, queryParams: nil)
        } else {
            loadErrorPopUp("Please select atleast 3 interests to proceed.")
        }
    }
    
    
    
    func loadErrorPopUp(_ str : String){
        let alert = UIAlertController(title: "Wait!", message: str, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        alert.view.tintColor = UIColor.escapeRedColor()
        self.present(alert, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}

extension OnBoardingInterestViewController : InterestProtocol{
    
    func interestList(_ list : [InterestItems]){
        
        self.interests = list
        self.addInterestBubbles(list)
        activityIndicator.stopAnimating()
    }
}
extension OnBoardingInterestViewController : BubblePickerProtocol{
    func didTapOnItemAtIndex(_ sender: UIButton) {
        
        interests[sender.tag].isSelected = sender.isSelected
        
    }
}
