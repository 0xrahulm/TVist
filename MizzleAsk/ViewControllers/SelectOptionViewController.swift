//
//  SelectOptionViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 11/05/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class SelectOptionViewController: UIViewController {
    
    weak var delegate: SelectOptionViewControllerDelegate?
    
    @IBAction func searchButtonTapped(sender: UIButton) {
        delegate?.didTapOnSearchButton()
    }
    
    @IBAction func bookButtonTapped(sender: UIButton) {
        delegate?.didTapOnSuggestionButton(type: SearchType.Books)
    }
    
    
    @IBAction func movieButtonTapped(sender: UIButton) {
        delegate?.didTapOnSuggestionButton(type: SearchType.Movie)
    }
    
    
    @IBAction func tvShowButtonTapped(sender: UIButton) {
        delegate?.didTapOnSuggestionButton(type: SearchType.TvShows)
    }
    
    @IBAction func anythingButtonTapped(sender: UIButton) {
        delegate?.didTapOnSuggestionButton(type: SearchType.All)
    }

}

protocol SelectOptionViewControllerDelegate: class {
    func didTapOnSearchButton()
    func didTapOnSuggestionButton(type: SearchType)
}
