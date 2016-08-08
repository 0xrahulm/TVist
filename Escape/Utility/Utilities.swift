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





