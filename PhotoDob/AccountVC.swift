//
//  AccountVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 11/10/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class AccountVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var tableView: UITableView!
    var arrAccount = NSMutableArray()
    
    var loginDetailDic = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Account"
        
        self.navigationController?.isNavigationBarHidden = false
        
        // Do any additional setup after loading the view.
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProductVC.returntoView))
        
        arrAccount = ["Address Book", "Payment Methods" , "Sign Out"]
        tableView.tableFooterView = UIView()
        
        loginDetailDic =  UserDefaults.standard.value(forKey: "LoginDetailDic")as! NSDictionary
        
        lblEmail.text = loginDetailDic.value(forKey: "email")as? String
    }

    func returntoView() {
        //_ = navigationController?.popViewController(animated: true)
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
        for aViewController in viewControllers {
            if(aViewController is InfoVC){
                self.navigationController!.popToViewController(aViewController, animated: true);
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return arrAccount.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell")! as! InfoCell
        
        cell.lblName.text = arrAccount.object(at: indexPath.row) as? String
            
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            let addressBook = self.storyboard?.instantiateViewController(withIdentifier: "AddressBook") as! AddressBook
            self.navigationController?.pushViewController(addressBook, animated: true)
        }else if indexPath.row == 1{
            let paymentMethodVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodVC") as! PaymentMethodVC
            self.navigationController?.pushViewController(paymentMethodVC, animated: true)
        }else{
//            let addressBook = self.storyboard?.instantiateViewController(withIdentifier: "OrderRiviewVC") as! OrderRiviewVC
//            self.navigationController?.pushViewController(addressBook, animated: true)
        }
        
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
