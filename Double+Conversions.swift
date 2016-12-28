//
//  Double+Conversions.swift
//  DrHealthApp
//
//  Created by Amit Verma  on 8/10/16.
//  Copyright © 2016 Amit Verma. All rights reserved.
//

import Foundation  //or swift

extension Double{
    func convertCelciousTofarenhight() -> Double {
        return self * 9 / 5 + 32
    }
    
    func convertFarenhightToCelcious() -> Double {
        return (self - 32) * 8 / 9
    }
}

extension String{
    
    /*func replaceString(oldString:String ,newString:String) -> String {
        return self.stringByReplacingOccurrencesOfString(oldString, withString: newString)
    }*/
}

extension String{
    
    func convertCurrentDateToReqiredDateFormate() -> NSDate {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let dateSecond = dateFormatter.date(from: self)
        return dateSecond! as NSDate
    }
}
//convert to one datefornate to another date formate
extension String{
    
    func convertOneDateFormateToAnotherDateFormater() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        guard let date = dateFormatter.date(from: self) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
}
//MARK: resize image
extension String{
    
    func resize(_ theImage: UIImage, theNewSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(theNewSize, false, 1.0)
        theImage.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(theNewSize.width), height: CGFloat(theNewSize.height)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
