//
//  HomeVC.swift
//  PhotoDob
//
//  Created by Khushboo on 9/24/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit


class HomeVC: UIViewController {

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
    
    
    @IBAction func infoAction(_ sender: AnyObject) {
        let infoVC = storyBoard.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    @IBAction func cartAction(_ sender: AnyObject) {
        
        let cartVC = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    @IBAction func makePrintAction(_ sender: AnyObject) {
        
        let productVC = storyBoard.instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
        self.navigationController?.pushViewController(productVC, animated: true)
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
