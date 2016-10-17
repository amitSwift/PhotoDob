//
//  ConfirmCropVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/6/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class ConfirmCropVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "1"

         self.navigationController?.isNavigationBarHidden = false
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ConfirmCropVC.returntoView))
        
    }
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
