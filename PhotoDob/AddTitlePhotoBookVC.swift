//
//  AddTitlePhotoBookVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 11/17/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import CoreData

class AddTitlePhotoBookVC: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate{
    
    //MARK:Outlets
    
    @IBOutlet var FrontImage: UIImageView!
    @IBOutlet var txtTitle: UITextField!
    
    
    @IBOutlet var tapGestuer: UITapGestureRecognizer!
    //MARK:Variabls
    

    var imagePath = String()
    
    var tapGesture: UITapGestureRecognizer!
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    
    var lastIndexForFrontImage = NSInteger()
    
    var productName = String()
    var sizeOfProduct = String()
    
    
    //Database Work
    
    var imageArray = NSMutableArray()
    var mainImageArray = NSMutableArray()
    var cropedImageArray = NSMutableArray()
    var cropedStatusArray = NSMutableArray()
    var selectIndexArray = NSMutableArray()
    var albumNameArray = NSMutableArray()
    
    var albumManageObject = [NSManagedObject]()
    
    var productImagesArr = NSMutableArray()
    var albumNameArr = NSMutableArray()
    
    var indexValue = NSInteger()
    
    var sizeRatioOfCell = Float()
    var primaryKeyCount = String()
    var mainCartArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         picker?.delegate = self
        
        // Do any additional setup after loading the view.
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PhotoBookVC.returntoView))
        
        
        //confirm navigation  button
        let button1 = UIBarButtonItem(image: UIImage(named: "imagename"), style: .plain, target: self, action: #selector(PhotoBookVC.confirmAction)) // action:#selector(Class.MethodName) for swift 3
        button1.title = "Confirm"
        self.navigationItem.rightBarButtonItem  = button1
        
        indexValue = 0
        /*let imageValue : UIImage = self.getImageByPathOLD(imagePath )
        FrontImage.image = imageValue*/
        
       
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGesture(_:)))
        FrontImage.addGestureRecognizer(longPressGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
          FrontImage.addGestureRecognizer(tapGesture)
        
        
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
        
        if (albumNameArray[0] as! String ) == "Fotolia" {
            FrontImage.hnk_setImage(from: URL(string:mainImageArray[0] as! String))
        }else{
            let imageValue : UIImage = self.getImageByPathOLD(mainImageArray[0] as! String )
            FrontImage.image = imageValue
        }
        print(mainImageArray)
        
        
        
        
        
        
        //check condition for selected index
        //self.checkForSelectedIndex()
        
    }
    
    
    @IBAction func shuffleAction(_ sender: AnyObject) {
        indexValue = indexValue+1
        if indexValue < mainImageArray.count{
            
        }
        else{
            indexValue = 0
        }
        
        if (albumNameArray[0] as! String )as! String == "Fotolia" {
            FrontImage.hnk_setImage(from: URL(string:mainImageArray[indexValue] as! String))
        }else{
            let imageValue : UIImage = self.getImageByPathOLD(mainImageArray[indexValue] as! String )
            FrontImage.image = imageValue
        }

        
        
        
    }
    
    
    @IBAction func addTitleAction(_ sender: AnyObject) {
        txtTitle.becomeFirstResponder()
    }
    
    
    
    
    func longPressGesture(_ sender: UITapGestureRecognizer){
        
      /*  let cropVC = storyBoard.instantiateViewController(withIdentifier: "CropVC") as! CropVC
        cropVC.imageforCrop = FrontImage.image!
        cropVC.indexValue = lastIndexForFrontImage
        //cropVC.albumName = albumNameArray[longIndexPath.row*2] as! String
        cropVC.vcName = "photoBookVC"
        self.navigationController?.pushViewController(cropVC, animated: true)*/
        
    }
    
    func tapGesture(_ sender: UITapGestureRecognizer) {
        
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            
        }

        
        
    }
    
    
    // MARK: - UIImagePickerView Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker .dismiss(animated: true, completion: nil)
        
            FrontImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
        
    }
    //imgFirst.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
        picker .dismiss(animated: true, completion: nil)
        
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    
    
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            
        }
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func confirmAction()
    {
        
        let alert = UIAlertController(title: "Alert", message: "Do yo want to add this product to Cart?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
        //event handler with closure
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            
            
            
            self.fetchProductValuesForSaving()
            self.getCountOfCartArray()
            self.addProductToCartTable()
            
            self.removeProductFromDatabase()
            self.pushToCartView()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
      
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

    
    
    
    
    
    
    //MARK: get local directory path
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    //fetch orignal images
    func getImageByPathOLD(_ imageName:String)->UIImage{
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
    

    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    
    
 
   

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
