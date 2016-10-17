//
//  TapToCrop.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/3/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class TapToCrop: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "1"
        
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(TapToCrop.returntoView))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:tableview delegate
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    return 5
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FrameCell")! as! FrameCell
        
        cell.tapPhotoToCrop.addTarget(self, action: #selector(pressedForCroping(sender:)), for: .touchUpInside)
        cell.tapPhotoToCrop.tag = indexPath.row
        
        return cell
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        
        let lblReview = UILabel()
        lblReview.frame = CGRect(x: 0, y: 10, width: Int(self.view.frame.size.width), height: 30)
        lblReview.textAlignment = .center
        lblReview.textColor = UIColor.white
        lblReview.text = "REVIEW AND CROP"
        vw.addSubview(lblReview)
        
        let lblDescribe = UILabel()
        lblDescribe.frame = CGRect(x: 0, y: 45, width: Int(self.view.frame.size.width), height: 60)
        lblDescribe.textAlignment = .center
        lblDescribe.numberOfLines = 3
        lblDescribe.textColor = UIColor.white
        lblDescribe.font =  lblDescribe.font.withSize(12)
        lblDescribe.text = "Scroll to review your print,and tap any image to adjust the crop.Your photo will look like this in real life,including borders nd white spaces."

        vw.addSubview(lblDescribe)
        
        return vw
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
     {
        return  100
    }

    
    func pressedForCroping(sender: UIButton!) {
        
        let cropVC = storyBoard.instantiateViewController(withIdentifier: "CropVC") as! CropVC
        //self.present(cropVC, animated: true, completion: nil)
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
