//
//  OrderRiviewVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 11/10/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class OrderRiviewVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,WebServiceDelegate,PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate{

    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var resultText = "" // empty
    var payPalConfig = PayPalConfiguration() // default
    
    @IBOutlet var shippingAddressView: UIView!
    @IBOutlet var editShippingView: UIView!
    @IBOutlet var paymentView: UIView!
    
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var backImageShiping: UIImageView!
    @IBOutlet var backImagePayment: UIImageView!
    
    
    @IBOutlet var tableAddress: UITableView!
    //edit shiping view outlets
    
    @IBOutlet var lblEditAddress: UILabel!
    @IBOutlet var btnEdit: UIButton!
    
    
    
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblContactNumber: UITextField!
    
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddress1: UILabel!
    @IBOutlet var lblAddress2: UILabel!
    @IBOutlet var lblState: UILabel!
    @IBOutlet var lblContry: UILabel!
    
    
    //MARK: Add/Edit address
    
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtAddresLine1: UITextField!
    @IBOutlet var txtAddressLine2: UITextField!
    @IBOutlet var txtZipCode: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtState: UITextField!
    
    
    //Payment view outlets
    
    
    var loginDetailDic = NSDictionary()
    var arrayAddress =  NSArray()
    
    var isSaveAction = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Order Review"
        
        if(UserDefaults.standard.value(forKey: "LoginDetailDic") != nil){
            loginDetailDic =  UserDefaults.standard.value(forKey: "LoginDetailDic")as! NSDictionary
            print(loginDetailDic)
            
            lblEmail.text = loginDetailDic.value(forKey: "email")as? String
            // Do any additional setup after loading the view.
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please Login First!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            

        
        
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(OrderRiviewVC.returntoView))
       
        self.getAddress()
        
        
        // Do any additional setup after loading the view.
        
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "PhotoDob, Inc."
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        // Setting the languageOrLocale property is optional.
        //
        // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
        // its user interface according to the device's current language setting.
        //
        // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
        // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
        // to use that language/locale.
        //
        // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
        
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        
        // Setting the payPalShippingAddressOption property is optional.
        //
        // See PayPalConfiguration.h for details.
        
        payPalConfig.payPalShippingAddressOption = .payPal;
        
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
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
    
    
    @IBAction func editContactAction(_ sender: AnyObject) {
        
    }
    
    //MARK: Edit shipping Action
    @IBAction func editShippingAddAction(_ sender: AnyObject) {
        
        self.view.addSubview(self.shippingAddressView)
        self.backImage.alpha = 0.0
        self.shippingAddressView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backImage.alpha = 0.5
            self.shippingAddressView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    

    @IBAction func crossEdidShipingAddressAction(_ sender: AnyObject) {
        
        self.backImage.alpha = 0.5
        self.shippingAddressView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backImage.alpha = 0.0
            self.shippingAddressView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        })

    }
    
    @IBAction func addShippingAddressAction(_ sender: AnyObject) {
        
        isSaveAction = true
        
        self.btnEdit.setTitle("Save", for: .normal)
        self.lblEditAddress.text = "New Address"
        
        self.view.addSubview(self.editShippingView)
        self.backImageShiping.alpha = 0.0
        self.editShippingView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backImageShiping.alpha = 0.5
            self.editShippingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        })
        
    }
    
    @IBAction func crossEditShippingView(_ sender: AnyObject) {
        
        self.view.addSubview(self.editShippingView)
        self.backImageShiping.alpha = 0.5
        self.editShippingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backImageShiping.alpha = 0.0
            self.editShippingView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    //MARK: Add Payment Action
    @IBAction func addPaymentAction(_ sender: AnyObject) {
        
        self.view.addSubview(self.paymentView)
        self.backImagePayment.alpha = 0.0
        self.paymentView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backImagePayment.alpha = 0.5
            self.paymentView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        })

    }
    
    @IBAction func crossPaymentAction(_ sender: AnyObject) {
        
        self.view.addSubview(self.paymentView)
        self.backImagePayment.alpha = 0.5
        self.paymentView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backImagePayment.alpha = 0.0
            self.paymentView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    
    
    @IBAction func addEditAddressAction(_ sender: AnyObject) {
        
        
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
            
        else if txtAddresLine1.text == "" {
            
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
                if arrayAddress.count > 0{
                    
                    shipingId = ((arrayAddress[arrayAddress.count-1]as!  NSDictionary).value(forKey: "shipping_id") as! String?)!
                    shipingId = String(Int(shipingId)!+1)
                }
                else{
                    shipingId = "1"
                }
                
                /* let x : Int = addresaArray.count + 1
                 let shipingId = String(x)
                 */
                let shippingDic:[String:String] = [
                    "first_name":txtFirstName.text!,"shipping_id":shipingId ,"last_name":txtLastName.text!,"country":txtCountry.text!,"addressline1":txtAddresLine1.text!,"addressline2":txtAddressLine2.text!,"zip_code":txtZipCode.text!,"city":txtCity.text!,"state":txtState.text!,
                    ]
                let params: [String: AnyObject] = ["user_id": loginDetailDic.value(forKey: "id")as! String as AnyObject, "access_token": loginDetailDic.value(forKey: "access_token")as! String as AnyObject,"shipping_address": shippingDic as AnyObject]
                print(params)
                AppManager.sharedManager.postDataOnserver(params: params as AnyObject, postUrl: Header.KSaveAddress as NSString)
                
            }else{
                let x : Int =  UserDefaults.standard.value(forKey: "indexValue") as! Int
                let shipingId = (arrayAddress[x]as!  NSDictionary).value(forKey: "shipping_id") as! String?
                
                let shippingDic:[String:String] = [
                    "first_name":txtFirstName.text!,"shipping_id":shipingId! ,"last_name":txtLastName.text!,"country":txtCountry.text!,"addressline1":txtAddresLine1.text!,"addressline2":txtAddressLine2.text!,"zip_code":txtZipCode.text!,"city":txtCity.text!,"state":txtState.text!,
                    ]
                let params: [String: AnyObject] = ["user_id": loginDetailDic.value(forKey: "id")as! String as AnyObject, "access_token": loginDetailDic.value(forKey: "access_token")as! String as AnyObject,"shipping_address": shippingDic as AnyObject]
                print(params)
                AppManager.sharedManager.postDataOnserver(params: params as AnyObject, postUrl: Header.KEditAddress as NSString)
                
            }
            
            
            
            
            
            
            
        }

        
    }
    
    
    
    //MARK:table view datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayAddress.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressBookCell")! as! AddressBookCell
        
        cell.btnEdit.addTarget(self, action: #selector(OrderRiviewVC.editShippingAddressFromCell(_:)), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.row
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if indexPath.row == 0 {
            cell.selectEditBtn.isSelected = true
        }else{
            cell.selectEditBtn.isSelected = false
        }
        
        
        
        cell.lblName.text = "\(((arrayAddress[indexPath.row] as! NSDictionary).value(forKey: "first_name")as!String) ) \(((arrayAddress[indexPath.row] as! NSDictionary).value(forKey: "last_name")as!String))"
        cell.lblAddress1.text = (arrayAddress[indexPath.row] as! NSDictionary).value(forKey: "addressline1")as?String
        cell.lblAddress2.text = (arrayAddress[indexPath.row] as! NSDictionary).value(forKey: "addressline2")as?String
        cell.lblState.text = (arrayAddress[indexPath.row] as! NSDictionary).value(forKey: "state")as?String
        cell.lblCountry.text = (arrayAddress[indexPath.row] as! NSDictionary).value(forKey: "country")as?String

        
        return cell
    }
    
   
    
    
    //MARK:table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let cell = tableView.cellForRow(at: indexPath) as! AddressBookCell
        
        if cell.selectEditBtn.isSelected == true {
            cell.selectEditBtn.isSelected = false
        }
        else if cell.selectEditBtn.isSelected == false {
            cell.selectEditBtn.isSelected = true
        }
    }
    
    
    //MARK:place order action
    
    @IBAction func placeOrderAction(_ sender: AnyObject) {
        
        if (lblEmail.text == ""){
            let alert = UIAlertController(title: "Alert", message: "Please fill Email Address!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (lblContactNumber.text == ""){
            let alert = UIAlertController(title: "Alert", message: "Please fill Contact Number!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            
            
            self.orderByPayPal()
            //self.authorizeFuturePaymentsAction(self)
            
            
          /*  let alert = UIAlertController(title: "Alert", message: "Your Product details has been send to your email ?", preferredStyle: UIAlertControllerStyle.alert)
            //event handler with closure
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                
                let arr = DBManager.sharedManager.fetchDeatilsOfCartFromDB()//remove value from database by size when changed size
                print(arr)
                DBManager.sharedManager.deleteRecordsFromDB(arr)
                
              
            }))
            
            _ = navigationController?.popViewController(animated: true)
            self.present(alert, animated: true, completion: nil)*/
           
        }
        
        
    }
    
    func orderByPayPal()
    {
        // Remove our last completed payment, just for demo purposes.
        resultText = ""
        
        // Note: For purposes of illustration, this example shows a payment that includes
        //       both payment details (subtotal, shipping, tax) and multiple items.
        //       You would only specify these if appropriate to your situation.
        //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
        //       and simply set payment.amount to your total charge.
        
        // Optional: include multiple items
        let item1 = PayPalItem(name: "Old jeans with holes", withQuantity: 2, withPrice: NSDecimalNumber(string: "84.99"), withCurrency: "USD", withSku: "Hip-0037")
        let item2 = PayPalItem(name: "Free rainbow patch", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.00"), withCurrency: "USD", withSku: "Hip-00066")
        let item3 = PayPalItem(name: "Long-sleeve plaid shirt (mustache not included)", withQuantity: 1, withPrice: NSDecimalNumber(string: "37.99"), withCurrency: "USD", withSku: "Hip-00291")
        
        let items = [item1, item2, item3]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "5.99")
        let tax = NSDecimalNumber(string: "2.50")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "PhotoDob", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            print("Payment not processalbe: \(payment)")
        }

    }
        
        
        // PayPalPaymentDelegate
        
        func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
            print("PayPal Payment Cancelled")
            resultText = ""
            //successView.isHidden = true
            paymentViewController.dismiss(animated: true, completion: nil)
        }
        
        func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
            print("PayPal Payment Success !")
            paymentViewController.dismiss(animated: true, completion: { () -> Void in
                // send completed confirmaion to your server
                print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
                
                self.resultText = completedPayment.description
                //self.showSuccess()
            })
        }
        
        
        // MARK: Future Payments
        
        func authorizeFuturePaymentsAction(_ sender: AnyObject) {
            let futurePaymentViewController = PayPalFuturePaymentViewController(configuration: payPalConfig, delegate: self)
            present(futurePaymentViewController!, animated: true, completion: nil)
        }
        
        
        func payPalFuturePaymentDidCancel(_ futurePaymentViewController: PayPalFuturePaymentViewController) {
            print("PayPal Future Payment Authorization Canceled")
            //successView.isHidden = true
            futurePaymentViewController.dismiss(animated: true, completion: nil)
        }
        
        func payPalFuturePaymentViewController(_ futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [AnyHashable: Any]) {
            print("PayPal Future Payment Authorization Success!")
            // send authorization to your server to get refresh token.
            futurePaymentViewController.dismiss(animated: true, completion: { () -> Void in
                self.resultText = futurePaymentAuthorization.description
                //self.showSuccess()
            })
        }
        
        // MARK: Profile Sharing
        
        func authorizeProfileSharingAction(_ sender: AnyObject) {
            let scopes = [kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]
            let profileSharingViewController = PayPalProfileSharingViewController(scopeValues: NSSet(array: scopes) as Set<NSObject>, configuration: payPalConfig, delegate: self)
            present(profileSharingViewController!, animated: true, completion: nil)
        }
        
        // PayPalProfileSharingDelegate
        
        func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController) {
            print("PayPal Profile Sharing Authorization Canceled")
            //successView.isHidden = true
            profileSharingViewController.dismiss(animated: true, completion: nil)
        }
        
        func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable: Any]) {
            print("PayPal Profile Sharing Authorization Success!")
            
            // send authorization to your server
            
            profileSharingViewController.dismiss(animated: true, completion: { () -> Void in
                self.resultText = profileSharingAuthorization.description
                //self.showSuccess()
            })
            
        }

        
    
    func editShippingAddressFromCell(_ sender: UIButton) {
        
         UserDefaults.standard.set(sender.tag, forKey: "indexValue")
        
        isSaveAction = false
        self.btnEdit.setTitle("Edit", for: .normal)
        self.lblEditAddress.text = "Edit Address"
        print(sender.tag)
        
        self.view.addSubview(self.editShippingView)
        self.backImageShiping.alpha = 0.0
        self.editShippingView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backImageShiping.alpha = 0.5
            self.editShippingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        })
        
        
        txtFirstName.text = (arrayAddress[sender.tag]as!  NSDictionary).value(forKey: "first_name") as! String?
        txtLastName.text = (arrayAddress[sender.tag]as!  NSDictionary).value(forKey: "last_name") as! String?
        txtAddresLine1.text = (arrayAddress[sender.tag]as!  NSDictionary).value(forKey: "addressline1") as! String?
        txtAddressLine2.text = (arrayAddress[sender.tag]as!  NSDictionary).value(forKey: "addressline2") as! String?
        txtCountry.text = (arrayAddress[sender.tag]as!  NSDictionary).value(forKey: "country") as! String?
        txtZipCode.text = (arrayAddress[sender.tag]as!  NSDictionary).value(forKey: "zip_code") as! String?
        txtState.text = (arrayAddress[sender.tag]as!  NSDictionary).value(forKey: "state") as! String?
        txtCity.text = (arrayAddress[sender.tag]as!  NSDictionary).value(forKey: "city") as! String?
       

    }
    
    
    //MARK:webservice delegate
    
    func serverReponse(responseDict: NSDictionary,serviceurl:NSString)
    {
        AppManager.sharedManager.inActivateView(self.view)
        if serviceurl as String == Header.KSaveAddress {
            
            print(responseDict.value(forKey: "shipping_address"))
            let result=responseDict.value(forKey: "result")as! Bool
            
            if result == true{
                self.crossEditShippingView(self)
                self.crossEdidShipingAddressAction(self)
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
            print(responseDict)
            
            
            if result == true{
                if(responseDict.value(forKey: "shipping_address") != nil){
                    arrayAddress = NSArray()
                    arrayAddress = responseDict.value(forKey: "shipping_address") as! NSArray
                    if(arrayAddress.count > 0){
                        lblName.text = "\(((arrayAddress[0] as! NSDictionary).value(forKey: "first_name")as!String) ) "
                        lblAddress1.text = (arrayAddress[0] as! NSDictionary).value(forKey: "addressline1")as?String
                        lblAddress2.text = (arrayAddress[0] as! NSDictionary).value(forKey: "addressline2")as?String
                        lblState.text = (arrayAddress[0] as! NSDictionary).value(forKey: "state")as?String
                        lblContry.text = (arrayAddress[0] as! NSDictionary).value(forKey: "country")as?String
                        
                        tableAddress.dataSource = self
                        tableAddress.delegate = self
                        tableAddress.reloadData()
                    }
                  
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
                self.crossEditShippingView(self)
                self.crossEdidShipingAddressAction(self)
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
