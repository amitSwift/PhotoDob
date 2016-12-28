//
//  PrintingVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 11/21/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class PrintingVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    //MARK: outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var lblSize: UILabel!
    @IBOutlet var pageControler: UIPageControl!
    
    @IBOutlet var infoView: UIView!
    @IBOutlet var customView: UIView!
    @IBOutlet var sizeView: UIView!
    
    @IBOutlet var btnSelect: UIButton!
    @IBOutlet var btnCustomSize: UIButton!
    
    @IBOutlet var lblPrice: UILabel!
    
    
    @IBOutlet var btn20x30: UIButton!
    @IBOutlet var btn40x60: UIButton!
    @IBOutlet var btn70x80: UIButton!
    @IBOutlet var btn70x90: UIButton!
    
    
    @IBOutlet var txtWidthCustum: UITextField!
    @IBOutlet var txtHeightCustom: UITextField!
    
    
    @IBOutlet var infoBackGroundImage: UIImageView!
    @IBOutlet var cusumSizeBackGroundImage: UIImageView!
    
    
    //MARK: variable
    var imageWidth = String()
    var imageHeight = String()
    
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
     var productType = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Printing" 
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // Do any additional setup after loading the view, typically from a nib
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: screenWidth , height: screenWidth)
        collectionView!.collectionViewLayout = layout
        
        
       
        
        if DeviceType.IS_IPHONE_6{
            collectionView.frame = CGRect(x: 0, y: 54, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width)-54)
            lblSize.frame = CGRect(x: 0, y: Int(self.view.frame.size.width), width: Int(self.view.frame.size.width), height: Int(lblSize.frame.size.height))
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: Int(self.view.frame.size.width)-40, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            lblPrice.frame = CGRect(x: 105, y: 528, width: 164, height: 21)
            
            btnCustomSize.frame = CGRect(x: 60, y: Int(self.view.frame.size.width)+Int(lblSize.frame.size.height)+20, width: 110, height: 30)
            btnSelect.frame = CGRect(x: 210, y: Int(self.view.frame.size.width)+Int(lblSize.frame.size.height)+20, width: 110, height: 30)
        }
        else  if DeviceType.IS_IPHONE_6P{
            collectionView.frame = CGRect(x: 0, y: 54, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width)-54)
            lblSize.frame = CGRect(x: 0, y: Int(self.view.frame.size.width), width: Int(self.view.frame.size.width), height: Int(lblSize.frame.size.height))
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: Int(self.view.frame.size.width)-40, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
             lblPrice.frame = CGRect(x: 120, y: 577, width: 164, height: 21)
            btnCustomSize.frame = CGRect(x: 60, y: Int(self.view.frame.size.width)+Int(lblSize.frame.size.height)+20, width: 110, height: 30)
            btnSelect.frame = CGRect(x: 210, y: Int(self.view.frame.size.width)+Int(lblSize.frame.size.height)+20, width: 110, height: 30)
        }
        else  if DeviceType.IS_IPHONE_5{
            collectionView.frame = CGRect(x: 0, y: 54, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width)-54)
            lblSize.frame = CGRect(x: 0, y: Int(self.view.frame.size.width), width: Int(self.view.frame.size.width), height: Int(lblSize.frame.size.height))
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: Int(self.view.frame.size.width)-40, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            lblPrice.frame = CGRect(x: 78, y: 440, width: 164, height: 21)
            btnCustomSize.frame = CGRect(x: 43, y: Int(self.view.frame.size.width)+Int(lblSize.frame.size.height)+20, width: 110, height: 30)
            btnSelect.frame = CGRect(x: 183, y: Int(self.view.frame.size.width)+Int(lblSize.frame.size.height)+20, width: 110, height: 30)
            
        }
        else  if DeviceType.IS_IPHONE_4_OR_LESS{
            collectionView.frame = CGRect(x: 0, y: 54, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width)-54)
            lblSize.frame = CGRect(x: 0, y: Int(self.view.frame.size.width), width: Int(self.view.frame.size.width), height: Int(lblSize.frame.size.height))
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: Int(self.view.frame.size.width)-40, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            
        }

        
        print(collectionView.frame)
        
        //uork on page controller
        pageControler.numberOfPages = 4
        pageControler.currentPage = 0
        //pageControler.center = self.view.center
        
        
        self.view.bringSubview(toFront: pageControler)
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PrintingVC.returntoView))
        
        
        //add right navigation  button
        var imageInfo = UIImage(named: "question-mark")
        imageInfo = imageInfo?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageInfo, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PrintingVC.showInfoView))

        

        if productType == "tshirtPrintind" {
            self.selectSizeAction(self)
            self.tshirtValidation()
        }
        else  if productType == "rollerBlindesPrinted"{
            self.selectSizeAction(self)
        }
        else  if productType == "cusionsPrinted" {
            btnSelect.isHidden = true
            btnCustomSize.isHidden = true
            self.cusionPrintedValidation()
        }
        else  if productType == "toteBagPrinted" {
            btnSelect.isHidden = true
            btnCustomSize.isHidden = true
        }
        
        
        
        
        let tapgestureInfo = UITapGestureRecognizer(target: self, action: #selector(PrintingVC.tapGestureInfoView))
        infoBackGroundImage.addGestureRecognizer(tapgestureInfo)
        
        let tapgestureCustom = UITapGestureRecognizer(target: self, action: #selector(PrintingVC.tapGestureCustomView))
        cusumSizeBackGroundImage.addGestureRecognizer(tapgestureCustom)
       
        
        

        // Do any additional setup after loading the view.
    }
    
    
    func tapGestureInfoView()
    {
        sizeView.removeFromSuperview()
    }
    
    func tapGestureCustomView() {
        customView.removeFromSuperview()
    }
    
    func tshirtValidation()
    {
        if UserDefaults.standard.bool(forKey: "isPrintCustomSize") == false
        {
            
            if UserDefaults.standard.value(forKey: "selectedSize") != nil{
                
                if UserDefaults.standard.value(forKey: "selectedSize")as! String == "0"{
                    imageWidth = "20"
                    imageHeight = "30"
                    UserDefaults.standard.set("0", forKey: "selectedSize")
                    btn20x30.isSelected = true
                    
                }else if UserDefaults.standard.value(forKey: "selectedSize")as! String == "1"{
                    UserDefaults.standard.set("1", forKey: "selectedSize")
                    imageWidth = "40"
                    imageHeight = "60"
                    btn40x60.isSelected = true
                }
                else if UserDefaults.standard.value(forKey: "selectedSize")as! String == "2"{
                    UserDefaults.standard.set("2", forKey: "selectedSize")
                    imageWidth = "70"
                    imageHeight = "80"
                    btn70x80.isSelected = true
                }
                else if UserDefaults.standard.value(forKey: "selectedSize")as! String == "3"{
                    UserDefaults.standard.set("3", forKey: "selectedSize")
                    imageWidth = "70"
                    imageHeight = "90"
                    btn70x90.isSelected = true
                }
                
            }
            else{
                UserDefaults.standard.set("1", forKey: "selectedSize")
                imageWidth = "40"
                imageHeight = "60"
                btn40x60.isSelected = true
                
            }
            
            Header.appDelegate.imageWidthForCrop = imageWidth //give width for croping
            Header.appDelegate.imageHeightForCrop = imageHeight //give height for croping
            
            UserDefaults.standard.set(imageHeight, forKey: "imageHeightForCrop")
            UserDefaults.standard.set(imageWidth, forKey: "imageWidthForCrop")
            
            UserDefaults.standard.set(false, forKey: "isPrintCustomSize")
            
            lblSize.text = "\(imageWidth)x\(imageHeight) CM"
            
            Header.appDelegate.SizeName = lblSize.text!
            
            
        }
        else{
            sizeView.removeFromSuperview()
            
            imageWidth = UserDefaults.standard.value(forKey: "imageWidthForCrop") as! String
            imageHeight = UserDefaults.standard.value(forKey: "imageHeightForCrop") as! String
            
            Header.appDelegate.imageWidthForCrop = imageWidth //give width for croping
            Header.appDelegate.imageHeightForCrop = imageHeight //give height for croping
           
            
            lblSize.text = "\(imageWidth)x\(imageHeight) CM"
            
            Header.appDelegate.SizeName = lblSize.text!
        }

        
    }
    
    func cusionPrintedValidation(){
        imageWidth = "50"
        imageHeight = "50"
        
        Header.appDelegate.imageWidthForCrop = imageWidth //give width for croping
        Header.appDelegate.imageHeightForCrop = imageHeight //give height for croping
        UserDefaults.standard.set(imageHeight, forKey: "imageHeightForCrop")
        UserDefaults.standard.set(imageWidth, forKey: "imageWidthForCrop")
        
         lblSize.text = "\(imageWidth)x\(imageHeight) inches"
        Header.appDelegate.SizeName = lblSize.text!
        

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sizeRadioBtnAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            if btn20x30.isSelected == true {
                btn20x30.isSelected = false
                btn40x60.isSelected = false
                btn70x80.isSelected = false
                btn70x90.isSelected = false
            }
            else{
                btn20x30.isSelected = true
                btn40x60.isSelected = false
                btn70x80.isSelected = false
                btn70x90.isSelected = false
                
                lblSize.text = "Unprinted Adult"
                sizeView.removeFromSuperview()
            }
            
            imageWidth = "20"
            imageHeight = "30"
            
            UserDefaults.standard.set("0", forKey: "selectedSize")
            
        }
        else if sender.tag == 1{
            if btn40x60.isSelected == true {
                btn40x60.isSelected = false
                btn20x30.isSelected = false
                btn70x80.isSelected = false
                btn70x90.isSelected = false
            }
            else{
                btn40x60.isSelected = true
                btn20x30.isSelected = false
                btn70x80.isSelected = false
                btn70x90.isSelected = false
                
                lblSize.text = "Unprinted Youth"
                sizeView.removeFromSuperview()
            }
            
            UserDefaults.standard.set("1", forKey: "selectedSize")
            
            imageWidth = "40"
            imageHeight = "60"
        }
        else if sender.tag == 2{
            if btn70x80.isSelected == true {
                btn70x80.isSelected = false
                btn20x30.isSelected = false
                btn40x60.isSelected = false
                btn70x90.isSelected = false
            }
            else{
                btn70x80.isSelected = true
                btn20x30.isSelected = false
                btn40x60.isSelected = false
                btn70x90.isSelected = false
                
                lblSize.text = "One side Printing"
                sizeView.removeFromSuperview()
            }
            
            UserDefaults.standard.set("2", forKey: "selectedSize")
            
            imageWidth = "70"
            imageHeight = "80"
            
        }
        else if sender.tag == 3{
            if btn70x90.isSelected == true {
                btn70x90.isSelected = false
                btn20x30.isSelected = false
                btn40x60.isSelected = false
                btn70x80.isSelected = false
            }
            else{
                btn70x90.isSelected = true
                btn20x30.isSelected = false
                btn40x60.isSelected = false
                btn70x80.isSelected = false
                
                lblSize.text = "Double Side Printing"
                sizeView.removeFromSuperview()
            }
            UserDefaults.standard.set("3", forKey: "selectedSize")
            
            imageWidth = "70"
            imageHeight = "90"
        }
        
        Header.appDelegate.imageWidthForCrop = imageWidth //give width for croping
        Header.appDelegate.imageHeightForCrop = imageHeight //give height for croping
        
        UserDefaults.standard.set(imageHeight, forKey: "imageHeightForCrop")
        UserDefaults.standard.set(imageWidth, forKey: "imageWidthForCrop")
        
         UserDefaults.standard.set(false, forKey: "isPrintCustomSize")
        
        lblSize.text = "\(imageWidth)x\(imageHeight) CM"
        Header.appDelegate.SizeName = lblSize.text!
        
        
    }

    
    
    
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func showInfoView() {
        
        infoView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(infoView)
    }
    @IBAction func closeAction(_ sender: AnyObject) {
        
        infoView.removeFromSuperview()
    }
    
    
    @IBAction func doneAction(_ sender: AnyObject) {
        
        
        if txtWidthCustum.text == ""{
            let alert = UIAlertController(title: "Alert", message: "Please fill Width.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
            
            self.present(alert, animated: true, completion: nil)
            
        }else if txtHeightCustom.text == ""{
            let alert = UIAlertController(title: "Alert", message: "Please fill Height.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
            
            self.present(alert, animated: true, completion: nil)
        }else{
            
            UserDefaults.standard.set(true, forKey: "isPrintCustomSize")
            UserDefaults.standard.removeObject(forKey: "selectedSize")
            
            infoView.removeFromSuperview()
            customView.removeFromSuperview()
            
            btn20x30.isSelected = false
            btn40x60.isSelected = false
            btn70x80.isSelected = false
            btn70x90.isSelected = false
            
            imageWidth = txtWidthCustum.text!
            imageHeight = txtHeightCustom.text!
            
            Header.appDelegate.imageWidthForCrop = imageWidth //give width for croping
            Header.appDelegate.imageHeightForCrop = imageHeight //give height for croping
            UserDefaults.standard.set(imageHeight, forKey: "imageHeightForCrop")
            UserDefaults.standard.set(imageWidth, forKey: "imageWidthForCrop")
            
            lblSize.text = "\(txtWidthCustum.text!)x\(txtHeightCustom.text!) CM"
            
            Header.appDelegate.SizeName = lblSize.text!
        }

        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let pCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrintVCCell", for: indexPath) as! PrintVCCell
        
        let imageName = "4x4-image"
        
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.frame = CGRect(x: 0, y: -10, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width))
        pCell.contentView.addSubview(imageView)
        
        
        
        return pCell
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell: UICollectionViewCell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)!
            print("\(indexPath)")
            pageControler.currentPage = indexPath.row
        }
    }
    
    
    //MARK:CustomSize Work
    
    @IBAction func customSizeAction(_ sender: AnyObject) {
        customView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(customView)
    }
    
    @IBAction func selectSizeAction(_ sender: AnyObject) {
        sizeView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(sizeView)
    }


    
    
    @IBAction func selectAction(_ sender: AnyObject) {
        
        if(UserDefaults.standard.value(forKey: "ProductName") != nil){
            
            if(Header.appDelegate.ProductName != UserDefaults.standard.value(forKey: "ProductName") as! String  ){
                
                self.productNameValidation()
            }
            else if(Header.appDelegate.SizeName != UserDefaults.standard.value(forKey: "SizeName") as! String){
                self.sizeOfProductValidation()
            }
            else{
                let albumVC = storyBoard.instantiateViewController(withIdentifier: "AlbumVC") as! AlbumVC
                if productType == "tshirtPrintind" {
                    UserDefaults.standard.set("tshirt", forKey: "productType")
                }
                else  if productType == "cusionsPrinted" {
                    UserDefaults.standard.set("cusions", forKey: "productType")
                }
                else  if productType == "toteBagPrinted" {
                    UserDefaults.standard.set("toteBag", forKey: "productType")
                }
                self.navigationController?.pushViewController(albumVC, animated: true)
                
            }
        }
            
            
        else if(UserDefaults.standard.value(forKey: "SizeName") != nil){
            
            if(Header.appDelegate.SizeName != UserDefaults.standard.value(forKey: "SizeName") as! String){
                
                self.sizeOfProductValidation()
                
            }
            else{
                let albumVC = storyBoard.instantiateViewController(withIdentifier: "AlbumVC") as! AlbumVC
                if productType == "tshirtPrintind" {
                    UserDefaults.standard.set("tshirt", forKey: "productType")
                }
                else  if productType == "cusionsPrinted" {
                    UserDefaults.standard.set("cusions", forKey: "productType")
                }
                else  if productType == "toteBagPrinted" {
                    UserDefaults.standard.set("toteBag", forKey: "productType")
                }
                self.navigationController?.pushViewController(albumVC, animated: true)
                
                
            }
            
        }
            
        else{
            let albumVC = storyBoard.instantiateViewController(withIdentifier: "AlbumVC") as! AlbumVC
            if productType == "tshirtPrintind" {
                UserDefaults.standard.set("tshirt", forKey: "productType")
            }
            else  if productType == "cusionsPrinted" {
                UserDefaults.standard.set("cusions", forKey: "productType")
            }
            else  if productType == "toteBagPrinted" {
                UserDefaults.standard.set("toteBag", forKey: "productType")
            }
            self.navigationController?.pushViewController(albumVC, animated: true)
        }

        
        
        
    }
    
    func productNameValidation()
    {
        let alert = UIAlertController(title: "Alert", message: "You currently have \(UserDefaults.standard.value(forKey: "ProductName") as! String) selected.Are you sure want to change to \(Header.appDelegate.ProductName) Prints?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
        //event handler with closure
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            
            
            
            //need to work for remove saved value in database
            let arr = DBManager.sharedManager.fetchImagesByProductNameFromDB(UserDefaults.standard.value(forKey: "ProductName") as! String)//remove value from database by size when changed size
            print(arr)
            DBManager.sharedManager.deleteRecordsFromDB(arr)
            
            UserDefaults.standard.removeObject(forKey: "ProductName")
            UserDefaults.standard.removeObject(forKey: "SizeName")
            
            UserDefaults.standard.removeObject(forKey: "indexValueForTshirt")
            
            let albumVC = storyBoard.instantiateViewController(withIdentifier: "AlbumVC") as! AlbumVC
            if self.productType == "tshirtPrintind" {
                UserDefaults.standard.set("tshirt", forKey: "productType")
            }
            else  if self.productType == "cusionsPrinted" {
                UserDefaults.standard.set("cusions", forKey: "productType")
            }
            else  if self.productType == "toteBagPrinted" {
                UserDefaults.standard.set("toteBag", forKey: "productType")
            }
            self.navigationController?.pushViewController(albumVC, animated: true)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func sizeOfProductValidation()
    {
        let alert = UIAlertController(title: "Alert", message: "You currently have \(UserDefaults.standard.value(forKey: "SizeName") as! String) selected.Are you sure want to change to \(Header.appDelegate.SizeName) Prints?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
        //event handler with closure
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            
            
            
            //need to work for remove saved value in database
            let arr = DBManager.sharedManager.fetchImagesBySizeFromDB(UserDefaults.standard.value(forKey: "SizeName") as! String)//remove value from database by size when changed size
            print(arr)
            DBManager.sharedManager.deleteRecordsFromDB(arr)
            
            //UserDefaults.standard.removeObject(forKey: "SizeName")
            UserDefaults.standard.set(Header.appDelegate.SizeName, forKey: "SizeName")
            UserDefaults.standard.removeObject(forKey: "indexValueForTshirt")
            
            let albumVC = storyBoard.instantiateViewController(withIdentifier: "AlbumVC") as! AlbumVC
            if self.productType == "tshirtPrintind" {
                UserDefaults.standard.set("tshirt", forKey: "productType")
            }
            else  if self.productType == "cusionsPrinted" {
                UserDefaults.standard.set("cusions", forKey: "productType")
            }
            else  if self.productType == "toteBagPrinted" {
                UserDefaults.standard.set("toteBag", forKey: "productType")
            }
            self.navigationController?.pushViewController(albumVC, animated: true)
            
            
        }))
        
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
