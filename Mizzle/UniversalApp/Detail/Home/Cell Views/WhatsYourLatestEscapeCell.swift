//
//  WhatsYourLatestEscapeCell.swift
//  Escape
//
//  Created by Ankit on 14/12/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class WhatsYourLatestEscapeCell: BaseStoryTableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    
    override func awakeFromNib() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WhatsYourLatestEscapeCell.handleTapGesture(_:)))
        topView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        ScreenVader.sharedVader.performScreenManagerAction(.OpenSearchView, queryParams: nil)
        
    }
    
    var imageStr : String?{
        didSet{
            if let image = imageStr{
                userImage.downloadImageWithUrl(image, placeHolder: UIImage(named: "profile_placeholder"))
            }else{
                userImage.image = UIImage(named: "profile_placeholder")
            }
            
        }
    }
    
    @IBAction func movieTapped(_ sender: UIButton) {
        ScreenVader.sharedVader.performScreenManagerAction(.OpenSearchView, queryParams: ["moveToIndex" : 1])
        
    }
    
    @IBAction func TvShowTapped(_ sender: UIButton) {
        ScreenVader.sharedVader.performScreenManagerAction(.OpenSearchView, queryParams: ["moveToIndex" : 2])
        
    }
    
    
    @IBAction func bookTapped(_ sender: UIButton) {
        ScreenVader.sharedVader.performScreenManagerAction(.OpenSearchView, queryParams: ["moveToIndex" : 3])
        
    }

}
