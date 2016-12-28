//
//  AddressBook.swift
//  PhotoDob
//
//  Created by Amit Verma  on 11/10/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class AddressBook: UIViewController,UITableViewDelegate,UITableViewDataSource,WebServiceDelegate {

    //MARK:Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addressBookView: UIView!
    @IBOutlet var backImage: UIImageView!
    
    @IBOutlet var btnSaveEdit: UIButton!
    
    
    
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtAddressLine1: UITextField!
    @IBOutlet var txtAddressLine2: UITextField!
    @IBOutlet var txtZipCode: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtState: UITextField!
    
    //MARK: Variables
    var loginDetailDic = NSDictionary()
    var addresaArray = NSArray()
    var isSaveAction = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Address Book"
        // Do any additional setup after loading the view.
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProductVC.returntoView))
        
        loginDetailDic =  UserDefaults.standard.value(forKey: "LoginDetailDic")as! NSDictionary
        print(loginDetailDic)
        
        // During startup (-viewDidLoad or in storyboard) do:
        self.tableView.allowsMultipleSelectionDuringEditing = false;
        
        self.getAddress()
    }
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }

    func getAddress(){
        
        AppManager.sharedManager.delegate=self
        AppManager.sharedManager.activateView(self.view, loaderText: "Loading")
        let params: [String: AnyObject] = ["user_id": loginDetailDic.value(forKey: "id")as! String as AnyObject, "access_token": loginDetailDic.value(forKey: "access_token")as! String as AnyObject]
        
        print(params)
        AppManager.sharedManager.postDataOnserver(params: params as AnyObject, postUrl: Header.KGetAddress as NSString)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    
    @IBAction func addShippingAddressAction(_ sender: AnyObject)
    {
        txtFirstName.text = ""
        txtLastName.text = ""
        txtCountry.text = ""
        txtAddressLine1.text = ""
        txtAddressLine2.text = ""
        txtZipCode.text = ""
        txtCity.text = ""
        txtState.text = ""
        
        
        
        isSaveAction = true
        btnSaveEdit.setTitle("Save", for: .normal)
        self.view.addSubview(self.addressBookView)
        self.backImage.alpha = 0.0
         self.addressBookView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backImage.alpha = 0.5
            self.addressBookView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    
    @IBAction func crossAction(_ sender: AnyObject) {
        
        self.backImage.alpha = 0.5
        self.addressBookView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.addSubview(self.addressBookView)
            self.backImage.alpha = 0.0
            self.addressBookView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        })

    }
    
    
    //MARK:table view datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addresaArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressBookCell")! as! AddressBookCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.lblName.text = "\((addresaArray[indexPath.row]as!  NSDictionary).value(forKey: "first_name") as! String) \((addresaArray[indexPath.row]as!  NSDictionary).value(forKey: "last_name") as! String)" 
        cell.lblAddress1.text = (addresaArray[indexPath.row]as!  NSDictionary).value(forKey: "addressline1") as! String?
        cell.lblAddress2.text = (addresaArray[indexPath.row]as!  NSDictionary).value(forKey: "addressline2") as! String?
        cell.lblState.text = (addresaArray[indexPath.row]as!  NSDictionary).value(forKey: "state") as! String?
        cell.lblCountry.text = (addresaArray[indexPath.row]as!  NSDictionary).value(forKey: "country") as! String?
        
        cell.btnEdit.addTarget(self, action: #selector(AddressBook.editAddress(_:)), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return YES if you want the specified item to be editable.
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("triggered!")
        
        let more = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            print("more button tapped")
            
            AppManager.sharedManager.delegate=self
            AppManager.sharedManager.activateView(self.view, loaderText: "Loading")
            let params: [String: AnyObject] = ["user_id": self.loginDetailDic.value(forKey: "id")as! String as AnyObject, "access_token": self.loginDetailDic.value(forKey: "access_token")as! String as AnyObject,"shipping_id":(self.addresaArray[indexPath.row]as!  NSDictionary).value(forKey: "shipping_id") as! String! as AnyObject]
            
            print(params)
            AppManager.sharedManager.postDataOnserver(params: params as AnyObject, postUrl: Header.KDeleteAddress as NSString)

        }
        more.backgroundColor = UIColor.red
        
        return [more]
    }
    
    
    
    
    //MARK:table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: save address action
    
    @IBAction func saveNewAddress(_ sender: AnyObject) {
        
        
        
        if txtFirstName.text == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please fill first name!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtLastName.text == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please fill last name!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtCountry.text == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please fill country!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        else if txtAddressLine1.text == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please fill address field 1!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        else if txtAddressLine2.text == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please fill address field 2!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtZipCode.text == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please fill zip code!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtCity.text == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please fill city!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtState.text == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please fill state!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            
            AppManager.sharedManager.delegate=self
            AppManager.sharedManager.activateView(self.view, loaderText: "Loading")
            
            let loginDetailDic =  UserDefaults.standard.value(forKey: "LoginDetailDic")as! NSDictionary
            print(loginDetailDic)
            
            
            var shipingId = String()
            if isSaveAction == true{
                if addresaArray.count > 0{
                    
                    shipingId = ((addresaArray[addresaArray.count-1]as!  NSDictionary).value(forKey: "shipping_id") as! String?)!
                    shipingId = String(Int(shipingId)!+1)
                }
                else{
                    shipingId = "1"
                }
                    
               /* let x : Int = addresaArray.count + 1
                let shipingId = String(x)
                */
                let shippingDic:[String:String] = [
                    "first_name":txtFirstName.text!,"shipping_id":shipingId ,"last_name":txtLastName.text!,"country":txtCountry.text!,"addressline1":txtAddressLine1.text!,"addressline2":txtAddressLine2.text!,"zip_code":txtZipCode.text!,"city":txtCity.text!,"state":txtState.text!,
                    ]
                let params: [String: AnyObject] = ["user_id": loginDetailDic.value(forKey: "id")as! String as AnyObject, "access_token": loginDetailDic.value(forKey: "access_token")as! String as AnyObject,"shipping_address": shippingDic as AnyObject]
                 print(params)
                AppManager.sharedManager.postDataOnserver(params: params as AnyObject, postUrl: Header.KSaveAddress as NSString)

            }else{
                let x : Int =  UserDefaults.standard.value(forKey: "indexValue") as! Int
                let shipingId = (addresaArray[x]as!  NSDictionary).value(forKey: "shipping_id") as! String?
                
                let shippingDic:[String:String] = [
                    "first_name":txtFirstName.text!,"shipping_id":shipingId! ,"last_name":txtLastName.text!,"country":txtCountry.text!,"addressline1":txtAddressLine1.text!,"addressline2":txtAddressLine2.text!,"zip_code":txtZipCode.text!,"city":txtCity.text!,"state":txtState.text!,
                    ]
                let params: [String: AnyObject] = ["user_id": loginDetailDic.value(forKey: "id")as! String as AnyObject, "access_token": loginDetailDic.value(forKey: "access_token")as! String as AnyObject,"shipping_address": shippingDic as AnyObject]
                 print(params)
                AppManager.sharedManager.postDataOnserver(params: params as AnyObject, postUrl: Header.KEditAddress as NSString)

            }
            
            
            
            
           
           
            
        }
       
    }
    
    //MARK: Edit Address
    func editAddress(_ sender : UIButton)
    {
        UserDefaults.standard.set(sender.tag, forKey: "indexValue")
        
        isSaveAction = false
        btnSaveEdit.setTitle("Edit", for: .normal)
        self.view.addSubview(self.addressBookView)
        self.backImage.alpha = 0.0
        self.addressBookView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backImage.alpha = 0.5
            self.addressBookView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        })
        
        txtFirstName.text = (addresaArray[sender.tag]as!  NSDictionary).value(forKey: "first_name") as! String?
        txtLastName.text = (addresaArray[sender.tag]as!  NSDictionary).value(forKey: "last_name") as! String?
        txtAddressLine1.text = (addresaArray[sender.tag]as!  NSDictionary).value(forKey: "addressline1") as! String?
        txtAddressLine2.text = (addresaArray[sender.tag]as!  NSDictionary).value(forKey: "addressline2") as! String?
        txtCountry.text = (addresaArray[sender.tag]as!  NSDictionary).value(forKey: "country") as! String?
        txtZipCode.text = (addresaArray[sender.tag]as!  NSDictionary).value(forKey: "zip_code") as! String?
        txtState.text = (addresaArray[sender.tag]as!  NSDictionary).value(forKey: "state") as! String?
        txtCity.text = (addresaArray[sender.tag]as!  NSDictionary).value(forKey: "city") as! String?
        
        
        
        
    }
    
    //MARK:webservice delegate
    
    func serverReponse(responseDict: NSDictionary,serviceurl:NSString)
    {
        AppManager.sharedManager.inActivateView(self.view)
        if serviceurl as String == Header.KSaveAddress {
            
            print(responseDict.value(forKey: "shipping_address"))
            let result=responseDict.value(forKey: "result")as! Bool
            
            if result == true{
                self.crossAction(self)
                self.getAddress()
            }
            else{
                let alert = UIAlertController(title: "Error!", message: responseDict.value(forKey: "error") as! String?, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else if serviceurl as String == Header.KGetAddress
        {
            print(responseDict.value(forKey: "shipping_address"))
            let result=responseDict.value(forKey: "result")as! Bool
            
            
            if result == true{
                if(responseDict.value(forKey: "shipping_address") != nil){
                    addresaArray = responseDict.value(forKey: "shipping_address") as! NSArray
                    tableView.reloadData()
                }
                }
            else{
                let alert = UIAlertController(title: "Error!", message: responseDict.value(forKey: "error") as! String?, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
                    }
        
        else if serviceurl as String == Header.KEditAddress
        {
            print(responseDict.value(forKey: "shipping_address"))
            let result=responseDict.value(forKey: "result")as! Bool
            
            
            if result == true{
                self.crossAction(self)
                self.getAddress()
            }
            else{
                let alert = UIAlertController(title: "Error!", message: responseDict.value(forKey: "error") as! String?, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }

        }
        else if serviceurl as String == Header.KDeleteAddress
        {
            print(responseDict.value(forKey: "shipping_address"))
            let result=responseDict.value(forKey: "result")as! Bool
            
            
            if result == true{
                //self.crossAction(self)
                self.getAddress()
            }
            else{
                let alert = UIAlertController(title: "Error!", message: responseDict.value(forKey: "error") as! String?, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }

    }
    
    func failureRsponseError(failureError:NSError)
    {
        AppManager.sharedManager.inActivateView(self.view)
        let alert = UIAlertController(title: "Error!", message: "Something went wrong!", preferredStyle: UIAlertControllerStyle.alert)
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
