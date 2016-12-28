//
//  FotoliaVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 11/23/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import CoreData

class FotoliaVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,WebServiceDelegate{

    //MARK:Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: Varialbes
    
    var imageArr = NSArray()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var imageCount = NSInteger()
    var people = [NSManagedObject]()
    var selectedIndexArr = NSMutableArray()
    
    var season = ViewToCrop.photoPrint //used for crop view
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
        
        
        
        
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(FotoliaVC.returntoView))
        
        
        
        //add right navigation  button
      /*  var imageInfo = UIImage(named: "tick-active")
        imageInfo = imageInfo?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageInfo, style: UIBarButtonItemStyle.plain, target: self, action: #selector(FotoliaVC.clickOnTick))*/
        
        
        rightBarButton = UIButton.init(type: .custom)
        rightBarButton.setImage(UIImage.init(named: "tick-active"), for: UIControlState.normal)
        rightBarButton.setImage(UIImage.init(named: "tick"), for: UIControlState.selected)
        rightBarButton.addTarget(self, action:#selector(FotoliaVC.clickOnTick), for: UIControlEvents.touchUpInside)
        rightBarButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: rightBarButton)
        self.navigationItem.rightBarButtonItem = barButton

        
        
        AppManager.sharedManager.delegate=self
        AppManager.sharedManager.activateView(self.view, loaderText: "Loading")
        let params: [String: AnyObject] = [:]
        
        AppManager.sharedManager.postDataOnserver(params: params as AnyObject, postUrl: Header.KGetFotoliaImages as NSString)
        
        self.setTitle()
        
                

        // Do any additional setup after loading the view.
    }
    
    func returntoView() {
        UIView.setAnimationsEnabled(true)
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
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
            }
            
            
            print(self.imageCount)
            
            }, andFalure: {(fail: Int) -> Void in
                print("fail is \(fail)")
                self.title = "0 "
                self.imageCount = 0
                self.rightBarButton.isSelected = true
        })
        
        
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
            if (person.value(forKey: "albumName")as! String) == "Fotolia"{
                selectedIndexArr.add(person.value(forKey: "selectImageName") as! String)
            }
            
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
        else if(productname == "COLLAGED PHOTO FRAME"){
            season = ViewToCrop.collagedPhotoFrame
        }
        else if(productname == "T SHIRT PRINTING"){
            season = ViewToCrop.tShirtPrint
        }
        else if(productname == "CUSTOM PHOTO FRAME"){
            season = ViewToCrop.customPrintedWallpaper
        }
        else if(productname == "ROLLER BLINDES PRINTED"){
            season = ViewToCrop.rollerBrindesPrinted
        }
        else if(productname == "CUSIONS PRINTED"){
            season = ViewToCrop.cushionsPrinted
        }
        else if(productname == "TOTE BAG PRINTED"){
            season = ViewToCrop.toteBagsPrinted
        }
    }

    


    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:webservice delegate
    
    func serverReponse(responseDict: NSDictionary,serviceurl:NSString)
    {
        AppManager.sharedManager.inActivateView(self.view)
        if serviceurl as String == Header.KGetFotoliaImages {
            
            print(responseDict.value(forKey: "images") as! NSArray)
            let result=responseDict.value(forKey: "result")as! Bool
            
            
            if result == true{
                
                imageArr = responseDict.value(forKey: "images")as! NSArray 
                collectionView.reloadData()
                self.checkForSelectedIndex()
            }
            else{
                let alert = UIAlertController(title: "Alert", message: responseDict.value(forKey: "error")as? String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                UserDefaults.standard.set(false, forKey: "isLogedIn")
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
    

    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 5
        return imageArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //UIView.setAnimationsEnabled(false)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.accessibilityIdentifier = "photo_cell_\(indexPath.item)"
        
        
        
        //cell.backgroundColor = UIColor.red
        cell.frame.size.width = screenWidth / 3
        cell.frame.size.height = screenWidth / 3
        cell.btnCheck.tag = indexPath.row
        
        if selectedIndexArr.contains((self.imageArr[indexPath.row] as AnyObject).value(forKey: "src") as! String) {
            cell.btnCheck.isSelected = true
        }
        else{
            cell.btnCheck.isSelected = false
        }
        
        
        //cell.activitiView.stopAnimating()
        cell.activitiView.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            //cell.activitiView.startAnimating()
            
            //cell.imageView.hnk_setImage(from: URL(string: (self.imageArr[indexPath.row] as AnyObject).value(forKey: "src") as! String))
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
               // cell.activitiView.stopAnimating()
                cell.imageView.hnk_setImage(from: URL(string: (self.imageArr[indexPath.row] as AnyObject).value(forKey: "src") as! String))
            }
        }

        
        
        
        
        
       
        
       
        
        //cell.imageView.imageURL = URL(string: "https://s.ftcdn.net/r/v2010/d42a432d185126c9a3c3b30a18254fae3e6cb7d1/pics/all/fader/65423201-1000-391-rounded.jpg")
        
        
        
        UIView.setAnimationsEnabled(true)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
        let cell = collectionView.cellForItem(at: indexPath)as! PhotoCell
        
        let albumname = "Fotolia" //define Album name
        let imagePathStr = (self.imageArr[indexPath.row] as AnyObject).value(forKey: "src") as! String
        
        if cell.btnCheck.isSelected == true {
            cell.btnCheck.isSelected = false
            
            //remove image from data base
            
            let arr = DBManager.sharedManager.fetchItemFromDB(imagePathStr)
            DBManager.sharedManager.deleteRecordsFromDB(arr)
            self.setTitle()
           // self.checkForSelectedIndex()
        }
        else if cell.btnCheck.isSelected == false {
            
            
            //UserDefaults.standard.setValue(sizeName[indexPath.row], forKey: "SizeName")
            
            
            UserDefaults.standard.setValue(Header.appDelegate.ProductName, forKey: "ProductName")
            UserDefaults.standard.setValue(Header.appDelegate.SizeName, forKey: "SizeName")
            print(UserDefaults.standard.value(forKey: "ProductName") as! String)
            
            if Header.appDelegate.ProductName == "PHOTOBOOKS" && self.imageCount == 20{
                
                let alert = UIAlertController(title: "Alert", message: "You have already sselected  images !", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                
                cell.btnCheck.isSelected = true
                
               
                
                
                //save image to albumTable
                DBManager.sharedManager.saveAlbumTableValueInDataBase(UserDefaults.standard.value(forKey: "ProductName") as! String, UserDefaults.standard.value(forKey: "SizeName") as! String, albumname, String(indexPath.row ), imagePathStr, "noCroped", "0", andCompletionHandler: {(result: Bool) -> Void in
                    print("result is \(result)")
                    
                    DispatchQueue.global(qos: .utility).async {
                        //self.saveImageDocumentDirectory(imageValue: image1, albumname: albumname, indexValue: String(indexPath.row))
                        DispatchQueue.main.async {
                        }
                    }
                    
                    self.setTitle()
                    //self.checkForSelectedIndex()
                    
                    }, andFalure: {(fail: NSError) -> Void in
                        print("fail is \(fail)")
                        self.setTitle()
                })
            }
            
            
        }

        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        
        
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
