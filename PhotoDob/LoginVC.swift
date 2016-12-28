//
//  LoginVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 9/29/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class LoginVC: UIViewController ,WebServiceDelegate,UITextFieldDelegate{

    
    //MARK: Outlet
    @IBOutlet var btnForgot: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var btnSignIn: UIButton!
    
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationController?.isNavigationBarHidden = true

        //add navigation  button
        var image = UIImage(named: "close")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(LoginVC.returntoView))
        
        btnSignIn.addTarget(self, action: #selector(LoginVC.signInClick), for: .touchUpInside )
        UserDefaults.standard.set(true, forKey: "isSignIn")
        
        
        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!, forKey: NSFontAttributeName as NSCopying)
        segmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        
        
        if DeviceType.IS_IPHONE_6{
            
            segmentedControl.frame = CGRect(x: 37, y: 181, width: 300, height: 35)
            
        }
        else  if DeviceType.IS_IPHONE_6P{
            
            segmentedControl.frame = CGRect(x: 40, y: 192, width: 339, height: 41)
            
        }
        else  if DeviceType.IS_IPHONE_5{
            
            segmentedControl.frame = CGRect(x: 38, y: 150, width: 245, height: 38)
            
        }
        else  if DeviceType.IS_IPHONE_4_OR_LESS{
           segmentedControl.frame = CGRect(x: 38, y: 150, width: 245, height: 38)
            
        }
        
        txtEmail.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)


        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "email") != nil
        {
            txtEmail.text = UserDefaults.standard.value(forKey: "email")as? String ?? ""
            txtPassword.text = UserDefaults.standard.value(forKey: "password") as? String ?? ""
            btnSignIn.isSelected = true
            btnSignIn.isUserInteractionEnabled = true
        }else{
            btnSignIn.isSelected = false
            btnSignIn.isUserInteractionEnabled = false

        }
    }
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func forgotAction(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Alert", message: "Under process!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func textFieldDidChange() {
        if (AppManager.sharedManager.isValidEmail(emailText: txtEmail.text! as NSString) == true) && (txtPassword.text?.characters.count)! > 5{
            btnSignIn.isSelected = true
            btnSignIn.isUserInteractionEnabled = true
            UserDefaults.standard.set(txtEmail.text, forKey: "email")
            UserDefaults.standard.set(txtPassword.text, forKey: "password")
            
        }else{
            btnSignIn.isSelected = false
            btnSignIn.isUserInteractionEnabled = false
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "password")
        }
    }
    
    //MARK:text field delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    
    

    //MARK: segment Action
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            btnForgot.isHidden = false
            btnSignIn.setTitle("Sign In", for: UIControlState.normal)
            UserDefaults.standard.set(true, forKey: "isSignIn")
          
            break
        case 1:
            btnForgot.isHidden = true
             btnSignIn.setTitle("Sign Up", for: UIControlState.normal)
            UserDefaults.standard.set(false, forKey: "isSignIn")
            
            break
        default:
            break;
        }
        
    }
    
    func signInClick ()
    {
        
        if txtEmail.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please Enter Your Email.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else if txtPassword.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please Enter Your Password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            AppManager.sharedManager.delegate=self
            AppManager.sharedManager.activateView(self.view, loaderText: "Loading")
            
            if UserDefaults.standard.bool(forKey: "isSignIn") == true{
                let params: [String: AnyObject] = ["email": txtEmail.text! as AnyObject, "password": txtPassword.text! as AnyObject,"term": "1" as AnyObject,"device_token" : "skjdhsjdfhsuifdf654vd6f54g665d4f654df564ds5f645ds4f" as AnyObject,"device_type" : "ios" as AnyObject]
                
                AppManager.sharedManager.postDataOnserver(params: params as AnyObject, postUrl: Header.KLogin as NSString)
            }
            else{
                let params: [String: AnyObject] = ["email": txtEmail.text! as AnyObject, "password": txtPassword.text! as AnyObject,"term": "1" as AnyObject,"device_token" : "skjdhsjdfhsuifdf654vd6f54g665d4f654df564ds5f645ds4f" as AnyObject,"device_type" : "ios" as AnyObject]
                
                AppManager.sharedManager.postDataOnserver(params: params as AnyObject, postUrl: Header.KSignUP as NSString)
            }

        }
        
        
        
        
    
    }
    
    
    //MARK:webservice delegate
    
    func serverReponse(responseDict: NSDictionary,serviceurl:NSString)
    {
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        
        AppManager.sharedManager.inActivateView(self.view)
        if serviceurl as String == Header.KLogin {
            
           // print(responseDict.value(forKey: "details") as! NSDictionary)
            let result=responseDict.value(forKey: "result")as! Bool
            
            
            if result == true{
                
                let accountVC = storyBoard.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
                self.navigationController?.pushViewController(accountVC, animated: true)
                
                let alert = UIAlertController(title: "Alert", message: "You have successfully Logged in!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                UserDefaults.standard.set(true, forKey: "isLogedIn")
                UserDefaults.standard.set(responseDict.value(forKey: "details"), forKey: "LoginDetailDic")
            }
            else{
                let alert = UIAlertController(title: "Alert", message: responseDict.value(forKey: "error")as? String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                UserDefaults.standard.set(false, forKey: "isLogedIn")
            }
            
            
            

            

            
                    }
        else if serviceurl as String == Header.KSignUP
        {
            
            let result=responseDict.value(forKey: "result")as! Bool
            
            
            if result == true{
                
                let accountVC = storyBoard.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
                self.navigationController?.pushViewController(accountVC, animated: true)
                
                let alert = UIAlertController(title: "Alert", message: "You are successfully registered!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                UserDefaults.standard.set(true, forKey: "isLogedIn")
                UserDefaults.standard.set(responseDict.value(forKey: "details"), forKey: "LoginDetailDic")
            }
            else{
                let alert = UIAlertController(title: "Alert", message: responseDict.value(forKey: "error")as? String, preferredStyle: UIAlertControllerStyle.alert)
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
