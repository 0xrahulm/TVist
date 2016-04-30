//
//  UIImage+Utility.swift
//  Escape
//
//  Created by Ankit on 27/04/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation

extension UIImage {
    class func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

