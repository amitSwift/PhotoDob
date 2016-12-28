//
//  ConfirmRollerBlind.swift
//  PhotoDob
//
//  Created by Amit Verma  on 12/1/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import CoreData

class ConfirmRollerBlind: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet var imageOfRoller: UIImageView!
    @IBOutlet var lblPrice: UILabel!
    
    //MARK: Variables
    var imageUrl = String()
    
    var albumManageObject = [NSManagedObject]()
    var productName = String()
    var sizeOfProduct = String()
    var primaryKeyCount = String()
    var mainCartArray = NSMutableArray()
    var productImagesArr = NSMutableArray()
    var albumNameArr = NSMutableArray()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageOfRoller.hnk_setImage(from: URL(string: imageUrl))
        
        self.title = "Confirm"
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ConfirmRollerBlind.returntoView))
        
        
        self.productName = Header.appDelegate.ProductName
        self.sizeOfProduct = Header.appDelegate.SizeName
        
        productImagesArr.add(imageUrl) //add image to database
        albumNameArr.add("Fotolia") // add albumname
        
        
        //confirm navigation  button
      /*  let button1 = UIBarButtonItem(image: UIImage(named: "imagename"), style: .plain, target: self, action: #selector(ConfirmRollerBlind.confirmAction)) // action:#selector(Class.MethodName) for swift 3
        button1.title = "Confirm"
        self.navigationItem.rightBarButtonItem  = button1*/
        

        // Do any additional setup after loading the view.
    }
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    func confirmAction() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToCartAction(_ sender: AnyObject) {
        
        if (self.title != "0"){
            let alert = UIAlertController(title: "Alert", message: "Do yo want to add this product to Cart?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
            //event handler with closure
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                
                self.getCountOfCartArray()
                self.addProductToCartTable()
                
                self.removeProductFromDatabase()
                self.pushToCartView()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please select atleats one picture!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
            //event handler with closure
            
            self.present(alert, animated: true, completion: nil)
        }

        
        
    }
    
    //MARK: add product to cart table
    func addProductToCartTable() {
        
        DBManager.sharedManager.saveProductValueToCart(self.productName, self.sizeOfProduct, self.productImagesArr, self.albumNameArr, "1","1",primaryKeyCount,"50", andCompletionHandler:{(result: Bool) -> Void in
            print("result is \(result)")
            }, andFalure: {(fail: NSError) -> Void in
                print("fail is \(fail)")
        })
        
    }
    
    func getCountOfCartArray(){
        
        DBManager.sharedManager.getSavedArrayOfCartFromDataBase( comletionHandler: {(result: [NSManagedObject]) -> Void in
            
            print("result is \(result)")
            
            self.albumManageObject = result
            print(self.albumManageObject)
            
            self.mainCartArray = NSMutableArray()
            for i in 0 ..< self.albumManageObject.count{
                let albumObject = self.albumManageObject[i]
                
                self.mainCartArray.add(albumObject)
                //self.mainCartArray.add((albumObject.value(forKey: "albumName") as! NSMutableArray).object(at: 0)as! String)
                
            }
            
            if self.mainCartArray.count == 0 {
                self.primaryKeyCount = "1"
            }
            else{
                self.primaryKeyCount = ((self.mainCartArray[self.mainCartArray.count-1] as AnyObject).value(forKey: "primaryKey") as! String)
                self.primaryKeyCount = "\(Int(self.primaryKeyCount)! + 1)"
            }
            
            print(self.primaryKeyCount)
            
            
            
            }, andFalure: {(fail: Int) -> Void in
                print("fail is \(fail)")
        })
        
    }
    
    
    //MARK: remove added product from Album table
    func removeProductFromDatabase() {
        
        let arr = DBManager.sharedManager.fetchImagesByProductNameFromDB(UserDefaults.standard.value(forKey: "ProductName") as! String)//remove value from database by size when changed size
        print(arr)
        DBManager.sharedManager.deleteRecordsFromDB(arr)
        
        UserDefaults.standard.removeObject(forKey: "ProductName")
        UserDefaults.standard.removeObject(forKey: "SizeName")
        
    }
    //MARK: push to cart view controller
    func pushToCartView() {
        let cart2VC = storyBoard.instantiateViewController(withIdentifier: "Cart2VC") as! Cart2VC
        self.navigationController?.pushViewController(cart2VC, animated: true)
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
