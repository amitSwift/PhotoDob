//
//  PhotoBookVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 11/12/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import CoreData

class PhotoBookVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    //MARK:Outlets
    
    @IBOutlet var tblPhotoBook: UITableView!
    
    
    //MARK:Variables
    
    var imageArray = NSMutableArray()
    var mainImageArray = NSMutableArray()
    var cropedImageArray = NSMutableArray()
    var cropedStatusArray = NSMutableArray()
    var selectIndexArray = NSMutableArray()
    var albumNameArray = NSMutableArray()
    
    var albumManageObject = [NSManagedObject]()
    
    //MARK:implement leftImage and rightImage Work
    var leftMainImageArray = NSMutableArray()
    var rightMainImageArray = NSMutableArray()
    
    
    //MARK: work for add on cart
    
    var productName = String()
    var sizeOfProduct = String()
    var productImagesArr = NSMutableArray()
    var albumNameArr = NSMutableArray()
    
    var interChangeImageCount = NSInteger()
    var firstSelectIndexValue = NSInteger()
    var firstImageSelectd = Bool()
    
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PhotoBookVC.returntoView))
        
        
        //confirm navigation  button
        let button1 = UIBarButtonItem(image: UIImage(named: "imagename"), style: .plain, target: self, action: #selector(PhotoBookVC.confirmAction)) // action:#selector(Class.MethodName) for swift 3
        button1.title = "Confirm"
        self.navigationItem.rightBarButtonItem  = button1
        
        
        interChangeImageCount = 0
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
        
    
    func returntoView()
    {
        self.reSaveValueInDataBase()
        _ = navigationController?.popViewController(animated: true)
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
        
       
        
        
        tblPhotoBook.reloadData()
        
        
        
        //check condition for selected index
        //self.checkForSelectedIndex()
        
    }
    
    
    func confirmAction() {
        
        let alert = UIAlertController(title: "Alert", message: "Do yo want to add this product to Cart?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
        //event handler with closure
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            
            
            AppManager.sharedManager.activateView(self.view, loaderText: "Plaese wait...")
            self.reSaveValueInDataBase()
            
            self.pushToFronPageView()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func reSaveValueInDataBase(){
        
        //need to work for remove saved value in database
        let arr = DBManager.sharedManager.fetchImagesByProductNameFromDB(UserDefaults.standard.value(forKey: "ProductName") as! String)//remove value from database by size when changed size
        print(arr)
        DBManager.sharedManager.deleteRecordsFromDB(arr)
        
        
        // add interchanged value to data base to data base
        UserDefaults.standard.setValue(Header.appDelegate.ProductName, forKey: "ProductName")
        UserDefaults.standard.setValue(Header.appDelegate.SizeName, forKey: "SizeName")
        print(UserDefaults.standard.value(forKey: "ProductName") as! String)
        
        
        for i in 0 ..< mainImageArray.count
        {
            let albumname = albumNameArray[i] as! String
            //save image to albumTable
            DBManager.sharedManager.saveAlbumTableValueInDataBase(UserDefaults.standard.value(forKey: "ProductName") as! String, UserDefaults.standard.value(forKey: "SizeName") as! String, albumname, selectIndexArray[i] as! String, mainImageArray[i] as! String, cropedImageArray[i] as! String, cropedStatusArray[i] as! String, andCompletionHandler: {(result: Bool) -> Void in
                print("result is \(result)")
                }, andFalure: {(fail: NSError) -> Void in
                    print("fail is \(fail)")
            })
            
        }

        
    }
    
    func pushToFronPageView() {
        
        let addTitlePhotoBookVC = storyBoard.instantiateViewController(withIdentifier: "AddTitlePhotoBookVC") as! AddTitlePhotoBookVC
        addTitlePhotoBookVC.lastIndexForFrontImage = albumNameArray.count
        //addTitlePhotoBookVC.imagePath = mainImageArray[0] as! String
        self.navigationController?.pushViewController(addTitlePhotoBookVC, animated: true)
        
        AppManager.sharedManager.inActivateView(self.view)
    }
    
    
   
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:table view datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mainImageArray.count/2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoBookCell")! as! PhotoBookCell
        
       
        
        var indexValue = NSInteger()
        if indexPath.row%2 == 0 {
            indexValue = indexPath.row*2
        }else{
            indexValue = indexPath.row*2+1
        }
        
        
        cell.btnLeft.addTarget(self, action: #selector(PhotoBookVC.leftButtonAction(_:)), for: .touchUpInside)
        cell.btnLeft.tag = indexPath.row
        
        cell.btnRight.addTarget(self, action: #selector(PhotoBookVC.rightButtonAction(_:)), for: .touchUpInside)
        cell.btnRight.tag = indexPath.row
        
        cell.btnLeft.isSelected = false
        cell.btnRight.isSelected = false
        
        cell.btnLeft.layer.borderColor = UIColor.clear.cgColor
        cell.btnLeft.layer.borderWidth = 1
        cell.btnRight.layer.borderColor = UIColor.clear.cgColor
        cell.btnRight.layer.borderWidth = 1
        
        //long pressgesture
        let longPressRecognizerLeft = UILongPressGestureRecognizer(target: self, action: #selector(PhotoBookVC.longPressedLeft))
        cell.btnLeft.addGestureRecognizer(longPressRecognizerLeft)
        
        let longPressRecognizerRight = UILongPressGestureRecognizer(target: self, action: #selector(PhotoBookVC.longPressedRight))
        cell.btnRight.addGestureRecognizer(longPressRecognizerRight)
        
        firstImageSelectd = false
        interChangeImageCount = 0
        
        
        
        
        
        if (albumNameArray[indexPath.row]as! String == "Fotolia")//checked for fotolia image
        {
            
            if (cropedStatusArray[indexPath.row*2] as! String) == "1"{
                cell.leftImage.image = AppManager.sharedManager.getCropedImage(Int(selectIndexArray[indexPath.row*2] as! String)!,albumNameArray[indexPath.row] as! String)
                
            }
            if (cropedStatusArray[indexPath.row*2+1] as! String) == "1"{
                cell.rightImage.image = AppManager.sharedManager.getCropedImage(Int(selectIndexArray[indexPath.row*2+1] as! String)!,albumNameArray[indexPath.row] as! String)
                
            }
            if (cropedStatusArray[indexPath.row*2] as! String) == "0"{
                
                cell.leftImage.hnk_setImage(from: URL(string:mainImageArray[indexPath.row*2] as! String))
                
            }
            if (cropedStatusArray[indexPath.row*2+1] as! String) == "0"{
                cell.rightImage.hnk_setImage(from: URL(string:mainImageArray[indexPath.row*2+1] as! String))
            }
            
            
        }else{
            
            if (cropedStatusArray[indexPath.row*2] as! String) == "1"
            {
                DispatchQueue.global(qos: .utility).async {
                    cell.leftImage.image = AppManager.sharedManager.getCropedImage(Int(self.selectIndexArray[indexPath.row*2] as! String)!,self.albumNameArray[indexPath.row*2] as! String)
                    DispatchQueue.main.async {
                        
                    }
                }

            }
            if (cropedStatusArray[indexPath.row*2+1] as! String) == "1"{
                
                DispatchQueue.global(qos: .utility).async {
                    cell.rightImage.image = AppManager.sharedManager.getCropedImage(Int(self.selectIndexArray[indexPath.row*2+1] as! String)!,self.albumNameArray[indexPath.row*2+1] as! String)
                    DispatchQueue.main.async {
                    }
                }

            }
            
            if (cropedStatusArray[indexPath.row*2] as! String) == "0" {
                
                var image = UIImage()
                DispatchQueue.global(qos: .utility).async {
                    cell.leftImage.image = nil
                    
                    image = AppManager.sharedManager.getImageByPathOLD(self.mainImageArray[indexPath.row*2] as! String)!
                    DispatchQueue.main.async {
                        
                        cell.leftImage.image = image
                    }
                }
                
                /* let url = NSURL(string: mainImageArray[indexPath.row*2] as! String)
                 let imageData = NSData(contentsOf: url! as URL)
                 let imageValue : UIImage = UIImage(data: imageData as! Data)!
                 cell.btnLeft.setImage(imageValue, for: .normal)*/
            }
            if (cropedStatusArray[indexPath.row*2+1] as! String) == "0"{
                
                 var image = UIImage()
                DispatchQueue.global(qos: .utility).async {
                    cell.rightImage.image = nil
                    image = AppManager.sharedManager.getImageByPathOLD(self.mainImageArray[indexPath.row*2+1] as! String)!
                    DispatchQueue.main.async {
                        cell.rightImage.image = image
                    }
                }
                
                /* let url = NSURL(string: mainImageArray[indexPath.row*2+1] as! String)
                 let imageData = NSData(contentsOf: url! as URL)
                 let imageValue : UIImage = UIImage(data: imageData as! Data)!
                 cell.btnRight.setImage(imageValue, for: .normal)*/
            }
            
            
        }
        
        
        
        
       
        
        
//        if (cropedStatusArray[indexPath.row] as! String) == "1"
//        {
//            cell.btnLeft.setImage(self.getImage(Int(selectIndexArray[indexPath.row] as! String)!,albumNameArray[indexPath.row] as! String), for: .normal)
//            
//        }
//        else{
//            let url = NSURL(string: mainImageArray[indexPath.row] as! String)
//            let imageData = NSData(contentsOf: url! as URL)
//            let imageValue : UIImage = UIImage(data: imageData as! Data)!
//            cell.btnLeft.setImage(imageValue, for: .normal)
//        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        
        let lblReview = UILabel()
        lblReview.frame = CGRect(x: 0, y: 10, width: Int(self.view.frame.size.width), height: 20)
        lblReview.textAlignment = .center
        lblReview.textColor = UIColor.white
        lblReview.text = "PREVIEW YOUR BOOK"
        vw.addSubview(lblReview)
        
        let lblDescribe = UILabel()
        lblDescribe.frame = CGRect(x: 0, y: 35, width: Int(self.view.frame.size.width), height: 40)
        lblDescribe.textAlignment = .center
        lblDescribe.numberOfLines = 2
        lblDescribe.textColor = UIColor.white
        lblDescribe.font =  lblDescribe.font.withSize(12)
        lblDescribe.text = "Tap any two photo to swap the order,and tap & hold to adjust the crop, size allowing "
        vw.addSubview(lblDescribe)
        
        
        let shuffelBtn = UIButton()
        shuffelBtn.frame = CGRect(x: 20, y: 80, width: Int(self.view.frame.size.width-40), height: 40)
        shuffelBtn.backgroundColor = UIColor(red: 62/255, green: 164/255, blue: 167/255, alpha: 1.0)
        shuffelBtn.setTitle("SHUFFLE ALL", for: UIControlState.normal)
        shuffelBtn.titleLabel!.font =  UIFont(name: "Poppins Medium 14.0", size: 14)
        shuffelBtn.addTarget(self, action: #selector(PhotoBookVC.shuffleAll), for: .touchUpInside)
        vw.addSubview(shuffelBtn)
        
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return  130
    }
    
    //MARK:table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
    }
    
    func shuffleAll() {
        
    }
    
    
    func leftButtonAction(_ sender : UIButton)  {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tblPhotoBook.cellForRow(at: indexPath as IndexPath) as! PhotoBookCell
        
        if cell.btnLeft.isSelected == true{
            cell.btnLeft.isSelected = false
            cell.btnLeft.layer.borderColor = UIColor.clear.cgColor
            cell.btnLeft.layer.borderWidth = 1
            
            interChangeImageCount = 0
            firstSelectIndexValue = 0
            firstImageSelectd = false
            
            
        }else{
            cell.btnLeft.isSelected = true
            cell.btnLeft.layer.borderColor = UIColor.blue.cgColor
            cell.btnLeft.layer.borderWidth = 1
            
            interChangeImageCount = interChangeImageCount+1
            if(firstImageSelectd == false){
                firstSelectIndexValue = sender.tag*2
                firstImageSelectd = true
            }
            
            if( interChangeImageCount == 2 ){
                
                self.swapIndexValueOfTable(firstSelectIndexValue, sender.tag*2)
            }
        }
        
       
        
        //used for croping work
        
       /* let url = NSURL(string: mainImageArray[indexPath.row*2] as! String)
        let imageData = NSData(contentsOf: url! as URL)
        let imageValue : UIImage = UIImage(data: imageData as! Data)!
        
        
        let cropVC = storyBoard.instantiateViewController(withIdentifier: "CropVC") as! CropVC
        cropVC.imageforCrop = imageValue
        cropVC.indexValue = Int(selectIndexArray[indexPath.row*2] as! String)!
        cropVC.albumName = albumNameArray[indexPath.row*2] as! String
        //self.present(cropVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(cropVC, animated: true)*/
        
        
        
        
        

    }
    
    func rightButtonAction(_ sender : UIButton)  {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tblPhotoBook.cellForRow(at: indexPath as IndexPath) as! PhotoBookCell
        
        if cell.btnRight.isSelected == true{
            cell.btnRight.isSelected = false
            cell.btnRight.layer.borderColor = UIColor.clear.cgColor
            cell.btnRight.layer.borderWidth = 1
            
             interChangeImageCount = 0
             firstSelectIndexValue = 0
             firstImageSelectd = false
            
        }else{
            cell.btnRight.isSelected = true
            cell.btnRight.layer.borderColor = UIColor.blue.cgColor
            cell.btnRight.layer.borderWidth = 1
            
            
             interChangeImageCount = interChangeImageCount+1
            
            if(firstImageSelectd == false){
                firstSelectIndexValue = sender.tag*2+1
                firstImageSelectd = true
            }
            
            if( interChangeImageCount == 2 ){
                self.swapIndexValueOfTable(firstSelectIndexValue, sender.tag*2+1)
            }
        }
        
        
        
        //used for croping work
        
       /* let url = NSURL(string: mainImageArray[indexPath.row*2+1] as! String)
        let imageData = NSData(contentsOf: url! as URL)
        let imageValue : UIImage = UIImage(data: imageData as! Data)!
        
        
        let cropVC = storyBoard.instantiateViewController(withIdentifier: "CropVC") as! CropVC
        cropVC.imageforCrop = imageValue
        cropVC.indexValue = Int(selectIndexArray[indexPath.row*2+1] as! String)!
        cropVC.albumName = albumNameArray[indexPath.row*2+1] as! String
        //self.present(cropVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(cropVC, animated: true)*/
        
        

    }
    
    
    func swapIndexValueOfTable(_ firstIndex :NSInteger , _ secondIndex : NSInteger)
    {
        swap(&mainImageArray[firstIndex], &mainImageArray[secondIndex])
        swap(&cropedImageArray[firstIndex], &cropedImageArray[secondIndex])
        swap(&cropedStatusArray[firstIndex], &cropedStatusArray[secondIndex])
        swap(&selectIndexArray[firstIndex], &selectIndexArray[secondIndex])
        swap(&albumNameArray[firstIndex], &albumNameArray[secondIndex])
        
        print(mainImageArray)
        print(cropedImageArray)
        print(cropedStatusArray)
        print(selectIndexArray)
        print(albumNameArray)
        
        tblPhotoBook.reloadData()
    }
    
    func longPressedLeft(sender: UILongPressGestureRecognizer)
    {
        
        let location = sender.location(in: tblPhotoBook)
        var longIndexPath = tblPhotoBook.indexPathForRow(at: location)!
        
        
        
        var imageValue = UIImage()
        var imageUrlStr = String()
        
        if (albumNameArray[longIndexPath.row*2]as! String == "Fotolia"){
            imageUrlStr = mainImageArray[longIndexPath.row*2] as! String
            
        }else{
            imageUrlStr = ""
            imageValue = AppManager.sharedManager.getImageByPathOLD(mainImageArray[longIndexPath.row*2] as! String)!
        }
       
        
        let url = NSURL(string: mainImageArray[longIndexPath.row*2] as! String)
        //let imageData = NSData(contentsOf: url! as URL)
       // let imageValue : UIImage = UIImage(data: imageData as! Data)!
        
        /*let imageValue : UIImage = self.getImageByPathOLD(mainImageArray[longIndexPath.row*2] as! String)*/
        
        let cropVC = storyBoard.instantiateViewController(withIdentifier: "CropVC") as! CropVC
        cropVC.imageforCrop = imageValue
        cropVC.fotoliaImageUrlStr = imageUrlStr
        cropVC.indexValue = Int(selectIndexArray[longIndexPath.row*2] as! String)!
        cropVC.albumName = albumNameArray[longIndexPath.row*2] as! String
        cropVC.vcName = "photoBookVC"
        
//        let navController = UINavigationController(rootViewController: cropVC)
//        self.present(navController, animated: true, completion: nil)
        //self.present(cropVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(cropVC, animated: true)
    }
    
    func longPressedRight(sender: UILongPressGestureRecognizer)  {
        
        let location = sender.location(in: tblPhotoBook)
        var longIndexPath = tblPhotoBook.indexPathForRow(at: location)!
        
        
        
        let url = NSURL(string: mainImageArray[longIndexPath.row*2+1] as! String)
        //let imageData = NSData(contentsOf: url! as URL)
        //let imageValue : UIImage = UIImage(data: imageData as! Data)!
        
        
        
        var imageValue = UIImage()
        var imageUrlStr = String()
        
        if (albumNameArray[longIndexPath.row*2+1]as! String == "Fotolia"){
            imageUrlStr = mainImageArray[longIndexPath.row*2+1] as! String
            
        }else{
            imageUrlStr = ""
            imageValue = AppManager.sharedManager.getImageByPathOLD(mainImageArray[longIndexPath.row*2+1] as! String)!
        }
        
        
        /*let imageValue : UIImage = self.getImageByPathOLD(mainImageArray[longIndexPath.row*2+1] as! String)*/
        
        let cropVC = storyBoard.instantiateViewController(withIdentifier: "CropVC") as! CropVC
        cropVC.imageforCrop = imageValue
        cropVC.fotoliaImageUrlStr = imageUrlStr
        cropVC.indexValue = Int(selectIndexArray[longIndexPath.row*2+1] as! String)!
        cropVC.albumName = albumNameArray[longIndexPath.row*2+1] as! String
        cropVC.vcName = "photoBookVC"
        //        let navController = UINavigationController(rootViewController: cropVC)
        //        self.present(navController, animated: true, completion: nil)
        //self.present(cropVC, animated: true, completion: nil)
       self.navigationController?.pushViewController(cropVC, animated: true)
     }
    
    
    
    
    /*func getImage(_ indexValue:NSInteger,_ albumName:String)->UIImage{
        let fileManager = FileManager.default
        let imagePAth = (AppManager.sharedManager.getDirectoryPath() as NSString).appendingPathComponent("\(albumName)\(indexValue).png")
        
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
    func getImageByPathOLD(_ imageName:String)->UIImage{
        let fileManager = FileManager.default
        let imagePAth = (AppManager.sharedManager.getDirectoryPath() as NSString).appendingPathComponent("\(imageName).png")
        
        if fileManager.fileExists(atPath: imagePAth){
            print(imagePAth)
            //self.imageView.image = UIImage(contentsOfFile: imagePAth)
            
            
            return UIImage(contentsOfFile: imagePAth)!
        }else{
            print("No Image")
        }
        return UIImage(contentsOfFile: imagePAth)!
        
    }
    */
 

    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
