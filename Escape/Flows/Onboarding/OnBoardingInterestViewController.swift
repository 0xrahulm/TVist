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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func addInterestBubbles(list : [InterestItems]) {
        var frameForBubbles = self.scrollView.bounds
        bubbleView = BubblePickerView(frame: frameForBubbles, preferenceItems: list)
        bubbleView.bubblePickerDelegate = self
        self.scrollView.addSubview(bubbleView)
        self.scrollView.contentSize = CGSize(width: CGRectGetWidth(self.scrollView.frame), height: bubbleView.heightOfView+20)
        frameForBubbles.size.height = bubbleView.heightOfView+20
        bubbleView.frame = frameForBubbles
    }

    @IBAction func continueTapped(sender: AnyObject) {
        for items in interests{
            if let isSelected = items.isSelected{
                if isSelected{
                    if let id = items.id{
                        self.selectedInterests.append(id)
                    }
                }
            }
        }
        if self.selectedInterests.count > 0 {
            LocalStorageVader.sharedVader.setFlagForKey(.InterestsSelected)
            UserDataProvider.sharedDataProvider.postInterest(selectedInterests)
            ScreenVader.sharedVader.performScreenManagerAction(.MainTab, queryParams: nil)
        } else {
            loadErrorPopUp("Please select atleast 1 interest.")
        }
    }
    
    
    
    func loadErrorPopUp(str : String){
        let alert = UIAlertController(title: "Wait!", message: str, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        alert.view.tintColor = UIColor.escapeRedColor()
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

extension OnBoardingInterestViewController : InterestProtocol{
    
    func interestList(list : [InterestItems]){
        
        self.interests = list
        self.addInterestBubbles(list)
        activityIndicator.stopAnimating()
    }
}
extension OnBoardingInterestViewController : BubblePickerProtocol{
    func didTapOnItemAtIndex(sender: UIButton) {
        
        interests[sender.tag].isSelected = sender.selected
        
    }
}
