//
//  InfoVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/3/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit



class InfoVC: UIViewController,UITableViewDelegate,UITableViewDataSource ,WebServiceDelegate{
    
    var arrAccount = NSArray()
    var arr = NSArray()
    var loginDetailDic = NSDictionary()
    
    
    @IBOutlet var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Info"
        
        
        
        
        //add navigation  button
        var image = UIImage(named: "close")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(InfoVC.returntoView))
        
        tableView.tableFooterView = UIView()
        
        
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
        
        if(UserDefaults.standard.value(forKey: "LoginDetailDic")as? NSDictionary != nil){
            loginDetailDic =  UserDefaults.standard.value(forKey: "LoginDetailDic")as! NSDictionary
            print(loginDetailDic)
        }
        
        if UserDefaults.standard.bool(forKey: "isLogedIn") == true{
            arrAccount = ["Account", "Sign Out"]
        }
        else{
            arrAccount = ["Account"]
        }
        
        arr = ["About Social print studio", "FAQ", "Shipping", "Share your love", "Contact"]
        tableView.reloadData()
        
    }

    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:get album
    
    
        
    
    
    
    
    //MARK:tableview delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrAccount.count
        }else{
           return arr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell")! as! InfoCell
        
        if indexPath.section == 0 {
            cell.lblName.text = arrAccount[indexPath.row] as? String
        }else{
            cell.lblName.text = arr[indexPath.row] as? String
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 && indexPath.section == 0{
            if UserDefaults.standard.bool(forKey: "isLogedIn") == true{
                let accountVC = storyBoard.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
                self.navigationController?.pushViewController(accountVC, animated: true)
            }else{
                let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
            
            
        }
            
        else if indexPath.row == 1 && indexPath.section == 0{
            self.logOut()
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Under process!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        

    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        
        return vw
    }
    
    func logOut(){
        
        AppManager.sharedManager.delegate=self
        AppManager.sharedManager.activateView(self.view, loaderText: "Loading")
        let params: [String: AnyObject] = ["user_id": loginDetailDic.value(forKey: "id")as! String as AnyObject, "access_token": loginDetailDic.value(forKey: "access_token")as! String as AnyObject]
        
        print(params)
        AppManager.sharedManager.postDataOnserver(params: params as AnyObject, postUrl: Header.KLogOut as NSString)
    }
    
    //MARK:webservice delegate
    
    func serverReponse(responseDict: NSDictionary,serviceurl:NSString)
    {
        AppManager.sharedManager.inActivateView(self.view)
        if serviceurl as String == Header.KLogOut {
            
            print(responseDict.value(forKey: "shipping_address"))
            let result=responseDict.value(forKey: "result")as! Bool
            
            if result == true{
                let alert = UIAlertController(title: "Alert!", message: "You have successfuly Logged out", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                UserDefaults.standard.set(false, forKey: "isLogedIn")
                arrAccount = ["Account"]
                tableView.reloadData()
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
