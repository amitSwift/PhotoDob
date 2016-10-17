//
//  InfoVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/3/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit



class InfoVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var arrAccount = NSArray()
    var arr = NSArray()
    
    
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
            let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(loginVC, animated: true)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
