//
//  Cart2VC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/6/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import CoreData





class Cart2VC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet var tblCart: UITableView!
    var albumManageObject = [NSManagedObject]()
    var mainCartArray = NSMutableArray()

    
   var  animalIndexTitles = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
         self.navigationController?.isNavigationBarHidden = false
        //add navigation  button
        var image = UIImage(named: "close")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(Cart2VC.returntoView))
        
        animalIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

        
        //get cart value from data base
         self.loadCartValueForTable()
    }
    
    
     //get cart value from data base
    func loadCartValueForTable() {
        
       
        
        DBManager.sharedManager.getSavedArrayOfCartFromDataBase( comletionHandler: {(result: [NSManagedObject]) -> Void in
            
            print("result is \(result)")
            
            self.albumManageObject = result
            print(self.albumManageObject)
            
            self.mainCartArray = NSMutableArray()
            for i in 0 ..< self.albumManageObject.count{
                let albumObject = self.albumManageObject[i]
                
                self.mainCartArray.add(albumObject)
                print(self.mainCartArray)
                //self.mainCartArray.add((albumObject.value(forKey: "albumName") as! NSMutableArray).object(at: 0)as! String)
            }
            self.title = "Cart(\(self.mainCartArray.count))"
            
            if self.mainCartArray.count == 0{
                let cartVC = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
                self.navigationController?.pushViewController(cartVC, animated: false)
            }
            
            self.tblCart.reloadData()
            }, andFalure: {(fail: Int) -> Void in
                print("fail is \(fail)")
        })

    }
    
    func returntoView() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func CheckOutAction(_ sender: AnyObject)
    {
        
        if(UserDefaults.standard.value(forKey: "LoginDetailDic") != nil){
            
            let addressBook = self.storyboard?.instantiateViewController(withIdentifier: "OrderRiviewVC") as! OrderRiviewVC
            self.navigationController?.pushViewController(addressBook, animated: true)
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please Login First!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        

    }
    
    
    //MARK: table view datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mainCartArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cart2")! as! Cart2Cell

       // var sdd = (((self.mainCartArray[indexPath.row] as AnyObject).value(forKey: "albumName") as! NSMutableArray).object(at: 0)as! String)
        //print(sdd)
        
        cell.lblSizeName.text = ((self.mainCartArray[indexPath.row] as AnyObject).value(forKey: "sizeOfProduct") as! String)
        
        if(((self.mainCartArray[indexPath.row] as AnyObject).value(forKey: "albumName") as! NSMutableArray).count >= 10 &&  ((self.mainCartArray[indexPath.row] as AnyObject).value(forKey: "albumName") as! NSMutableArray).count < 100){
            cell.lblQuantity.text = "0\(((self.mainCartArray[indexPath.row] as AnyObject).value(forKey: "albumName") as! NSMutableArray).count ) Photos"
        }else if(((self.mainCartArray[indexPath.row] as AnyObject).value(forKey: "albumName") as! NSMutableArray).count == 1){
            cell.lblQuantity.text = "00\(((self.mainCartArray[indexPath.row] as AnyObject).value(forKey: "albumName") as! NSMutableArray).count ) Photo"
        }
        else{
            cell.lblQuantity.text = "00\(((self.mainCartArray[indexPath.row] as AnyObject).value(forKey: "albumName") as! NSMutableArray).count ) Photos"
        }
        
        cell.lblPrise.text = "$ \(((self.mainCartArray[indexPath.row] as AnyObject).value(forKey: "amount") as! String))"
        
        
        cell.btnPlus.addTarget(self, action: #selector(Cart2VC.plusAction(_:)), for: .touchUpInside)
        cell.btnPlus.tag = indexPath.row
        
        cell.btnMinus.addTarget(self, action: #selector(Cart2VC.minusAction(_:)), for: .touchUpInside)
        cell.btnMinus.tag = indexPath.row
        
        
        cell.lblQty.text = "Qty\(((self.mainCartArray[indexPath.row] as AnyObject).value(forKey: "quantity") as! String))"
        
        return cell
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //edit work
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return YES if you want the specified item to be editable.
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("triggered!")
        
        let more = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            print("more button tapped")
            
            
            let alert = UIAlertController(title: "Alert", message: "Do yo want to remove this product from Cart?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
            //event handler with closure
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                
                 let primarykeyValue = ((self.mainCartArray[indexPath.row] as AnyObject).value(forKey: "primaryKey") as! String)
                let arr = DBManager.sharedManager.fetchItemFromCartTable(primarykeyValue)
                DBManager.sharedManager.deleteRecordsFromDB(arr)
                self.loadCartValueForTable()
                
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        more.backgroundColor = UIColor.red
        
        return [more]
    }
    

    
    
  /*  func sectionIndexTitles(forTableView tableView: UITableView) -> NSArray {
        return animalIndexTitles
    }*/
    
//    override func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        for view: UIView in tv.subviews {
//            if (view.self.description == "UITableViewIndex") {
//                view.performSelector(inBackground: #selector(self.setIndexColor), with: UIColor.red)
//            }
//        }
//        //rest of cellForRow handling...
//    }
    
    func plusAction(_ sender:UIButton)
    {
        let qty = "\(NSInteger((self.mainCartArray[sender.tag] as AnyObject).value(forKey: "quantity") as! String)!+1 )"
         let amount = "\(NSInteger("12")!*NSInteger(qty)! )"
        let primarykeyValue = ((self.mainCartArray[sender.tag] as AnyObject).value(forKey: "primaryKey") as! String)
        DBManager.sharedManager.updateCartTableFromDB(primarykeyValue, qty,amount)
        self.loadCartValueForTable()
        
    }
    
    func minusAction(_ sender:UIButton)  {
        
        let qty = "\(NSInteger((self.mainCartArray[sender.tag] as AnyObject).value(forKey: "quantity") as! String)!-1 )"
        let amount = "\(NSInteger("12")!*NSInteger(qty)! )"
        let primarykeyValue = ((self.mainCartArray[sender.tag] as AnyObject).value(forKey: "primaryKey") as! String)
        
        
       /* let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tblCart.cellForRow(at: indexPath as IndexPath) as! Cart2Cell*/
        
        if qty == "0" {
            
            let alert = UIAlertController(title: "Alert", message: "Do yo want to remove this product from Cart?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
            //event handler with closure
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                
                let arr = DBManager.sharedManager.fetchItemFromCartTable(primarykeyValue)
                DBManager.sharedManager.deleteRecordsFromDB(arr)
                self.loadCartValueForTable()
                
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            
            DBManager.sharedManager.updateCartTableFromDB(primarykeyValue, qty,amount)
            self.loadCartValueForTable()
        }
        
        
        
        
        
        
        
        
        
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
