//
//  CropVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/4/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class CropVC: UIViewController,UIScrollViewDelegate {
    
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageForScroll: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
         _ = navigationController?.popViewController(animated: true)
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
        print(croppedImage)
        
        let cart2VC = storyBoard.instantiateViewController(withIdentifier: "Cart2VC") as! Cart2VC
        self.navigationController?.pushViewController(cart2VC, animated: true)
        
    }
    
    func cropImage(screenshot: UIImage) -> UIImage {
        let scale = screenshot.scale
        let imgSize = screenshot.size
        let screenHeight = UIScreen.main.applicationFrame.height
        let bound = self.view.bounds.height
        let navHeight = self.navigationController!.navigationBar.frame.height
        let bottomBarHeight = screenHeight - navHeight - bound
        
        let crop = CGRect(x: 40 * scale, y: 157 * scale, width: (290) * scale, height: (290) * scale)
//        let crop = CGRect(0, 0, //"start" at the upper-left corner
//            (imgSize.width - 1) * scale, //include half the width of the whole screen
//            (imgSize.height - bottomBarHeight - 1) * scale) //include the height of the navigationBar and the height of view
        
        let cgImage = screenshot.cgImage!.cropping(to: crop)
        let image: UIImage = UIImage(cgImage: cgImage!)
        return image
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
