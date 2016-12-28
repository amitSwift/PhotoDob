//
//  PhotoCollectionVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/10/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import Photos
import CoreData



enum ViewToCrop {
    case photoPrint
    case photoBook
    case collagedPhotoFrame
    case tShirtPrint
    case customPrintedWallpaper
    case rollerBrindesPrinted
    case cushionsPrinted
    case toteBagsPrinted
}

class PhotoCollectionVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet var collectionView: UICollectionView!
    
   /*  var imageList = NSMutableArray()
     let photoCellIdentifier = "PhotoCell"*/
    
    var selections = [PHAsset]()
    var fetchResult = PHFetchResult<PHAsset>()
    var imageSize: CGSize = CGSize.zero
    
    var selectedImgArr:NSMutableArray = NSMutableArray()
    var people = [NSManagedObject]()
    
     var selectedIndexArr:NSMutableArray = NSMutableArray()
    var albumName = String()
    
    var season = ViewToCrop.photoPrint //used for crop view
    var imageCount = NSInteger()
    
    /*-----------------------------------------------*/
    //check mark work
    var imageMetaDataArray = NSMutableArray()
    
    /*-----------------------------------------------*/
    
    fileprivate let photoCellIdentifier = "PhotoCell"
    fileprivate let photosManager = PHCachingImageManager.default()
    fileprivate let imageContentMode: PHImageContentMode = .aspectFill
   // var imageSize = CGSize(width: 300, height: 300) //give size of image
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var rightBarButton = UIButton()
    
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
        
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PhotoCollectionVC.returntoView))
        
        
        
        //add right navigation  button
       /* var imageInfo = UIImage(named: "tick-active")
        imageInfo = imageInfo?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageInfo, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PhotoCollectionVC.clickOnTick))*/
        
        
        rightBarButton = UIButton.init(type: .custom)
        rightBarButton.setImage(UIImage.init(named: "tick-active"), for: UIControlState.normal)
        rightBarButton.setImage(UIImage.init(named: "tick"), for: UIControlState.selected)
        rightBarButton.addTarget(self, action:#selector(PhotoCollectionVC.clickOnTick), for: UIControlEvents.touchUpInside)
        rightBarButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: rightBarButton)
        self.navigationItem.rightBarButtonItem = barButton
        
        
        /*-----------------------------------------------*///save image meta data
        
        
       
       /* AppManager.sharedManager.activateView(self.view, loaderText: "Loading..")
        
            for index in 0 ..< self.fetchResult.count{
                let asset = self.fetchResult.object(at: index)
                asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (input, _) in
                    let imageUrl = input?.fullSizeImageURL
                    let imageUrlStr = "\(imageUrl!)"
                    self.imageMetaDataArray.add(imageUrlStr)//save date of image
                    print(self.imageMetaDataArray)
                    
                    if index == self.fetchResult.count-1{
                        AppManager.sharedManager.inActivateView(self.view)
                    }
                    
                }
            }
            */
        
        
        
        
        
        
        /*-----------------------------------------------*/
        
        
        //for use save value in database
        
        //check condition for selected index
        self.checkForSelectedIndex()
        
        self.setTitle()
        
        
        
    }
    
    
    
    
    
    
    func setTitle(){
        DBManager.sharedManager.getSavedArrayFromDataBase( comletionHandler: {(result: [NSManagedObject]) -> Void in
            print("result is \(result)")
            self.imageCount = result.count
            if Header.appDelegate.ProductName == "PHOTOBOOKS"{
                self.title = "\(result.count)/20 "
            }else{
                self.title = "\(result.count) "
            }
            if self.imageCount > 0{
                self.rightBarButton.isSelected = false
            }else{
                self.rightBarButton.isSelected = true
                UserDefaults.standard.removeObject(forKey: "indexValueForTshirt")
            }
                
            
            print(self.imageCount)
            
            }, andFalure: {(fail: Int) -> Void in
                print("fail is \(fail)")
                self.title = "0 "
                self.imageCount = 0
                self.rightBarButton.isSelected = true
                
        })

        
    }
    
    
        func returntoView() {
              UIView.setAnimationsEnabled(true)
            _ = navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:Check for selected index
    func checkForSelectedIndex()
    {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumTable")
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            people = results as! [NSManagedObject]
            
            print(people)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        selectedIndexArr = NSMutableArray()
        
        for i in 0 ..< people.count{
            let person = people[i]
            print(person.value(forKey: "selectedImageIndexValue") as! String)
            print(person.value(forKey: "albumName")as! String)
            if (person.value(forKey: "albumName")as! String) == albumName{
                selectedIndexArr.add(person.value(forKey: "selectedImageIndexValue") as! String)
            }
            
            /*-----------------------------------------------*/

            
            
            
        }

    }
    
    
   
    func clickOnTick() {
        
        UIView.setAnimationsEnabled(true)
        
        if(self.imageCount>0){
            
            
            self.returnProductType(productname: Header.appDelegate.ProductName) //change enum type according to product type
            
            switch season {
            case .photoPrint:
                let cropVC = storyBoard.instantiateViewController(withIdentifier: "TapToCrop") as! TapToCrop
                self.navigationController?.pushViewController(cropVC, animated: true)
                
            case .photoBook:
                
                if self.imageCount == 20{
                    let photoBookVC = storyBoard.instantiateViewController(withIdentifier: "PhotoBookVC") as! PhotoBookVC
                    self.navigationController?.pushViewController(photoBookVC, animated: true)
                }else{
                    let alert = UIAlertController(title: "Alert", message: "Please select total 20 images!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            case .collagedPhotoFrame:
                let colladgePhotoFrameVC = storyBoard.instantiateViewController(withIdentifier: "ColladgePhotoFrameVC") as! ColladgePhotoFrameVC
                self.navigationController?.pushViewController(colladgePhotoFrameVC, animated: true)
                
            case .tShirtPrint:
                print("tShirtPrint")
                let selectAPrintVC = storyBoard.instantiateViewController(withIdentifier: "SelectAPrintVC") as! SelectAPrintVC
                self.navigationController?.pushViewController(selectAPrintVC, animated: true)
            case .customPrintedWallpaper:
                print("customPrintedWallpaper")
                
            case .rollerBrindesPrinted:
                print("rollerBrindesPrinted")
            case .cushionsPrinted:
                print("cushionsPrinted")
                let selectAPrintVC = storyBoard.instantiateViewController(withIdentifier: "SelectAPrintVC") as! SelectAPrintVC
                self.navigationController?.pushViewController(selectAPrintVC, animated: true)
            case .toteBagsPrinted:
                print("toteBagsPrinted")
                let selectAPrintVC = storyBoard.instantiateViewController(withIdentifier: "SelectAPrintVC") as! SelectAPrintVC
                self.navigationController?.pushViewController(selectAPrintVC, animated: true)
            }
            
            
            
            
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please select images!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        
        
        
        
        // used for saving
        
        //             let imageArray = UserDefaults.standard.value(forKey: "selectedImages") as! NSMutableArray
        //            AppManager.sharedManager.saveProductValueInDataBase("PHOTO PRINT", "%X%", imageArray, "0",andCompletionHandler: {(result: Bool) -> Void in
        //                print("result is \(result)")
        //                }, andFalure: {(fail: NSError) -> Void in
        //                    print("fail is \(fail)")
        //            })
        
        
        
    }
    
    
    func returnProductType(productname:String) -> Void {
        if(productname == "PHOTO PRINTS"){
            season = ViewToCrop.photoPrint
        }
        else if(productname == "PHOTOBOOKS"){
            season = ViewToCrop.photoBook
        }
        else if(productname == "COLLAGED PHOTO FRAMES"){
            season = ViewToCrop.collagedPhotoFrame
        }
        else if(productname == "T-SHIRT PRINTING"){
            season = ViewToCrop.tShirtPrint
        }
        else if(productname == "CUSTOM PHOTO FRAME"){
            season = ViewToCrop.customPrintedWallpaper
        }
        else if(productname == "ROLLER BLINDES PRINTED"){
            season = ViewToCrop.rollerBrindesPrinted
        }
        else if(productname == "CUSHIONS PRINTED"){
            season = ViewToCrop.cushionsPrinted
        }
        else if(productname == "TOTE BAGS PRINTED"){
            season = ViewToCrop.toteBagsPrinted
        }
    }

    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
        //return imageList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        UIView.setAnimationsEnabled(false)
        let cell : PhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.accessibilityIdentifier = "photo_cell_\(indexPath.item)"
       
        
        
        //cell.backgroundColor = UIColor.red
        cell.frame.size.width = screenWidth / 3
        cell.frame.size.height = screenWidth / 3
        cell.btnCheck.tag = indexPath.row
        
        
 
        
        cell.activitiView.startAnimating()
        
        if cell.tag != 0 {
            self.photosManager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        let asset : PHAsset = self.fetchResult[indexPath.row] 
        cell.asset = asset
        
     
    /*  self.photosManager.requestImage(for: asset as PHAsset, targetSize: CGSize(width: 100, height: 100), contentMode: self.imageContentMode, options: nil) { (result, _) in
                cell.imageView.image = result
        
                cell.activitiView.stopAnimating()
            }
        
        if self.selectedIndexArr.contains(String(indexPath.row)){
            cell.btnCheck.isSelected = true
        }else{
            cell.btnCheck.isSelected = false
            
        }*/

        

        DispatchQueue.global(qos: .utility).async {
            
            
            // Request image
            cell.tag = Int(self.photosManager.requestImage(for: asset as PHAsset, targetSize:CGSize(width: 100, height: 100)/* CGSize(width: asset.pixelWidth, height: asset.pixelHeight)*/, contentMode: self.imageContentMode, options: nil) { (result, _) in
                cell.imageView.image = result
                //cell.imageView.image = self.resize(result!, theNewSize: CGSize(width: 100, height: 100))
               
            })
            
           
            
            
            DispatchQueue.main.async {
                
              cell.activitiView.stopAnimating()
                
                if self.selectedIndexArr.contains(String(indexPath.row)){
                    cell.btnCheck.isSelected = true
                }else{
                    cell.btnCheck.isSelected = false
                    
                }
            }
        }
        
        
       
        
       

        
       // UIView.setAnimationsEnabled(true)
        
        return cell
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {

        
        
        
        let cell = collectionView.cellForItem(at: indexPath)as! PhotoCell
        
        let asset = self.fetchResult.object(at: indexPath.row)
        
        
        asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (input, _) in
            let imageUrl = input?.fullSizeImageURL
            let imageData = NSData(contentsOf: imageUrl!)
            let image1 : UIImage = UIImage(data: imageData as! Data)!
            let imageUrlStr = "\(imageUrl!)"
            
          /*  if let imageSource = CGImageSourceCreateWithData(imageData!, nil) {
                let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)! as NSDictionary
                 print(imageProperties)
                print((imageProperties.value(forKey: "{Exif}")as! NSDictionary).value(forKey: "DateTimeOriginal"))
                print((imageProperties.value(forKey: "{Exif}")as! NSDictionary).value(forKey: "LensModel"))
                //now you have got meta data in imageProperties, you can display PixelHeight, PixelWidth, etc.
            } */


            let albumname = self.albumName
            
            if cell.btnCheck.isSelected == true {
                cell.btnCheck.isSelected = false
                
                //remove image from data base
               // let arr = DBManager.sharedManager.fetchItemFromDB(imageUrlStr)
                let arr = DBManager.sharedManager.fetchItemFromDB("OLD\(albumname)\(String(indexPath.row ))")
                DBManager.sharedManager.deleteRecordsFromDB(arr)
                self.setTitle()
                self.checkForSelectedIndex()
            }
            else if cell.btnCheck.isSelected == false {
                
                
                //UserDefaults.standard.setValue(sizeName[indexPath.row], forKey: "SizeName")
               print(Header.appDelegate.ProductName)
                
                
                UserDefaults.standard.setValue(Header.appDelegate.ProductName, forKey: "ProductName")
                UserDefaults.standard.setValue(Header.appDelegate.SizeName, forKey: "SizeName")
                print(UserDefaults.standard.value(forKey: "ProductName") as! String)
                
                if Header.appDelegate.ProductName == "PHOTOBOOKS" && self.imageCount == 20{
                    
                    let alert = UIAlertController(title: "Alert", message: "You have already selected  images!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    
                    cell.btnCheck.isSelected = true
                   
                    
                    //Given Album Name static
                    // let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("\(albumname)\(indexPath.row).png")
                    //let stringPath = "\(imagePAth)"
                    
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        AppManager.sharedManager.saveImageDocumentDirectory(imageValue: image1, albumname: albumname, indexValue: String(indexPath.row))
                        
                        self.rightBarButton.isUserInteractionEnabled = false
                        
                        DispatchQueue.main.async {
                            self.rightBarButton.isUserInteractionEnabled = true
                        }
                    }
                    
                    
                    //save image to albumTable
                    DBManager.sharedManager.saveAlbumTableValueInDataBase(UserDefaults.standard.value(forKey: "ProductName") as! String, UserDefaults.standard.value(forKey: "SizeName") as! String, albumname, String(indexPath.row ), "OLD\(albumname)\(String(indexPath.row ))", "noCroped", "0", andCompletionHandler: {(result: Bool) -> Void in
                        print("result is \(result)")
                        
                        
                        //save image to document directory
                        
                        
                        self.setTitle()
                        self.checkForSelectedIndex()
                        
                        }, andFalure: {(fail: NSError) -> Void in
                            print("fail is \(fail)")
                            self.setTitle()
                    })
                }
                
            }

        }

      

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
       
        
    }
    
    
    func pressed(sender:UIButton)
    {
        
        
    }
    //MARK: resize image
    
    func resize(_ theImage: UIImage, theNewSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(theNewSize, false, 1.0)
        theImage.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(theNewSize.width), height: CGFloat(theNewSize.height)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    //MARK:Core Data Delegate
    func saveToCoreDataResponse(responseStatus: Bool)
    {
        print(responseStatus)
    }
    
    func failToSaveToCoreDataResponse(Error:NSError)
    {
      print(Error)
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
