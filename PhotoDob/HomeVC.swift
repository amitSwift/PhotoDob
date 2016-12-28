//
//  HomeVC.swift
//  PhotoDob
//
//  Created by Khushboo on 9/24/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import CoreData


class HomeVC: UIViewController {

    @IBOutlet var lblCartCount: UILabel!
    var people = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveProduct()
        
        lblCartCount.layer.masksToBounds = true
        lblCartCount.layer.cornerRadius = 10
        
         // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.getCartCount()
    }
    //MARK: get count from database
    func getCartCount(){
        //get cart value from data base
        
        DBManager.sharedManager.getSavedArrayOfCartFromDataBase( comletionHandler: {(result: [NSManagedObject]) -> Void in
            print("result is \(result)")
            self.lblCartCount.text = "\(result.count)"
            }, andFalure: {(fail: Int) -> Void in
                print("fail is \(fail)")
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveProduct() {
        
        
        //1
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        let managedContext = appDelegate.managedObjectContext
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "Product",
                                                 in:managedContext)
        
        let product = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        //3
        
        product.setValue("PHOTO PRINT", forKey: "productName")
        product.setValue("4x4", forKey: "sizeOfProduct")
        product.setValue("0", forKey: "status")
        product.setValue([23, 45, 567.8, 123, 0, 0], forKey: "productImages")
       
        
        //4
        do {
            try managedContext.save()
            print("save")
            //5
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
    }

    
    
    
    @IBAction func infoAction(_ sender: AnyObject) {
        
       //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            people = results as! [NSManagedObject]
            
            let person = people[0]
            
            print(person.value(forKey: "productName") as! String)
            print(person.value(forKey: "productImages") as! NSArray)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

       
        
        let infoVC = storyBoard.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    @IBAction func cartAction(_ sender: AnyObject) {
        
        if lblCartCount.text != "0" {
            let cart2VC = storyBoard.instantiateViewController(withIdentifier: "Cart2VC") as! Cart2VC
            self.navigationController?.pushViewController(cart2VC, animated: true)
        }else{
            let cartVC = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
            self.navigationController?.pushViewController(cartVC, animated: true)
        }
        
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
