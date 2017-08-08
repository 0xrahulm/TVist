//
//  Utilities.swift
//  Escape
//
//  Created by Ankit on 07/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit


func suffixNumber(_ number:NSNumber) -> String {
    
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
        self.reloadData()
    }
}

extension UISearchBar{
    func setGreyAppearance(_ width : CGFloat , height : CGFloat, clearColor : Bool){
        
        self.setSearchFieldBackgroundImage(UIImage.getImageWithColor(UIColor.white, size: CGSize(width: width, height: height)), for: UIControlState())
        self.tintColor    = UIColor.gray
        self.backgroundImage = UIImage.getImageWithColor(UIColor.clear, size: CGSize(width: 1, height: 1))
        if clearColor{
            self.backgroundColor = UIColor.clear
        }else{
            self.backgroundColor = UIColor.searchBarLightGreyBackgroundColor()
        }
        
        self.setImage(UIImage(named: "search-gray"), for: UISearchBarIcon.search, state: UIControlState())
        
        self.setImage(UIImage(named: "search-gray"), for: UISearchBarIcon.search, state: .highlighted)
        self.searchBarStyle = .minimal
        
        if let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = UIColor.gray
            let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.value(forKey: "placeholderLabel") as? UILabel
            textFieldInsideSearchBar.font = UIFont.systemFont(ofSize: 12)
            textFieldInsideSearchBarLabel?.textColor = UIColor.gray
            textFieldInsideSearchBar.layer.cornerRadius = 5.5
            textFieldInsideSearchBar.layer.masksToBounds = true
            
        }
    }
    func onTopSearchBar(_ placeHolder : String){
        self.barTintColor = UIColor.white
        self.placeholder  = placeHolder
        self.tintColor    = UIColor.searchBarPlaceHolderColor()
        self.backgroundImage = UIImage.getImageWithColor(UIColor.clear, size: CGSize(width: 1, height: 1))
        self.backgroundColor = UIColor.escapeBlueColor()
        self.searchBarStyle = .minimal
        
        self.setImage(UIImage(named: "search-white"), for: UISearchBarIcon.search, state: UIControlState())
        self.setImage(UIImage(named: "search-white"), for: UISearchBarIcon.search, state: .highlighted)
        
        if let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = UIColor.white
            let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.value(forKey: "placeholderLabel") as? UILabel
            textFieldInsideSearchBarLabel?.textColor = UIColor.white
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
        return first.uppercased() + String(characters.dropFirst())
    }
}






