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
    var selectedInterests : [NSNumber] = []
    var bubbleView : BubblePickerView!

    @IBOutlet weak var scrollInsideView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDataProvider.sharedDataProvider.interestDelegate = self
        UserDataProvider.sharedDataProvider.fetchInterest()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addInterestBubbles(list : [InterestItems]){
        
        bubbleView = BubblePickerView(frame: self.scrollInsideView.frame, preferenceItems: list)
        bubbleView.bubblePickerDelegate = self
        self.scrollInsideView.addSubview(bubbleView)
        
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
        
        UserDataProvider.sharedDataProvider.postInterest(selectedInterests)
        ScreenVader.sharedVader.performScreenManagerAction(.MainTab, queryParams: nil)
    }
    
}

extension OnBoardingInterestViewController : InterestProtocol{
    
    func interestList(list : [InterestItems]){
        self.interests = list
        self.addInterestBubbles(list)
        
    }
}
extension OnBoardingInterestViewController : BubblePickerProtocol{
    func didTapOnItemAtIndex(sender: UIButton) {
        
        interests[sender.tag].isSelected = sender.selected
        
    }
}
