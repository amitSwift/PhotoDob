//
//  SelectAPrintVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 11/21/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import CoreData

class SelectAPrintVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    //MARK: Outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var imageForPrint: UIImageView!
    
    @IBOutlet var imageProduct: UIImageView!
    
    @IBOutlet var txtTitle: UITextField!
    
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var btnAddTitle: UIButton!
    
    //MARK: Variables
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    
    var imageArray = NSMutableArray()
    var mainImageArray = NSMutableArray()
    var cropedImageArray = NSMutableArray()
    var cropedStatusArray = NSMutableArray()
    var selectIndexArray = NSMutableArray()
    var albumNameArray = NSMutableArray()
    
    var albumManageObject = [NSManagedObject]()
    
    var indexPathValue = NSInteger()
    
    
    //MARK: work for add on cart
    
    var productName = String()
    var sizeOfProduct = String()
    var productImagesArr = NSMutableArray()
    var albumNameArr = NSMutableArray()
    
    var sizeRatioOfCell = Float()
    var primaryKeyCount = String()
    var mainCartArray = NSMutableArray()
    
    
    var imageArr = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select A Print"

        // Do any additional setup after loading the view.
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(SelectAPrintVC.returntoView))
        
        
        //add right navigation  button
         var imageInfo = UIImage(named: "tick-active")
         imageInfo = imageInfo?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageInfo, style: UIBarButtonItemStyle.plain, target: self, action: #selector(SelectAPrintVC.clickOnTick))
        

      
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: screenWidth/5, height: screenWidth/5)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        collectionView!.collectionViewLayout = layout
        
        if UserDefaults.standard.value(forKey: "productType")as! String == "tshirt" {
            imageProduct.image = UIImage.init(named: "t-shirt")
            lblDetail.text = "Almost done! Click on any print to display on  T-Shirt.\nYour T-Shirt will print exactly like this in real life!"
        }
        else  if UserDefaults.standard.value(forKey: "productType")as! String == "cusions"{
            imageProduct.image = UIImage.init(named: "pillow")
            lblDetail.text = "Almost done! Click on any print to display on  Cusions.\nYour Cusions will print exactly like this in real life!"
        }
        else if UserDefaults.standard.value(forKey: "productType")as! String == "toteBag"{
            imageProduct.image = UIImage.init(named: "bag")
            txtTitle.isHidden = true
            btnAddTitle.isHidden = true
            lblDetail.text = "Almost done! Click on any print to display on Tote Bag.\nYour Tote Bag will print exactly like this in real life!"
        }
        
        
      let longPressRecognizerLeft = UITapGestureRecognizer(target: self, action: #selector(SelectAPrintVC.longPressedLeft))
       imageForPrint.addGestureRecognizer(longPressRecognizerLeft)
        
        
        if DeviceType.IS_IPHONE_6P{
            if UserDefaults.standard.value(forKey: "productType")as! String == "tshirt" {
                txtTitle.frame = CGRect(x: 119, y: imageProduct.frame.origin.y+145-54, width: 168, height: 28)
                imageForPrint.frame = CGRect(x:121, y: imageProduct.frame.origin.y+145-54, width: 169, height: 250)
            }
            else  if UserDefaults.standard.value(forKey: "productType")as! String == "cusions"{
                txtTitle.frame = CGRect(x: 118, y: imageProduct.frame.origin.y+129-20, width: 180, height: 28)
                imageForPrint.frame = CGRect(x:118, y: imageProduct.frame.origin.y+151-20, width: 180, height: 180)
            }
            else if UserDefaults.standard.value(forKey: "productType")as! String == "toteBag"{
                imageForPrint.frame = CGRect(x:94, y: imageProduct.frame.origin.y+199-20, width: 228, height: 179)
            }
            
            
        }
        else  if DeviceType.IS_IPHONE_6{
            if UserDefaults.standard.value(forKey: "productType")as! String == "tshirt" {
                txtTitle.frame = CGRect(x: 107, y: imageProduct.frame.origin.y+155-54, width: 152, height: 28)
                imageForPrint.frame = CGRect(x:109, y: imageProduct.frame.origin.y+155-54, width:152, height: 200)
            }
            else  if UserDefaults.standard.value(forKey: "productType")as! String == "cusions"{
                txtTitle.frame = CGRect(x: 104, y: imageProduct.frame.origin.y+108-20, width: 176, height: 28)
                imageForPrint.frame = CGRect(x:114, y: imageProduct.frame.origin.y+135-20, width: 155, height: 155)
            }
            else if UserDefaults.standard.value(forKey: "productType")as! String == "toteBag"{
                imageForPrint.frame = CGRect(x:92, y: imageProduct.frame.origin.y+172-20, width: 192, height: 156)
            }
            
            
        }
        else  if DeviceType.IS_IPHONE_5{
            if UserDefaults.standard.value(forKey: "productType")as! String == "tshirt" {
                txtTitle.frame = CGRect(x: 96, y: imageProduct.frame.origin.y+91-34, width: 120, height: 28)
                imageForPrint.frame = CGRect(x:96, y: imageProduct.frame.origin.y+91-34, width: 120
                    , height: 160)
            }
            else  if UserDefaults.standard.value(forKey: "productType")as! String == "cusions"{
                txtTitle.frame = CGRect(x: 80, y: imageProduct.frame.origin.y+78-20, width: 163, height: 28)
                imageForPrint.frame = CGRect(x:102, y: imageProduct.frame.origin.y+99-20, width: 117, height: 117)
            }
            else if UserDefaults.standard.value(forKey: "productType")as! String == "toteBag"{
                imageForPrint.frame = CGRect(x:103, y: imageProduct.frame.origin.y+131-20, width: 117, height: 117)
            }
            
            
        }
        else  if DeviceType.IS_IPHONE_4_OR_LESS{
            if UserDefaults.standard.value(forKey: "productType")as! String == "tshirt" {
            }
            else  if UserDefaults.standard.value(forKey: "productType")as! String == "cusions"{
            }
            else if UserDefaults.standard.value(forKey: "productType")as! String == "toteBag"{
            }
        }
        
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        //check for saved value in album table
        DBManager.sharedManager.getSavedArrayFromDataBase( comletionHandler: {(result: [NSManagedObject]) -> Void in
            print("result is \(result)")
            
            self.title = "\(result.count) image selected"
            
            self.albumManageObject = result
            
            print(self.albumManageObject)
            print(self.albumManageObject.count)
            
            }, andFalure: {(fail: Int) -> Void in
                print("fail is \(fail)")
                self.title = "0 image selected"
        })
        
        mainImageArray = NSMutableArray()
        cropedImageArray = NSMutableArray()
        cropedStatusArray = NSMutableArray()
        selectIndexArray = NSMutableArray()
        albumNameArray = NSMutableArray()
        
        for i in 0 ..< albumManageObject.count{
            let albumObject = albumManageObject[i]
            mainImageArray.add(albumObject.value(forKey: "selectImageName") as! String)
            cropedImageArray.add(albumObject.value(forKey: "cropedImageName") as! String)
            cropedStatusArray.add(albumObject.value(forKey: "isCroped") as! String)
            selectIndexArray.add(albumObject.value(forKey: "selectedImageIndexValue") as! String)
            albumNameArray.add(albumObject.value(forKey: "albumName") as! String)
            
            
        }
        
        print(mainImageArray)
        
        collectionView.reloadData()
        
        //used for selected index value
        if UserDefaults.standard.value(forKey: "indexValueForTshirt") != nil{
            indexPathValue = UserDefaults.standard.value(forKey: "indexValueForTshirt") as! NSInteger
        }else{
            indexPathValue = 0
        }
        
        
        
        //check condition for selected index
        //self.checkForSelectedIndex()
        
    }
    
    func longPressedLeft(sender: UILongPressGestureRecognizer)
    {
        
//        let location = sender.location(in: collectionView)
//        var longIndexPath = tblPhotoBook.indexPathForRow(at: location)!
        
        
        
        let url = NSURL(string: mainImageArray[indexPathValue] as! String)
        //let imageData = NSData(contentsOf: url! as URL)
        // let imageValue : UIImage = UIImage(data: imageData as! Data)!
        
        let imageValue : UIImage = AppManager.sharedManager.getImageByPathOLD(mainImageArray[indexPathValue] as! String)!
        
        let cropVC = storyBoard.instantiateViewController(withIdentifier: "CropVC") as! CropVC
        cropVC.imageforCrop = imageValue
        cropVC.indexValue = Int(selectIndexArray[indexPathValue] as! String)!
        cropVC.albumName = albumNameArray[indexPathValue] as! String
        cropVC.vcName = "tShirtPrintVC"
        //        let navController = UINavigationController(rootViewController: cropVC)
        //        self.present(navController, animated: true, completion: nil)
        //self.present(cropVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(cropVC, animated: true)
    }


    
    @IBAction func addTitleAction(_ sender: AnyObject) {
        txtTitle.becomeFirstResponder()
    }
    
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    //for use save value in database
    func clickOnTick()
    {
        if (self.title != "0"){
            let alert = UIAlertController(title: "Alert", message: "Do yo want to add this product to Cart?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
            //event handler with closure
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                
                self.fetchProductValuesForSaving()
                self.getCountOfCartArray()
                self.addProductToCartTable()
                
                self.removeProductFromDatabase()
                self.pushToCartView()
                
                UserDefaults.standard.removeObject(forKey: "indexValueForTshirt")
            }))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please select atleats one picture!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
            //event handler with closure
            
            self.present(alert, animated: true, completion: nil)
        }

        
    }
    
    
    //MARK: fetch product gor saving
    func fetchProductValuesForSaving() {
        
        self.productName = Header.appDelegate.ProductName
        self.sizeOfProduct = Header.appDelegate.SizeName
        
        self.productImagesArr = NSMutableArray()
        self.albumNameArr = NSMutableArray()
        
        for i in 0 ..< mainImageArray.count{
            if (cropedStatusArray[i] as! String) == "1"
            {
                self.productImagesArr.add(cropedImageArray[i] as! String)
            }
            else{
                self.productImagesArr.add(mainImageArray[i] as! String)
            }
            self.albumNameArr.add(albumNameArray[i] as! String)
        }
        
       /* var imageName = String()
        if cropedStatusArray.count != indexPathValue{
             imageName = self.productImagesArr[indexPathValue] as! String
        }else{
             imageName = self.productImagesArr[0] as! String
        }
       
        self.productImagesArr = NSMutableArray()
        self.productImagesArr.add(imageName )
        print(self.productImagesArr)*/
        
    }
    //MARK: add product to cart table
    func addProductToCartTable() {
        
        DBManager.sharedManager.saveProductValueToCart(self.productName, self.sizeOfProduct, self.productImagesArr, self.albumNameArr, "1","1",primaryKeyCount,"12", andCompletionHandler:{(result: Bool) -> Void in
            print("result is \(result)")
            }, andFalure: {(fail: NSError) -> Void in
                print("fail is \(fail)")
        })
        
        
        
        
    }
    
    func getCountOfCartArray(){
        
        DBManager.sharedManager.getSavedArrayOfCartFromDataBase( comletionHandler: {(result: [NSManagedObject]) -> Void in
            
            print("result is \(result)")
            
            self.albumManageObject = result
            print(self.albumManageObject)
            
            self.mainCartArray = NSMutableArray()
            for i in 0 ..< self.albumManageObject.count{
                let albumObject = self.albumManageObject[i]
                
                self.mainCartArray.add(albumObject)
                //self.mainCartArray.add((albumObject.value(forKey: "albumName") as! NSMutableArray).object(at: 0)as! String)
                
            }
            
            if self.mainCartArray.count == 0 {
                self.primaryKeyCount = "1"
            }
            else{
                self.primaryKeyCount = ((self.mainCartArray[self.mainCartArray.count-1] as AnyObject).value(forKey: "primaryKey") as! String)
                self.primaryKeyCount = "\(Int(self.primaryKeyCount)! + 1)"
            }
            
            print(self.primaryKeyCount)
            
            
            
            }, andFalure: {(fail: Int) -> Void in
                print("fail is \(fail)")
        })
        
    }
    
    
    //MARK: remove added product from Album table
    func removeProductFromDatabase() {
        
        let arr = DBManager.sharedManager.fetchImagesByProductNameFromDB(UserDefaults.standard.value(forKey: "ProductName") as! String)//remove value from database by size when changed size
        print(arr)
        DBManager.sharedManager.deleteRecordsFromDB(arr)
        
        UserDefaults.standard.removeObject(forKey: "ProductName")
        UserDefaults.standard.removeObject(forKey: "SizeName")
        
    }
    //MARK: push to cart view controller
    func pushToCartView() {
        let cart2VC = storyBoard.instantiateViewController(withIdentifier: "Cart2VC") as! Cart2VC
        self.navigationController?.pushViewController(cart2VC, animated: true)
    }

    
    
    
    
    //MARK: collection view datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainImageArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //UIView.setAnimationsEnabled(false)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectPrintCell", for: indexPath) as! SelectPrintCell
        //cell.accessibilityIdentifier = "photo_cell_\(indexPath.item)"
        
        
        //cell.backgroundColor = UIColor.red
       // cell.frame.size.width = screenWidth / 3
       // cell.frame.size.height = screenWidth / 3
        
        if cropedStatusArray.count != indexPathValue{
            
            if (cropedStatusArray[indexPathValue] as! String) == "1"
            {
                var image = UIImage()
                
                DispatchQueue.global(qos: .background).async {
                    self.imageForPrint.image = UIImage.init(named: "")
                    image = AppManager.sharedManager.getCropedImage(Int(self.selectIndexArray[self.indexPathValue] as! String)!,self.albumNameArray[indexPath.row] as! String)
                    DispatchQueue.main.async {
                        self.imageForPrint.image = image
                    }
                }
                
            }
            else{
                var image = UIImage()
                
                //cell.backImage.image  = self.getImageByPathOLD(self.mainImageArray[indexPath.row] as! String)!
                DispatchQueue.global(qos: .background).async {
                    self.imageForPrint.image = UIImage.init(named: "")
                    
                    if (AppManager.sharedManager.getImageByPathOLD(self.mainImageArray[self.indexPathValue] as! String) != nil){
                        image  = AppManager.sharedManager.getImageByPathOLD(self.mainImageArray[self.indexPathValue] as! String)!
                        //cell.backImage.image = mainImageArr[indexPath.row] as? UIImage
                    }
                    
                    DispatchQueue.main.async {
                        self.imageForPrint.image = image
                    }
                }
                
            }
            
        }else{
            var image = UIImage()
            
            //cell.backImage.image  = self.getImageByPathOLD(self.mainImageArray[indexPath.row] as! String)!
            DispatchQueue.global(qos: .background).async {
                self.imageForPrint.image = UIImage.init(named: "")
                
                if (AppManager.sharedManager.getImageByPathOLD(self.mainImageArray[0] as! String) != nil){
                    image  = AppManager.sharedManager.getImageByPathOLD(self.mainImageArray[0] as! String)!
                    //cell.backImage.image = mainImageArr[indexPath.row] as? UIImage
                }
                
                DispatchQueue.main.async {
                    self.imageForPrint.image = image
                }
            }
        }
        
       

        
        
        
        if (cropedStatusArray[indexPath.row] as! String) == "1"
        {
            var image = UIImage()
            
            DispatchQueue.global(qos: .background).async {
                cell.imageView.image = UIImage.init(named: "")
                image = AppManager.sharedManager.getCropedImage(Int(self.selectIndexArray[indexPath.row] as! String)!,self.albumNameArray[indexPath.row] as! String)
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }

        }
        else{
            
            
            var image = UIImage()
            
            DispatchQueue.global(qos: .background).async {
                cell.imageView.image = UIImage.init(named: "")
                
                if (AppManager.sharedManager.getImageByPathOLD(self.mainImageArray[indexPath.row] as! String) != nil){
                    image = AppManager.sharedManager.resize(AppManager.sharedManager.getImageByPathOLD(self.mainImageArray[indexPath.row] as! String)!, theNewSize: CGSize(width: 100, height: 100))
                    //cell.backImage.image = mainImageArr[indexPath.row] as? UIImage
                }
                
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }
            
            
        }
        

        
        
        UIView.setAnimationsEnabled(true)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath)as! SelectPrintCell
        UserDefaults.standard.set(indexPath.row, forKey: "indexValue")
        
        if (cropedStatusArray[indexPath.row] as! String) == "1"{
            imageForPrint.image = self.getImage(Int(selectIndexArray[indexPath.row] as! String)!,albumNameArray[indexPath.row] as! String)
        }else{
            imageForPrint.image = self.getImageByPathOLD(mainImageArray[indexPath.row] as! String)

        }
        indexPathValue = indexPath.row
        UserDefaults.standard.set(indexPathValue, forKey: "indexValueForTshirt")
        
    }
    
    
    //MARK: get local directory path
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImage(_ indexValue:NSInteger,_ albumName:String)->UIImage{
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("\(albumName)\(indexValue).png")
        
        if fileManager.fileExists(atPath: imagePAth){
            print(imagePAth)
            //self.imageView.image = UIImage(contentsOfFile: imagePAth)
            
            
            return UIImage(contentsOfFile: imagePAth)!
        }else{
            print("No Image")
        }
        return UIImage(contentsOfFile: imagePAth)!
    }
    
    
    
    //fetch orignal images
    func getImageByPathOLD(_ imageName:String)->UIImage
    {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("\(imageName).png")
        
        if fileManager.fileExists(atPath: imagePAth){
            print(imagePAth)
            //self.imageView.image = UIImage(contentsOfFile: imagePAth)
            
            
            return UIImage(contentsOfFile: imagePAth)!
        }else{
            print("No Image")
        }
        return UIImage(contentsOfFile: imagePAth)!
        
    }
    

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
