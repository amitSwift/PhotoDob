//
//  PaymentMethodVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 11/10/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class PaymentMethodVC: UIViewController {

    
    @IBOutlet var paymentView: UIView!
    @IBOutlet var backImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Payment Methods"
        
        // Do any additional setup after loading the view.
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProductVC.returntoView))
        
        
        //confirm navigation  button
        let button1 = UIBarButtonItem(image: UIImage(named: "imagename"), style: .plain, target: self, action: #selector(PaymentMethodVC.confirmAction)) // action:#selector(Class.MethodName) for swift 3
        button1.title = "Edit"
        self.navigationItem.rightBarButtonItem  = button1
        
        
    }
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }

    func confirmAction() {
    }
    
    
    @IBAction func addCreditCardAction(_ sender: AnyObject)
    {
        self.view.addSubview(self.paymentView)
        self.backImage.alpha = 0.0
        self.paymentView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backImage.alpha = 0.5
            self.paymentView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    
    @IBAction func crossAction(_ sender: AnyObject) {
        
        self.backImage.alpha = 0.5
        self.paymentView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.addSubview(self.paymentView)
            self.backImage.alpha = 0.0
            self.paymentView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        })
        
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
