//
//  CartVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 9/29/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class CartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Cart(0)"

        // Do any additional setup after loading the view.
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProductVC.returntoView))
        
        
        // Do any additional setup after loading the view.
    }
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func keepShopingAction(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Alert", message: "Under process!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func checkOutAction(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Alert", message: "Under process!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
