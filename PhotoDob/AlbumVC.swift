//
//  AlbumVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/3/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import Photos


class AlbumVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var imageAlbum = NSMutableArray()
    
    var imageDict = NSMutableDictionary()
    
    var fetchResults: [PHFetchResult<PHAssetCollection>] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "0 image selected"
        
      self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AlbumVC.returntoView))
        
        
        //add right navigation  button
        var imageInfo = UIImage(named: "tick")
        imageInfo = imageInfo?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageInfo, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AlbumVC.clickOnTick))
        

        self.setupPhotos()
        
    }
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func clickOnTick() {
        
       
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
        let albumResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        fetchResults = [cameraRollResult, albumResult]
        
        
        
        
//        let albumResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
//
//        fetchResults = [albumResult]
        
    
        
    
        
        
        
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
        
        let alert = UIAlertController(title: "Alert", message: "Under process!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func fotoliaAction(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Alert", message: "Under process!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
