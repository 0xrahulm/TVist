//
//  ListingDatesCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 24/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ListingDatesCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    var listingDates: [ListingDate] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupDatesView(listingDates: [ListingDate]) {
        self.listingDates = listingDates
        
        for (index, listingDate) in listingDates.enumerated() {
            
            if let listingDateView = self.stackView.arrangedSubviews[index] as? ListDateView {
                listingDateView.dateLabel.text = listingDate.dateString
                listingDateView.daysLabel.text = listingDate.label
                listingDateView.imageView.downloadImageWithUrl(listingDate.imageUrl, placeHolder: nil)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ListingDatesCell.didTapOnDate(_:)))
                listingDateView.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    
    func didTapOnDate(_ sender: AnyObject) {
        if let dateGesture = sender as? UITapGestureRecognizer {
            if let dateView = dateGesture.view {
                let listingDate = listingDates[dateView.tag]
                
                ScreenVader.sharedVader.performScreenManagerAction(.OpenFullListingsView, queryParams: ["selectedListDate": listingDate])
            }
        }
    }

}
