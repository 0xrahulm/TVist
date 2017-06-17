//
//  UIImage+Utility.swift
//  Escape
//
//  Created by Ankit on 27/04/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

extension UIImage {
    class func getImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
        func resized(toWidth width: CGFloat) -> UIImage? {
            let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
            UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
            defer { UIGraphicsEndImageContext() }
            draw(in: CGRect(origin: .zero, size: canvasSize))
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    
}
extension UIImageView{
    func downloadImageWithUrl(_ str : String? , placeHolder : UIImage?){
        
        self.image = placeHolder
        
        if let str = str{
            if let url = URL(string: str){
                
                self.af_setImage(withURL: url, placeholderImage: placeHolder, filter: nil, progress: nil, progressQueue: DispatchQueue.global(), imageTransition: UIImageView.ImageTransition.crossDissolve(0.35), runImageTransitionIfCached: false, completion: nil)
            }
        }
        
    }
}


