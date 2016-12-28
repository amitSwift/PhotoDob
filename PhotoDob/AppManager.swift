 //
//  AppManager.swift
//  TableViewDemo
//
//  Created by surender on 29/01/16.
//  Copyright © 2016 Trigma. All rights reserved.
//

import UIKit
//import PKHUD
import SystemConfiguration
import Foundation
import Alamofire
import CoreData



public protocol WebServiceDelegate : NSObjectProtocol
{
     func serverReponse(responseDict: NSDictionary,serviceurl:NSString)
     func failureRsponseError(failureError:NSError)
    
    //core data
    
//    func saveToCoreDataResponse(responseStatus:Bool)
//    func failToSaveToCoreDataResponse(Error:NSError)
    
}

public class AppManager: NSObject {
    
    public var delegate: WebServiceDelegate?
    
    var people = [NSManagedObject]()
    
    //********* Make Instance Of class ***********//
    
    private struct Constants {
        static let sharedManager = AppManager()
    }
    public class var sharedManager: AppManager {
        return Constants.sharedManager
    }
    // MARK:Check Internet Connectivity
    //************ Check Internet Connectivity **********//
    public class NetWorkReachability
    {
        class func isConnectedToNetwork() -> Bool
        {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {_ in 
                //SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
            }
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability as! SCNetworkReachability, &flags) {
                return false
            }
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
        }
    }
    
    // MARK:Get Device UDID
    //********** Get Device UDID **********//
    public class DeviceUDID
    {
        class func GETUDID() -> String{
            let uuid = NSUUID().uuidString
            return uuid
        }
    }
    
    //******** Check Content is not or not ***********//
    
    public class  getCurrectValue
    {
        class func CheckContentNullORNot(content:(NSString)) -> String
        {
            
            if content .isEqual("null") || content.isEqual("(null)") || content.isEqual("<null>") || content.isEqual("nil") || content.isEqual("") || content.isEqual("<nil>")
            {
                return ""
            }
            else
            {
                return content as String
            }
         }
    }
    
    // MARK: Activity Work
    //************* Activity Indicator **************//
    
    
    func show_LoadingIndicator(_ strLoadingText: String, view:UIView) {
        let vwLoadingIndicator: UIView = UIView()
        vwLoadingIndicator.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        vwLoadingIndicator.center = view.center
        vwLoadingIndicator.backgroundColor = UIColor.black
        vwLoadingIndicator.alpha = 0.7
        vwLoadingIndicator.layer.cornerRadius = 5
        vwLoadingIndicator.tag = 100
        view.addSubview(vwLoadingIndicator)
        
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        loadingIndicator.frame = CGRect(x: vwLoadingIndicator.frame.size.width/2 - 40/2, y: 20.0, width: 40.0, height: 40.0)
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        loadingIndicator.tag = 101
        vwLoadingIndicator.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        var lblLoadingIndicator: UILabel! = UILabel()
        let titleSize = CGRect(x: 10, y: vwLoadingIndicator.frame.size.height - 50, width: 100, height: 50)
        lblLoadingIndicator = UILabel()
        lblLoadingIndicator.frame = titleSize
        lblLoadingIndicator.text = strLoadingText + "..."
        lblLoadingIndicator.textColor = UIColor.white
        lblLoadingIndicator.textAlignment = NSTextAlignment.center
        lblLoadingIndicator.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblLoadingIndicator.numberOfLines = 0
        lblLoadingIndicator.isHidden = false
        lblLoadingIndicator.tag = 111
        vwLoadingIndicator.addSubview(lblLoadingIndicator)
    }
    
    func hide_LoadingIndicatorOnView(_ view:UIView) {
        for vw in view.subviews {
            if vw.tag == 100 {
                for actInd in vw.subviews {
                    if actInd .isKind(of: UIActivityIndicatorView.self) {
                        if actInd.tag == 101 {
                            actInd.removeFromSuperview()
                        }
                    }
                }
                vw.removeFromSuperview()
            }
        }
    }
    
    func activateView(_ view: UIView, loaderText: String) {
        view.isUserInteractionEnabled = false
        self.show_LoadingIndicator(loaderText, view: view)
    }
    
    func inActivateView(_ view: UIView) {
        view.isUserInteractionEnabled = true
        self.hide_LoadingIndicatorOnView(view)
    }
    
  
    
    // MARK: AlertView Work
    //************ Set AlertView *********//
    
    public func Showalert(alerttitle:NSString,alertmessage:NSString){
        
        let alert = UIAlertController(title: alerttitle as String, message: alertmessage as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        alert.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Check String Empty or not
    //********* Check String Empty or not **********//
 
    public func isStringEmpty(strValue:NSString)->Bool
    {
        if strValue .length==0
        {
            return true
        }
        return false
    }
    
    public func isValidEmail(emailText:NSString)->Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailText)
    }
    
    public func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
        
    }
    
    
    //MARK: get document directory Path
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //MARK: save crop image to document directory
    func saveImageDocumentDirectory(imageValue:UIImage,albumname:String,indexValue:String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("OLD\(albumname)\(indexValue).png")
        let image = imageValue as UIImage
        let imageData = UIImagePNGRepresentation(image)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    //MARK:fetch Croped images
    func getCropedImage(_ indexValue:NSInteger,_ albumName:String)->UIImage{
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("\(albumName)\(indexValue).png")
        
        if fileManager.fileExists(atPath: imagePAth){
            print(imagePAth)
            //self.imageView.image = UIImage(contentsOfFile: imagePAth)
            
            
            return UIImage(contentsOfFile: imagePAth)!
        }else{
            print("No Image")
        }
        return UIImage(contentsOfFile: imagePAth)!
    }
    
    
    
    //MARK:fetch orignal images
    func getImageByPathOLD(_ imageName:String)->UIImage?{
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("\(imageName).png")
        
        if fileManager.fileExists(atPath: imagePAth){
            print(imagePAth)
            //self.imageView.image = UIImage(contentsOfFile: imagePAth)
            
            
            return UIImage(contentsOfFile: imagePAth)!
        }else{
            print("No Image")
            
        }
        return nil
        
    }
    /*--------------------------------------------------*/
    //MARK: resize of image
    func resize(_ theImage: UIImage, theNewSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(theNewSize, false, 1.0)
        theImage.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(theNewSize.width), height: CGFloat(theNewSize.height)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    
   
    
    // MARK: Append Base Url & Api URl
    //************ Append Base Url & Api URl ***********//
    
    func createServerPath(requestPath: String) -> String {
        return "\(Header.BASE_URL)\(requestPath)"
    }
    
    //MARK:make full path in string
    
    func createFullServerPath(requestPath: String,and perameterStr:String)->String
    {
        return "\(Header.BASE_URL)\(requestPath)\(perameterStr)"
    }
    
    
    // MARK:Web Service method
    //************ Web Service method ***********//
    public func postDataOnserver(params:AnyObject,postUrl:NSString)
    {
        let serverpath: String = self.createServerPath(requestPath: postUrl as String)
        
       
        
        Alamofire.request(serverpath , method: .post , parameters: params as? Parameters  , encoding: JSONEncoding(options: [])).responseJSON { response in
        
                    print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            
            if let JSON = response.result.value as? NSDictionary {
                self.delegate?.serverReponse(responseDict: JSON, serviceurl: postUrl)
                // print("JSON: \(JSON)")
            }
            else
            {
                self.delegate?.failureRsponseError(failureError: response.result.error! as NSError)
            }

            
        }
        
        
        
        
    }
    
   
    
    
    public func FetchDatafromServer(params:AnyObject,postUrl:NSString)
    {
     
    }
    
    
    
    
}
/*
extension String {
    func URLEncodedString() -> String? {
        let customAllowedSet =  NSCharacterSet.urlQueryAllowed
        let escapedString = self.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        return escapedString
    }
    static func queryStringFromParameters(parameters: Dictionary<String,String>) -> String? {
        if (parameters.count == 0)
        {
            return nil
        }
        var queryString : String? = nil
        for (key, value) in parameters {
            if let encodedKey = key.URLEncodedString() {
                if let encodedValue = value.URLEncodedString() {
                    if queryString == nil
                    {
                        //queryString = "?"
                        queryString = ""
                    }
                    else
                    {
                        queryString! += "&"
                    }
                    queryString! += encodedKey + "=" + encodedValue
                }
            }
        }
        return queryString
    }
}
*/
