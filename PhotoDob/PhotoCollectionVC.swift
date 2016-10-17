//
//  PhotoCollectionVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/10/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import Photos



class PhotoCollectionVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet var collectionView: UICollectionView!
    
   /*  var imageList = NSMutableArray()
     let photoCellIdentifier = "PhotoCell"*/
    
   var selections = [PHAsset]()
    var fetchResult = PHFetchResult<PHAsset>()
    
    var imageSize: CGSize = CGSize.zero
    
    
    fileprivate let photoCellIdentifier = "PhotoCell"
    fileprivate let photosManager = PHCachingImageManager.default()
    fileprivate let imageContentMode: PHImageContentMode = .aspectFill
   // var imageSize = CGSize(width: 300, height: 300) //give size of image
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
   
   
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! PhotoCell
        cell.accessibilityIdentifier = "photo_cell_\(indexPath.item)"
       
        
//        let asset = fetchResult[indexPath.row]
//        cell.imageView.image = imageList[indexPath.row] as? UIImage
        
        cell.backgroundColor = UIColor.red
        cell.frame.size.width = screenWidth / 3
        cell.frame.size.height = screenWidth / 3
        cell.btnCheck.tag = indexPath.row
        
//        if indexPath.row == 0{
//            cell.btnCheck.isSelected = true
//        }
        //cell.btnCheck.addTarget(self, action: #selector(PhotoCollectionVC.pressed), for: .touchUpInside)
        
        let asset = fetchResult[indexPath.row]
        cell.asset = asset
        
        // Request image
        cell.tag = Int(photosManager.requestImage(for: asset as PHAsset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: imageContentMode, options: nil) { (result, _) in
            cell.imageView.image = result
        })
        
        // Set selection number
        if  let indexPath = selections.index(of: asset) {
           
            cell.btnCheck.isSelected = true
        } else {
            cell.btnCheck.isSelected = false

        }
        
        UIView.setAnimationsEnabled(true)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//                let cropVC = storyBoard.instantiateViewController(withIdentifier: "TapToCrop") as! TapToCrop
//                self.navigationController?.pushViewController(cropVC, animated: true)
        
        let cell = collectionView.cellForItem(at: indexPath)as! PhotoCell
        
        let asset = self.fetchResult.object(at: indexPath.row)
        
        asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (input, _) in
            let url = input?.fullSizeImageURL
            let imageData = NSData(contentsOf: url!)
            let image1 : UIImage = UIImage(data: imageData as! Data)!
            

            
            print(url!)
        }
        photosManager.requestImage(for: asset as PHAsset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: imageContentMode, options: nil) { (result, _) in
            cell.imageView.image = result
        }
        
       
        if cell.btnCheck.isSelected == true {
            cell.btnCheck.isSelected = false
            
            //self.selections.remove(at: indexPath.row)
            
        }
        else if cell.btnCheck.isSelected == false {
            cell.btnCheck.isSelected = true
            
            //self.selections.append(asset)
        }
        
      

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        
    }
    
    
    func pressed(sender:UIButton)
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
