//
//  AlbumVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/3/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import Photos
import CoreData

/*enum ViewToCrop {
    case photoPrint
    case photoBook
    case colladgePhotoFrame
    case tShirtPrint
    case customPrintedWallpaper
    case rollerBrindesPrinted
    case cushionsPrinted
    case toteBagsPrinted
}*/


class AlbumVC: UIViewController,UITableViewDelegate,UITableViewDataSource ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //MARK: Variables
    var imageAlbum = NSMutableArray()
    var imageDict = NSMutableDictionary()
    var fetchResults: [PHFetchResult<PHAssetCollection>] = []
    
    var indexPathValue = NSInteger()
    var indexSectionValue = NSInteger()
    var imageCount = NSInteger()
    
    var productName = String()
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    
    //MARK: Outlets
    
    @IBOutlet var btnAblumOnly: UIButton!
    
    
    
    
    //var season = ViewToCrop.photoPrint //used for crop view

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "0 Photos Selected"
        
        
    print(Header.appDelegate.ProductName)
        
        
      self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AlbumVC.returntoView))
        
        
        //add right navigation  button
       /* var imageInfo = UIImage(named: "tick")
        imageInfo = imageInfo?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageInfo, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AlbumVC.clickOnTick))
        */
        
        if Header.appDelegate.ProductName == "PHOTO PRINTS" || Header.appDelegate.ProductName == "PHOTOBOOKS" || Header.appDelegate.ProductName == "COLLAGED PHOTO FRAME" || Header.appDelegate.ProductName == "TOTE BAG PRINTED"{
            btnAblumOnly.isHidden = true
        }
        else {
            btnAblumOnly.isHidden = false
        }
        
        

        self.setupPhotos()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        DBManager.sharedManager.getSavedArrayFromDataBase( comletionHandler: {(result: [NSManagedObject]) -> Void in
            print("result is \(result)")
            self.imageCount = result.count
            self.title = "\(result.count) Photos Selected"
            }, andFalure: {(fail: Int) -> Void in
                print("fail is \(fail)")
                self.title = "0 Photos Selected"
                self.imageCount = 0
        })
    }
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //for use save value in database
    func clickOnTick() {
        
        if(self.imageCount>0){
            
           /*
            self.returnProductType(productname: Header.appDelegate.ProductName) //change enum type
           
            switch season {
            case .photoPrint:
                let cropVC = storyBoard.instantiateViewController(withIdentifier: "TapToCrop") as! TapToCrop
                self.navigationController?.pushViewController(cropVC, animated: true)
                
            case .photoBook:
                let photoBookVC = storyBoard.instantiateViewController(withIdentifier: "PhotoBookVC") as! PhotoBookVC
                self.navigationController?.pushViewController(photoBookVC, animated: true)
                
            case .colladgePhotoFrame:
                let colladgePhotoFrameVC = storyBoard.instantiateViewController(withIdentifier: "ColladgePhotoFrameVC") as! ColladgePhotoFrameVC
                self.navigationController?.pushViewController(colladgePhotoFrameVC, animated: true)
                
            case .tShirtPrint:
                print("tShirtPrint")
            case .customPrintedWallpaper:
                print("customPrintedWallpaper")
            case .rollerBrindesPrinted:
                print("rollerBrindesPrinted")
            case .cushionsPrinted:
                print("cushionsPrinted")
            case .toteBagsPrinted:
                print("toteBagsPrinted")
            default:
                print("Climate is not predictable")
            }
            */
            
            
            //PhotoBookCell
            
           
            
            
            
            
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
      /*  if(productname == "PHOTO PRINTS"){
            season = ViewToCrop.photoPrint
        }
        else if(productname == "PHOTO BOOKS"){
            season = ViewToCrop.photoBook
        }
        else if(productname == "COLLADGE PHOTO FRAME"){
            season = ViewToCrop.colladgePhotoFrame
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
        }*/
    }
    
    private func setupPhotos() {
        let fetchOptions = PHFetchOptions()
        if #available(iOS 9.0, *) {
            fetchOptions.includeAllBurstAssets = true
        } else {
            // Fallback on earlier versions
        }
        
//        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)
//        
//        let topLevelfetchOptions = PHFetchOptions()
//        
//        let topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollections(with: topLevelfetchOptions)
//        
//        var allAlbums = [topLevelUserCollections, smartAlbums]
//        
////                for i in 0 ..< allAlbums.count {
////                    let result = allAlbums[i]
        
        //            smartAlbums.enumerateObjects({ (collection, start, stop) in
        //                collection as! PHAssetCollection
        //                let assets = PHAsset.fetchAssets(in: collection, options: nil)
        //                assets.enumerateObjects({ (object, count, stop) in
        //
        //                    let imageAss = self.getAssetThumbnail(asset: object)
        //                    self.imageAlbum.add(imageAss)
        //                    print(self.imageAlbum)
        //                    print(object)
        //                    //allAlbums.append(object)
        //                })
        //                
        //            })
    //}
    
        
        let cameraRollResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: fetchOptions)
        
         //Albums fetch result
//        let albumResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//        fetchResults = [cameraRollResult, albumResult]
        
        
        //AppManager.sharedManager.activateView(self.view, loaderText: "Loading..")
        
        
        
        
        
        
        let albumResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        fetchResults = [albumResult]
        
    
        
    
        
        
        
    }
    
    
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
    
    @IBAction func cameraAction(_ sender: AnyObject) {
        
        picker?.delegate = self
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker!, animated: true, completion: nil)
        }
       
}
    
    // MARK: - UIImagePickerView Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker .dismiss(animated: true, completion: nil)
        
        //FrontImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        
    }
    //imgFirst.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
        picker .dismiss(animated: true, completion: nil)
        
    }

    

    
    @IBAction func fotoliaAction(_ sender: AnyObject) {
        
        let fotoliaVC = storyBoard.instantiateViewController(withIdentifier: "FotoliaVC") as! FotoliaVC
        self.navigationController?.pushViewController(fotoliaVC, animated: true)

        
       
    }
    
    
    
    
    //MARK: table view datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResults.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResults[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell")! as! AlbumCell
        
        //cell?.textLabel?.text = "WhatsApp Images"
        
        print(indexPath.section)
        let album = fetchResults[indexPath.section][indexPath.row]
        
        // Title
        cell.lblAlbumName.text = album.localizedTitle
        
        let albumCount = fetchResults[indexPath.section][indexPath.row]
        let countStr = initializePhotosDataSourceForValueImage(albumCount)
        cell.lblCountImage.text = "\(countStr) images"
        
        print(countStr)
        if countStr == "0" {
            cell.imageAlbum?.image = UIImage.init(named: "logo")
            
        }
        else{
            
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        let result = PHAsset.fetchAssets(in: album, options: fetchOptions)
        result.enumerateObjects({ (asset, idx, stop) in
            let imageSize = CGSize(width: 400, height: 400)
            let imageContentMode: PHImageContentMode = .aspectFill
            switch idx {
            case 0:
                PHCachingImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                    cell.imageAlbum?.image = result
                    print(result)
                }
                break;

                
            default:
                // Stop enumeration
                stop.initialize(to: true)
                break;
            }
        })

        }

         //cell?.imageView?.image = UIImage(named: "review-img")
        //cell?.imageView?.image = self.imageAlbum[indexPath.row] as! UIImage
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cropVC = storyBoard.instantiateViewController(withIdentifier: "TapToCrop") as! TapToCrop
//        self.navigationController?.pushViewController(cropVC, animated: true)
        
         let album = fetchResults[indexPath.section][indexPath.row]
        indexPathValue = indexPath.row
        indexSectionValue = indexPath.section
         initializePhotosDataSource(album)
        
       /*
         let album = fetchResults[indexPath.row]
        album.enumerateObjects({ (collection, start, stop) in
            collection as! PHAssetCollection
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            assets.enumerateObjects({ (object, count, stop) in
                
                let imageAss = self.getAssetThumbnail(asset: object)
                self.imageAlbum.add(imageAss)
                print(self.imageAlbum)
                print(object)
                //allAlbums.append(object)
            })
            
        })
        
        if self.imageAlbum.count>0
        {
            let photoCollectionVC = storyBoard.instantiateViewController(withIdentifier: "PhotoCollectionVC") as! PhotoCollectionVC
            photoCollectionVC.imageList = self.imageAlbum
            self.navigationController?.pushViewController(photoCollectionVC, animated: true)
        }
        */

        
        
        
    }
    func initializePhotosDataSource(_ album: PHAssetCollection, selections: PHFetchResult<PHAsset>? = nil) {
        // Set up a photo data source with album
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        initializePhotosDataSourceWithFetchResult(PHAsset.fetchAssets(in: album, options: fetchOptions), selections: selections)
    }
    
    func initializePhotosDataSourceWithFetchResult(_ fetchResult: PHFetchResult<PHAsset>, selections: PHFetchResult<PHAsset>? = nil) {
       
        let newDataSource = PhotoCollectionViewDataSource(fetchResult: fetchResult, selections: selections)
                let photoCollectionVC = storyBoard.instantiateViewController(withIdentifier: "PhotoCollectionVC") as! PhotoCollectionVC
        photoCollectionVC.fetchResult = newDataSource.fetchResult
        
        print(indexPathValue)
        let album = fetchResults[indexSectionValue][indexPathValue]
        
        // Title
        //used for 
        photoCollectionVC.albumName = album.localizedTitle!
        /*let navController = UINavigationController(rootViewController: photoCollectionVC)
        self.present(navController, animated: true, completion: nil)*/
        
        self.navigationController?.pushViewController(photoCollectionVC, animated: true)
      print(fetchResult.count)
    }
    
    
    
    //My work
    
    func initializePhotosDataSourceForValueImage(_ album: PHAssetCollection, selections: PHFetchResult<PHAsset>? = nil) -> NSString
    {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let isImageFound = initializePhotosDataSourceWithFetchResultForValueImage(PHAsset.fetchAssets(in: album, options: fetchOptions), selections: selections) as NSString
        return isImageFound
    }
    func initializePhotosDataSourceWithFetchResultForValueImage(_ fetchResult: PHFetchResult<PHAsset>, selections: PHFetchResult<PHAsset>? = nil) -> NSString {
        
        let newDataSource = PhotoCollectionViewDataSource(fetchResult: fetchResult, selections: selections)
       
        print(fetchResult.count)
        let myString = String(fetchResult.count)
        return myString as NSString
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
