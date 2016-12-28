//
//  PrintingPageController.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/7/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class PrintingPageController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{

    //MARK: outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var lblSize: UILabel!
    @IBOutlet var pageControler: UIPageControl!
    
    
    @IBOutlet var btn20x30: UIButton!
    @IBOutlet var btn40x60: UIButton!
    @IBOutlet var btn70x80: UIButton!
    @IBOutlet var btn70x90: UIButton!
    
    
    @IBOutlet var infoView: UIView!
    @IBOutlet var customSizeView: UIView!
    
    
    @IBOutlet var btnCustomSize: UIButton!
    @IBOutlet var btnSelectSize: UIButton!
    
    @IBOutlet var infoBackGroundImage: UIImageView!
    @IBOutlet var cusumSizeBackGroundImage: UIImageView!
    
    @IBOutlet var txtWidthCustomView: UITextField!
    @IBOutlet var txtHeightCustomView: UITextField!
    
    
    //MARK: Variables
    
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
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PrintingPageController.longPressedLeft))
        lblSize.addGestureRecognizer(tapRecognizer)
        lblSize.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view, typically from a nib
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: screenWidth , height: screenWidth / 2)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.register(PagecontrollerCell.self, forCellWithReuseIdentifier: pageCell)
        collectionView!.collectionViewLayout = layout
        
        
        if DeviceType.IS_IPHONE_6{
            collectionView.frame = CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width))
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: Int(self.view.frame.size.width)+30, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            
        }
        else  if DeviceType.IS_IPHONE_6P{
            collectionView.frame = CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width))
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: Int(self.view.frame.size.width)+30, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            
        }
        else  if DeviceType.IS_IPHONE_5{
            collectionView.frame = CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: 280)
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: 280+20, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            
        }
        else  if DeviceType.IS_IPHONE_4_OR_LESS{
            collectionView.frame = CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width))
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: Int(self.view.frame.size.width)+30, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            
        }
        
        
        collectionView.isPagingEnabled = true
        self.view.addSubview(collectionView!)
        
        
        
        //uork on page controller
        pageControler.numberOfPages = 4
        pageControler.currentPage = 0
        //pageControler.center = self.view.center
        
        
        self.view.bringSubview(toFront: pageControler)
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PrintingPageController.returntoView))
        
        
        //add right navigation  button
       /* var imageInfo = UIImage(named: "question-mark")
        imageInfo = imageInfo?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageInfo, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PrintingPageController.showInfoView))*/
        
        
        
     
        //self.showInfoView()
        self.rollerBlinderValidation()
        
        
        
        
        
        
        
        let tapgestureInfo = UITapGestureRecognizer(target: self, action: #selector(PrintingPageController.tapGestureInfoView))
        infoBackGroundImage.addGestureRecognizer(tapgestureInfo)
        
        let tapgestureCustom = UITapGestureRecognizer(target: self, action: #selector(PrintingPageController.tapGestureCustomView))
        cusumSizeBackGroundImage.addGestureRecognizer(tapgestureCustom)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func tapGestureInfoView()
    {
        infoView.removeFromSuperview()
    }
    
    func tapGestureCustomView() {
        customSizeView.removeFromSuperview()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func showInfoView() {
        
        let alert = UIAlertController(title: "Alert", message: "Under process!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

        
       /* infoView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(infoView)*/
    }
    func longPressedLeft(sender: UILongPressGestureRecognizer)
    {
        infoView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(infoView)
    }
    
    func rollerBlinderValidation(){
        
        if UserDefaults.standard.bool(forKey: "isCustomSize") == false
        {
            
            if UserDefaults.standard.value(forKey: "selectedSizeRoller") != nil{
                
                if UserDefaults.standard.value(forKey: "selectedSizeRoller")as! String == "0"{
                    imageWidth = "20"
                    imageHeight = "30"
                    
                    btn20x30.isSelected = true
                    
                }else if UserDefaults.standard.value(forKey: "selectedSizeRoller")as! String == "1"{
                    
                    imageWidth = "40"
                    imageHeight = "60"
                    btn40x60.isSelected = true
                }
                else if UserDefaults.standard.value(forKey: "selectedSizeRoller")as! String == "2"{
                    
                    imageWidth = "70"
                    imageHeight = "80"
                    btn70x80.isSelected = true
                }
                else if UserDefaults.standard.value(forKey: "selectedSizeRoller")as! String == "3"{
                    
                    imageWidth = "70"
                    imageHeight = "90"
                    btn70x90.isSelected = true
                }
                
            }
            else{
                UserDefaults.standard.set("1", forKey: "selectedSizeRoller")
                imageWidth = "40"
                imageHeight = "60"
                btn40x60.isSelected = true
                
            }
            
            Header.appDelegate.imageWidthForCrop = imageWidth //give width for croping
            Header.appDelegate.imageHeightForCrop = imageHeight //give height for croping
            
            UserDefaults.standard.set(imageHeight, forKey: "imageHeightForCrop")
            UserDefaults.standard.set(imageWidth, forKey: "imageWidthForCrop")
            
            UserDefaults.standard.set(false, forKey: "isPrintCustomSize")
            
            lblSize.text = "\(imageWidth)x\(imageHeight)"
            Header.appDelegate.SizeName = lblSize.text!
            
            
        }
        else{
            infoView.removeFromSuperview()
            
            imageWidth = UserDefaults.standard.value(forKey: "imageWidthForCrop") as! String
            imageHeight = UserDefaults.standard.value(forKey: "imageHeightForCrop") as! String
            
            Header.appDelegate.imageWidthForCrop = imageWidth //give width for croping
            Header.appDelegate.imageHeightForCrop = imageHeight //give height for croping
            
            
            lblSize.text = "\(imageWidth)x\(imageHeight)"
            Header.appDelegate.SizeName = lblSize.text!
        }
        

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
                 UserDefaults.standard.set("0", forKey: "selectedSizeRoller")
            }
            
            imageWidth = "20"
            imageHeight = "30"
            lblSize.text = "20x30"
            
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
                UserDefaults.standard.set("1", forKey: "selectedSizeRoller")
            }
            imageWidth = "40"
            imageHeight = "60"
            lblSize.text = "40x60"
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
                UserDefaults.standard.set("2", forKey: "selectedSizeRoller")
            }
            imageWidth = "70"
            imageHeight = "80"
            lblSize.text = "70x80"
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
                 UserDefaults.standard.set("3", forKey: "selectedSizeRoller")
            }
            imageWidth = "70"
            imageHeight = "90"
            lblSize.text = "70x90"
        }
        
        Header.appDelegate.SizeName = lblSize.text! // give size name
        
        
        Header.appDelegate.imageWidthForCrop = imageWidth //give width for croping
        Header.appDelegate.imageHeightForCrop = imageHeight //give height for croping
        UserDefaults.standard.set(imageHeight, forKey: "imageHeightForCrop")
        UserDefaults.standard.set(imageWidth, forKey: "imageWidthForCrop")
        
        infoView.removeFromSuperview()
        UserDefaults.standard.set(false, forKey: "isCustomSize")

    }
    
    
    
    
    

    @IBAction func custonSizeAction(_ sender: AnyObject) {
        
        customSizeView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(customSizeView)
    }
    
    
    @IBAction func selectSizeAction(_ sender: AnyObject) {
    }
    
    @IBAction func makeRollerAction(_ sender: AnyObject) {
        
        
        
        if(UserDefaults.standard.value(forKey: "ProductName") != nil){
            
            if(Header.appDelegate.ProductName != UserDefaults.standard.value(forKey: "ProductName") as! String  ){
                
                self.productNameValidation()
            }
            else if(Header.appDelegate.SizeName != UserDefaults.standard.value(forKey: "SizeName") as! String){
                self.sizeOfProductValidation()
            }
            else{
                let printingAlbumVC = storyBoard.instantiateViewController(withIdentifier: "PrintingAlbumVC") as! PrintingAlbumVC
                self.navigationController?.pushViewController(printingAlbumVC, animated: true)
                
            }
        }
            
            
        else if(UserDefaults.standard.value(forKey: "SizeName") != nil){
            
            if(Header.appDelegate.SizeName != UserDefaults.standard.value(forKey: "SizeName") as! String){
                
                self.sizeOfProductValidation()
            }
            else{
                let printingAlbumVC = storyBoard.instantiateViewController(withIdentifier: "PrintingAlbumVC") as! PrintingAlbumVC
                self.navigationController?.pushViewController(printingAlbumVC, animated: true)
                
                
            }
            
        }
            
        else{
            let printingAlbumVC = storyBoard.instantiateViewController(withIdentifier: "PrintingAlbumVC") as! PrintingAlbumVC
            self.navigationController?.pushViewController(printingAlbumVC, animated: true)
            
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
            
            
            let printingAlbumVC = storyBoard.instantiateViewController(withIdentifier: "PrintingAlbumVC") as! PrintingAlbumVC
            self.navigationController?.pushViewController(printingAlbumVC, animated: true)
            
            
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
            
            let printingAlbumVC = storyBoard.instantiateViewController(withIdentifier: "PrintingAlbumVC") as! PrintingAlbumVC
            self.navigationController?.pushViewController(printingAlbumVC, animated: true)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let pCell = collectionView.dequeueReusableCell(withReuseIdentifier: pageCell, for: indexPath) as! PagecontrollerCell
        
        let imageName = "aluminium-roler-image"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
         if DeviceType.IS_IPHONE_5{
            imageView.frame = CGRect(x: 0, y: -64, width: Int(self.view.frame.size.width), height: 280)
         }else{
            imageView.frame = CGRect(x: 0, y: -100, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width))
        }
        
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
    
    @IBAction func selectAction(_ sender: AnyObject) {
        
        let albumVC = storyBoard.instantiateViewController(withIdentifier: "AlbumVC") as! AlbumVC
        self.navigationController?.pushViewController(albumVC, animated: true)
        
    }
    
    @IBAction func closeAction(_ sender: AnyObject) {
        
        infoView.removeFromSuperview()
        customSizeView.removeFromSuperview()
    }
    
    @IBAction func customSizeAction(_ sender: AnyObject) {
        
        infoView.removeFromSuperview()
        customSizeView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(customSizeView)
        
        
    }
    @IBAction func doneAction(_ sender: AnyObject) {
        
        if txtWidthCustomView.text == ""{
            let alert = UIAlertController(title: "Alert", message: "Please fill Width.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
           
            self.present(alert, animated: true, completion: nil)
            
        }else if txtHeightCustomView.text == ""{
            let alert = UIAlertController(title: "Alert", message: "Please fill Height.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
            
            self.present(alert, animated: true, completion: nil)
        }else{
            
            UserDefaults.standard.set(true, forKey: "isCustomSize")
            
            infoView.removeFromSuperview()
            customSizeView.removeFromSuperview()
            
            btn20x30.isSelected = false
            btn40x60.isSelected = false
            btn70x80.isSelected = false
            btn70x90.isSelected = false
            
            imageWidth = txtWidthCustomView.text!
            imageHeight = txtHeightCustomView.text!
            
            Header.appDelegate.imageWidthForCrop = imageWidth //give width for croping
            Header.appDelegate.imageHeightForCrop = imageHeight //give height for croping
            UserDefaults.standard.set(imageHeight, forKey: "imageHeightForCrop")
            UserDefaults.standard.set(imageWidth, forKey: "imageWidthForCrop")
            
            lblSize.text = "\(txtWidthCustomView.text!)x\(txtHeightCustomView.text!)"
            Header.appDelegate.SizeName = lblSize.text!
        }
        
       
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
