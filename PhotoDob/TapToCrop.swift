//
//  TapToCrop.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/3/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import CoreData

 var cropedImageArr = NSMutableArray()//global value for crop image array
 var isCroped = false





class TapToCrop: UIViewController ,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{

    var imageArray = NSMutableArray()
    var mainImageArray = NSMutableArray()
    var cropedImageArray = NSMutableArray()
    var cropedStatusArray = NSMutableArray()
    var selectIndexArray = NSMutableArray()
    var albumNameArray = NSMutableArray()
    
    var albumManageObject = [NSManagedObject]()
    
    //MARK: Outlets
    
    @IBOutlet var cropTableView: UITableView!
    
    //MARK: work for add on cart
    
    var productName = String()
    var sizeOfProduct = String()
    var productImagesArr = NSMutableArray()
    var albumNameArr = NSMutableArray()
    
    var sizeRatioOfCell = Float()
    var primaryKeyCount = String()
    var mainCartArray = NSMutableArray()
    
    //Lazy loading work
    var mainImageArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(TapToCrop.returntoView))
        
        
        
        //confirm navigation  button
        let button1 = UIBarButtonItem(image: UIImage(named: "imagename"), style: .plain, target: self, action: #selector(TapToCrop.confirmAction)) // action:#selector(Class.MethodName) for swift 3
        button1.title = "Confirm"
        self.navigationItem.rightBarButtonItem  = button1
        
      
        sizeRatioOfCell = Float(Header.appDelegate.imageHeightForCrop)!/Float(Header.appDelegate.imageWidthForCrop)!
        
        cropTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        
        
        
        //check condition for selected index
        //self.checkForSelectedIndex()

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        //check for saved value in album table
        DBManager.sharedManager.getSavedArrayFromDataBase( comletionHandler: {(result: [NSManagedObject]) -> Void in
            print("result is \(result)")
            
            self.title = "\(result.count)"
            
            self.albumManageObject = result
            
            print(self.albumManageObject)
            print(self.albumManageObject.count)
            
            }, andFalure: {(fail: Int) -> Void in
                print("fail is \(fail)")
                self.title = "0"
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
            
           /* if (self.getImageByPathOLD(mainImageArray[i] as! String) != nil){
             mainImageArr.add(self.getImageByPathOLD(mainImageArray[i] as! String))
            }*/
        }
        
        cropTableView.reloadData()

        
    
        //check condition for selected index
        //self.checkForSelectedIndex()
        
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
            let results = try managedContext.fetch(fetchRequest)
                
            albumManageObject = results as! [NSManagedObject]
            
            print(albumManageObject)
            print(albumManageObject.count)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        mainImageArray = NSMutableArray()
        cropedImageArray = NSMutableArray()
        cropedStatusArray = NSMutableArray()
        for i in 0 ..< albumManageObject.count{
            let albumObject = albumManageObject[i]
            mainImageArray.add(albumObject.value(forKey: "selectImageName") as! String)
            cropedImageArray.add(albumObject.value(forKey: "cropedImageName") as! String)
            cropedStatusArray.add(albumObject.value(forKey: "isCroped") as! String)
            selectIndexArray.add(albumObject.value(forKey: "selectedImageIndexValue") as! String)
        }
        
        cropTableView.reloadData()
        
        
    }

    
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func confirmAction() {
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    
    //MARK:tableview delegate
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    return mainImageArray.count
     
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellHeight = self.view.frame.size.width * CGFloat(sizeRatioOfCell)
        print(cellHeight,self.view.frame.size.width)
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FrameCell")! as! FrameCell
        
        cell.tapPhotoToCrop.addTarget(self, action: #selector(pressedForCroping(sender:)), for: .touchUpInside)
        cell.tapPhotoToCrop.tag = indexPath.row
        
        cell.btnUp.addTarget(self, action: #selector(pressedForIncreaseQuantity(sender:)), for: .touchUpInside)
         cell.btnUp.tag = indexPath.row
        
        cell.btnDown.addTarget(self, action: #selector(pressedForDecreaseQuantity(sender:)), for: .touchUpInside)
        cell.btnDown.tag = indexPath.row
        
        //cell.frame.size.height = cell.frame.size.width * CGFloat(sizeRatioOfCell)
        
        if (albumNameArray[indexPath.row]as? String == "Fotolia"){
            
            if (cropedStatusArray[indexPath.row] as! String) == "1"{
                cell.backImage.image = AppManager.sharedManager.getCropedImage(Int(selectIndexArray[indexPath.row] as! String)!,albumNameArray[indexPath.row] as! String)
                
            }else{
                
                
                    cell.backImage.hnk_setImage(from: URL(string:self.mainImageArray[indexPath.row] as! String))
                //cell.backImage.sd_setImage(with: URL(string:self.mainImageArray[indexPath.row] as! String), placeholderImage:nil)

               
            }
            
            
        }else{
            if (cropedStatusArray[indexPath.row] as! String) == "1"
            {
                 var image = UIImage()
                
                DispatchQueue.global(qos: .background).async {
                    cell.backImage.image = UIImage.init(named: "")
                     image = AppManager.sharedManager.getCropedImage(Int(self.selectIndexArray[indexPath.row] as! String)!,self.albumNameArray[indexPath.row] as! String)
                    DispatchQueue.main.async {
                        cell.backImage.image = image
                    }
                }

                
               
            }
            else{
                
                var image = UIImage()
                
                //cell.backImage.image  = self.getImageByPathOLD(self.mainImageArray[indexPath.row] as! String)!
                DispatchQueue.global(qos: .background).async {
                    cell.backImage.image = UIImage.init(named: "")
                    
                    if (AppManager.sharedManager.getImageByPathOLD(self.mainImageArray[indexPath.row] as! String) != nil){
                       image  = AppManager.sharedManager.getImageByPathOLD(self.mainImageArray[indexPath.row] as! String)!
                        //cell.backImage.image = mainImageArr[indexPath.row] as? UIImage
                    }
                    
                    DispatchQueue.main.async {
                        cell.backImage.image = image
                    }
                }
                
                
                
                //cell.backImage.image = self.getImageByPath(mainImageArray[indexPath.row] as! String)
                // cell.backImage.image  = UIImage(contentsOfFile: mainImageArray[indexPath.row] as! String)
                /* let url = NSURL(string: mainImageArray[indexPath.row] as! String) as! URL
                 
                 let imageData = NSData(contentsOf: url )
                 let imageValue : UIImage = UIImage(data: imageData as! Data)!
                 cell.backImage.image = imageValue*/
            }
            
        }
        
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let url = NSURL(string: mainImageArray[indexPath.row] as! String)
       // let imageData = NSData(contentsOf: url! as URL)
        //let imageValue : UIImage = UIImage(data: imageData as! Data)! //
        var imageValue = UIImage()
        var imageUrlStr = String()
        
        if (albumNameArray[indexPath.row]as? String == "Fotolia"){
            imageUrlStr = mainImageArray[indexPath.row] as! String
            
        }else{
            imageUrlStr = ""
            imageValue = AppManager.sharedManager.getImageByPathOLD(mainImageArray[indexPath.row] as! String)!
        }
        
        let cropVC = storyBoard.instantiateViewController(withIdentifier: "CropVC") as! CropVC
        cropVC.imageforCrop = imageValue
        cropVC.fotoliaImageUrlStr = imageUrlStr
        cropVC.indexValue = Int(selectIndexArray[indexPath.row] as! String)!
        cropVC.albumName = albumNameArray[indexPath.row] as! String
        cropVC.vcName = "tapToCropVC"
        //self.present(cropVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(cropVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
   /* func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }*/
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        
        let lblReview = UILabel()
        lblReview.frame = CGRect(x: 0, y: 10, width: Int(self.view.frame.size.width), height: 30)
        lblReview.textAlignment = .center
        lblReview.textColor = UIColor.white
        lblReview.text = "REVIEW & CROP"
        vw.addSubview(lblReview)
        
        let lblDescribe = UILabel()
        lblDescribe.frame = CGRect(x: 0, y: 45, width: Int(self.view.frame.size.width), height: 60)
        lblDescribe.textAlignment = .center
        lblDescribe.numberOfLines = 3
        lblDescribe.textColor = UIColor.white
        lblDescribe.font =  lblDescribe.font.withSize(12)
        lblDescribe.text = "Scroll to review your prints,and tap any image to adjust the crop.\nYour photos will look like this in real life,including borders and\n white spaces."

        vw.addSubview(lblDescribe)
        
        return vw
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
     {
        return  100
    }

   
    
    
    func pressedForCroping(sender: UIButton!)
    {
        let url = NSURL(string: mainImageArray[sender.tag] as! String)
      //  let imageData = NSData(contentsOf: url! as URL)
        //let imageValue : UIImage = UIImage(data: imageData as! Data)!
         //let imageValue : UIImage = self.getImageByPathOLD(mainImageArray[sender.tag] as! String)
        
        
        var imageValue = UIImage()
        var imageUrlStr = String()
        
        if (albumNameArray[sender.tag]as? String == "Fotolia"){
            imageUrlStr = mainImageArray[sender.tag] as! String
            
        }else{
            imageUrlStr = ""
            imageValue = AppManager.sharedManager.getImageByPathOLD(mainImageArray[sender.tag] as! String)!
        }

        
        
        let cropVC = storyBoard.instantiateViewController(withIdentifier: "CropVC") as! CropVC
        cropVC.imageforCrop = imageValue
        cropVC.fotoliaImageUrlStr = imageUrlStr
        cropVC.indexValue = Int(selectIndexArray[sender.tag] as! String)!
        cropVC.albumName = albumNameArray[sender.tag] as! String
         cropVC.vcName = "tapToCropVC"
        //self.present(cropVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(cropVC, animated: true)
    }
    
    
    func pressedForIncreaseQuantity(sender: UIButton ) {
        
    }
    
    func pressedForDecreaseQuantity(sender: UIButton ) {
        
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
