//
//  Utilities.swift
//  Escape
//
//  Created by Ankit on 07/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation

func suffixNumber(number:NSNumber) -> NSString {
    
    var num:Double = number.doubleValue;
    let sign = ((num < 0) ? "-" : "" );
    
    num = fabs(num);
    
    if (num < 1000.0){
        return "\(sign)\(num)";
    }
    
    let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
    
    let units:[String] = ["K","M","G","T","P","E"];
    
    let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
    
    return "\(sign)\(roundedNum)\(units[exp-1])";
}

extension UITableView{
    func reloadDataAnimated(){
        
        UIView.transitionWithView(self,
                                  duration:0.25,
                                  options:.TransitionCrossDissolve,
                                  animations:
            { () -> Void in
                self.reloadData()
            },
                                  completion: nil);
    }
}

extension UISearchBar{
    func setGreyAppearance(width : CGFloat , height : CGFloat, clearColor : Bool){
        
        self.setSearchFieldBackgroundImage(UIImage.getImageWithColor(UIColor.whiteColor(), size: CGSizeMake(width, height)), forState: .Normal)
        self.tintColor    = UIColor.grayColor()
        self.backgroundImage = UIImage.getImageWithColor(UIColor.clearColor(), size: CGSizeMake(1, 1))
        if clearColor{
            self.backgroundColor = UIColor.clearColor()
        }else{
            self.backgroundColor = UIColor.searchBarLightGreyBackgroundColor()
        }
        
        self.setImage(UIImage(named: "search-gray"), forSearchBarIcon: UISearchBarIcon.Search, state: .Normal)
        
        self.setImage(UIImage(named: "search-gray"), forSearchBarIcon: UISearchBarIcon.Search, state: .Highlighted)
        self.searchBarStyle = .Minimal
        
        if let textFieldInsideSearchBar = self.valueForKey("searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = UIColor.grayColor()
            let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.valueForKey("placeholderLabel") as? UILabel
            textFieldInsideSearchBar.font = UIFont.systemFontOfSize(12)
            textFieldInsideSearchBarLabel?.textColor = UIColor.grayColor()
            textFieldInsideSearchBar.layer.cornerRadius = 5.5
            textFieldInsideSearchBar.layer.masksToBounds = true
            
        }
    }
    func onTopSearchBar(placeHolder : String){
        self.barTintColor = UIColor.whiteColor()
        self.placeholder  = placeHolder
        self.tintColor    = UIColor.searchBarPlaceHolderColor()
        self.backgroundImage = UIImage.getImageWithColor(UIColor.clearColor(), size: CGSizeMake(1, 1))
        self.backgroundColor = UIColor.escapeBlueColor()
        self.searchBarStyle = .Minimal
        
        self.setImage(UIImage(named: "search-white"), forSearchBarIcon: UISearchBarIcon.Search, state: .Normal)
        self.setImage(UIImage(named: "search-white"), forSearchBarIcon: UISearchBarIcon.Search, state: .Highlighted)
        
        if let textFieldInsideSearchBar = self.valueForKey("searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = UIColor.whiteColor()
            let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.valueForKey("placeholderLabel") as? UILabel
            textFieldInsideSearchBarLabel?.textColor = UIColor.whiteColor()
        }
        self.showsCancelButton = false
        
        
    }
}
extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var firstCharUppercaseFirst: String {
        return first.uppercaseString + String(characters.dropFirst())
    }
}






