//
//  PageControllerVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 9/30/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

let pageCell = "pageCell"

class PageControllerVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    
    //MARK: outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var lblSize: UILabel!
    @IBOutlet var pageControler: UIPageControl!
    
    @IBOutlet var infoView: UIView!
    
    @IBOutlet var lblPrice: UILabel!
    
    
    //MARK: variable
    var imageWidth = String()
    var imageHeight = String()
    
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Header.appDelegate.SizeName //give size as title
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
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
            collectionView.frame = CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width)-64)
            lblSize.frame = CGRect(x: 0, y: Int(self.view.frame.size.width), width: Int(self.view.frame.size.width), height: Int(lblSize.frame.size.height))
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: Int(self.view.frame.size.width)-40, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            lblPrice.frame = CGRect(x: 105, y: 513, width: 164, height: 21)

        }
        else  if DeviceType.IS_IPHONE_6P{
            collectionView.frame = CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width)-64)
            lblSize.frame = CGRect(x: 0, y: Int(self.view.frame.size.width), width: Int(self.view.frame.size.width), height: Int(lblSize.frame.size.height))
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: Int(self.view.frame.size.width)-40, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            lblPrice.frame = CGRect(x: 120, y: 567, width: 164, height: 21)
            
        }
        else  if DeviceType.IS_IPHONE_5{
            collectionView.frame = CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width)-64)
            lblSize.frame = CGRect(x: 0, y: Int(self.view.frame.size.width), width: Int(self.view.frame.size.width), height: Int(lblSize.frame.size.height))
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: Int(self.view.frame.size.width)-40, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            lblPrice.frame = CGRect(x: 78, y: 440, width: 164, height: 21)
            
        }
        else  if DeviceType.IS_IPHONE_4_OR_LESS{
            collectionView.frame = CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width)-64)
            lblSize.frame = CGRect(x: 0, y: Int(self.view.frame.size.width), width: Int(self.view.frame.size.width), height: Int(lblSize.frame.size.height))
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: Int(self.view.frame.size.width)-40, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            
        }
        
        Header.appDelegate.imageWidthForCrop = imageWidth //give width for croping
        Header.appDelegate.imageHeightForCrop = imageHeight //give height for croping
        print(imageWidth)
        print(imageHeight)
        
        UserDefaults.standard.set(imageHeight, forKey: "imageHeightForCrop")
        UserDefaults.standard.set(imageWidth, forKey: "imageWidthForCrop")
        
        lblSize.text = "\(imageWidth)X\(imageHeight) CM"
        
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PageControllerVC.returntoView))
        
        
        //add right navigation  button
        var imageInfo = UIImage(named: "question-mark")
        imageInfo = imageInfo?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageInfo, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PageControllerVC.showInfoView))
        
        

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func showInfoView() {
        
        infoView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
       self.view.addSubview(infoView)
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
        
        let imageName = "4x4-image"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: -80, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width))
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
        
        if(UserDefaults.standard.value(forKey: "ProductName") != nil){
            
            if(Header.appDelegate.ProductName != UserDefaults.standard.value(forKey: "ProductName") as! String  ){
                
                self.productNameValidation()
            }
            else if(Header.appDelegate.SizeName != UserDefaults.standard.value(forKey: "SizeName") as! String){
                self.sizeOfProductValidation()
            }
            else{
                let albumVC = storyBoard.instantiateViewController(withIdentifier: "AlbumVC") as! AlbumVC
                self.navigationController?.pushViewController(albumVC, animated: true)
                
                
            }
        }
        
        
       else if(UserDefaults.standard.value(forKey: "SizeName") != nil){
            
            if(Header.appDelegate.SizeName != UserDefaults.standard.value(forKey: "SizeName") as! String){
                
                self.sizeOfProductValidation()
            }
            else{
                let albumVC = storyBoard.instantiateViewController(withIdentifier: "AlbumVC") as! AlbumVC
                self.navigationController?.pushViewController(albumVC, animated: true)

                
            }
            
        }
            
        else{
            let albumVC = storyBoard.instantiateViewController(withIdentifier: "AlbumVC") as! AlbumVC
            self.navigationController?.pushViewController(albumVC, animated: true)

        }

        
    }
    
    @IBAction func closeAction(_ sender: AnyObject) {
        
        infoView.removeFromSuperview()
    }
    
   
 func productNameValidation()
 {
    let alert = UIAlertController(title: "Alert", message: "You currently have \(UserDefaults.standard.value(forKey: "ProductName") as! String) selected.Are you sure want to change to \(Header.appDelegate.SizeName) Prints?", preferredStyle: UIAlertControllerStyle.alert)
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
