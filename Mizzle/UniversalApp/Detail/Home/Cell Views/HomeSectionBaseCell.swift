//
//  HomeSectionBaseCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 25/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class HomeSectionBaseCell: UITableViewCell {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var seeAllButton: UIButton!
    
    var lastScrollValue:String = ""
    
    weak var viewAllTapDelegate: ViewAllTapProtocol?
    
    var homeViewType:HomeViewType = HomeViewType.today

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func viewAllTapped() {
        if let viewAllTapDelegate = viewAllTapDelegate {
            viewAllTapDelegate.viewAllTappedIn(self)
        }
    }
    
    func scrollBucket(scrollValue: CGFloat) -> String {
        
        if scrollValue < 30.0 {
            return "0-30"
        }
        if scrollValue >= 30.0 && scrollValue < 60.0 {
            return "30-60"
        }
        if scrollValue >= 60.0 && scrollValue <= 90.0 {
            return "60-90"
        }
        
        if scrollValue > 120 {
            return "> 120"
        }
        
        if scrollValue > 90 {
            return "> 90"
        }
        
        return "Unknown"
        
    }
    
    @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let percentageScroll:CGFloat = ((scrollView.contentOffset.x+scrollView.frame.size.width)/scrollView.contentSize.width)*100
        let scrollBucketStr = scrollBucket(scrollValue: percentageScroll)
        if self.lastScrollValue != scrollBucketStr {
            if let sectionTitle = self.sectionTitleLabel.text {
                
                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SectionHorizontalScroll, properties: ["percentage":String(format:"%.1f",percentageScroll), "scrollBucket": scrollBucketStr, "SectionName": sectionTitle, "ViewType":homeViewType.rawValue])
            }
            self.lastScrollValue = scrollBucketStr
            
        }
        
    }
    
    @objc func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            
            let percentageScroll:CGFloat = ((scrollView.contentOffset.x+scrollView.frame.size.width)/scrollView.contentSize.width)*100
            let scrollBucketStr = scrollBucket(scrollValue: percentageScroll)
            if self.lastScrollValue != scrollBucketStr {
                if let sectionTitle = self.sectionTitleLabel.text {
                    AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SectionHorizontalScroll, properties: ["percentage":String(format:"%.1f",percentageScroll), "scrollBucket": scrollBucketStr, "SectionName": sectionTitle, "ViewType":homeViewType.rawValue])
                }
                self.lastScrollValue = scrollBucketStr
            }
        }
    }

    

}
