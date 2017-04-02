//
//  UINibView.swift
//  Escape
//
//  Created by Ankit on 24/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class UINibView: UIView {

    var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        
        contentView = loadViewFromNib()
        contentView.frame = CGRect(x: 0, y: getContentViewOffset(), width: bounds.size.width, height: getContentViewHeight())
        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth,UIViewAutoresizing.flexibleHeight]
        
        addToView()
    }
    
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: getNibName(), bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    
    func getNibName() -> String {
        
        // override to get expected results
        return ""
    }
    
    func addToView() {
        addSubview(contentView)
    }
    
    
    func getContentViewHeight() -> CGFloat {
        return bounds.size.height
    }
    
    func getContentViewOffset() -> CGFloat {
        return 0
    }

}
