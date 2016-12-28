//
//  CropVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/4/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit


class CropVC: UIViewController,UIScrollViewDelegate,TOCropViewControllerDelegate {
    
    var imageforCrop = UIImage()
    var indexValue = NSInteger()
    var tapToCrop = TapToCrop()
    var albumName = String()
    
    var croppingStyle = TOCropViewCroppingStyle.default
    var image: UIImage!
    
    var vcName = String()
    var fotoliaImageUrlStr = String()

   
    
    //MARK:as outlet
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageForScroll: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if fotoliaImageUrlStr == "" {
            imageForScroll.image = imageforCrop
        }else{
            imageForScroll.hnk_setImage(from: URL(string:fotoliaImageUrlStr))
            if let url = NSURL(string: fotoliaImageUrlStr) {
                if let data = NSData(contentsOf: url as URL) {
                    imageforCrop = UIImage(data: data as Data)!
                }        
            }
            
        }
        

        //set cropview controller for present
        let cropController = TOCropViewController.init(croppingStyle: croppingStyle, image: imageforCrop)
        cropController?.delegate = self
        
        self.image = imageforCrop
        //If profile picture, push onto the same navigation stack
        
        self.present(cropController!, animated: true, completion: { _ in })
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = true
    }
    
    
    //MARK: cropview delegate
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!)
    {
        self.dismiss(animated: true, completion: { () -> Void in
            if image != nil
            {
                let cropController:TOCropViewController = TOCropViewController(image: image)
                cropController.delegate=self
                self.present(cropController, animated: true, completion: nil)
            }
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: { () -> Void in })
    }
    
    // -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
    //        Cropper Delegate
    // -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
    
    func cropViewController(_ cropViewController: TOCropViewController!, didCropTo image: UIImage!, with cropRect: CGRect, angle: Int)
    {
        //save image to document directory
        self.saveImageDocumentDirectory(imageValue: image)
        
        //Given Album Name static
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("\(self.albumName)\(self.indexValue).png")
        let stringPath = "\(imagePAth)"
        
        DBManager.sharedManager.updateAlbumTableFromDB(self.albumName, String(self.indexValue), stringPath)
        
        self.cancelAction(self)
        //_ = navigationController?.popViewController(animated: true)
        
        cropViewController.dismiss(animated: true) { () -> Void in
           // self.imageView.image = image
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController!, didFinishCancelled cancelled: Bool)
    {
        self.cancelAction(self)
        cropViewController.dismiss(animated: true) { () -> Void in  }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return self.imageForScroll
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        
        
        
        
       //photoPrint
         if(vcName == "tapToCropVC"){
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
            for aViewController in viewControllers {
                if(aViewController is TapToCrop){
                    self.navigationController!.popToViewController(aViewController, animated: true);
                }
            }
        }
        else if(vcName == "photoBookVC"){
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
            for aViewController in viewControllers {
                if(aViewController is PhotoBookVC){
                    self.navigationController!.popToViewController(aViewController, animated: true);
                }
            }
        }
        else if(vcName == "colladgePhotoFrameVC"){
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
            for aViewController in viewControllers {
                if(aViewController is ColladgePhotoFrameVC){
                    self.navigationController!.popToViewController(aViewController, animated: true);
                }
            }
        }
        else if(vcName == "tShirtPrintVC"){
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
            for aViewController in viewControllers {
                if(aViewController is SelectAPrintVC){
                    self.navigationController!.popToViewController(aViewController, animated: true);
                }
            }
        }
        else if(vcName == "customPrintedWallpaperVC"){
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
            for aViewController in viewControllers {
                if(aViewController is PhotoBookVC){
                    self.navigationController!.popToViewController(aViewController, animated: true);
                }
            }
        }
        else if(vcName == "rollerBrindesPrintedVC"){
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
            for aViewController in viewControllers {
                if(aViewController is PhotoBookVC){
                    self.navigationController!.popToViewController(aViewController, animated: true);
                }
            }
        }
        else if(vcName == "cushionsPrintedVC"){
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
            for aViewController in viewControllers {
                if(aViewController is PhotoBookVC){
                    self.navigationController!.popToViewController(aViewController, animated: true);
                }
            }
        }

        else if(vcName == "toteBagsPrintedVC"){
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
            for aViewController in viewControllers {
                if(aViewController is PhotoBookVC){
                    self.navigationController!.popToViewController(aViewController, animated: true);
                }
            }
        }

        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func chooseAction(_ sender: AnyObject)
    {
        self.takeScreenshot(sender: imageForScroll)
    }
    
    func takeScreenshot(sender: AnyObject) {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let croppedImage = self.cropImage(screenshot: screenshot!)
        //replace valuew of croped image
        
        //save image to document directory
        self.saveImageDocumentDirectory(imageValue: croppedImage)
        
        //Given Album Name static
       let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("\(albumName)\(indexValue).png")
       let stringPath = "\(imagePAth)"
        
        DBManager.sharedManager.updateAlbumTableFromDB(albumName, String(indexValue), stringPath)
        
        print(croppedImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func cropImage(screenshot: UIImage) -> UIImage {
        let scale = screenshot.scale
        let imgSize = screenshot.size
        let screenHeight = UIScreen.main.applicationFrame.height
        let bound = self.view.bounds.height
       // let navHeight = self.navigationController!.navigationBar.frame.height
        let bottomBarHeight = screenHeight - bound
        
        let crop = CGRect(x: 40 * scale, y: 157 * scale, width: (290) * scale, height: (290) * scale)
//        let crop = CGRect(0, 0, //"start" at the upper-left corner
//            (imgSize.width - 1) * scale, //include half the width of the whole screen
//            (imgSize.height - bottomBarHeight - 1) * scale) //include the height of the navigationBar and the height of view
        
        let cgImage = screenshot.cgImage!.cropping(to: crop)
        let image: UIImage = UIImage(cgImage: cgImage!)
        return image
    }
    
    //MARK: save crop image to document directory
    func saveImageDocumentDirectory(imageValue:UIImage){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(albumName)\(indexValue).png")
        let image = imageValue as UIImage
        print(paths)
        let imageData = UIImagePNGRepresentation(image)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    //MARK: get document directory Path
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
