//
//  LoginVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 9/29/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class LoginVC: UIViewController ,WebServiceDelegate{

    
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
        
        // Do any additional setup after loading the view.
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
    
    
    //MARK:webservice delegate
    
    func serverReponse(responseDict: NSDictionary,serviceurl:NSString)
    {
        AppManager.sharedManager.inActivateView(self.view)
        if serviceurl as String == Header.KLogin {
            
            print(responseDict.value(forKey: "status"))
            let result=responseDict.value(forKey: "result")as! Bool
            
            
            if result == true{
                let alert = UIAlertController(title: "Alert", message: "You have successfully Login!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                UserDefaults.standard.set(true, forKey: "isLogedIn")
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
                let alert = UIAlertController(title: "Alert", message: "You have successfully Registers!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
