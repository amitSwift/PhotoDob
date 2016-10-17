//
//  PrintingAlbumVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/7/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class PrintingAlbumVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AlbumVC.returntoView))
        
        
        //add right navigation  button
        var imageInfo = UIImage(named: "tick")
        imageInfo = imageInfo?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageInfo, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AlbumVC.clickOnTick))
        
        
    }
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cameraAction(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Alert", message: "Under process!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


    
    @IBAction func fotoliaAction(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Alert", message: "Under process!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: table view datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell")! as! AlbumCell
        
        cell.lblAlbumName?.text = "WhatsApp Images"
        cell.detailTextLabel?.text = "200 Photo"
        cell.imageAlbum?.image = UIImage(named: "review-img")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cropVC = storyBoard.instantiateViewController(withIdentifier: "TapToCrop") as! TapToCrop
        self.navigationController?.pushViewController(cropVC, animated: true)
        
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
